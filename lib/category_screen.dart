import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/Check.dart';
import 'package:eshop/category.dart';
import 'package:eshop/detailscreen.dart';
import 'package:eshop/mainurl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  Category c;
  // const CategoryScreen({super.key});
  CategoryScreen(this.c);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState(c);
}

class _CategoryScreenState extends State<CategoryScreen> {
  Category c;
  _CategoryScreenState(this.c);

  List<Cloth> products = [];

  Future getData(String category) async {
    final url = Uri.parse('${MyUrl.fullurl}catagories.php');

    final response = await http.post(
      url,
      body: {
        'category': c.name,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> cloth = json.decode(response.body);
      setState(() {
        products = cloth.map((clothData) {
          return Cloth(
              id: clothData["PId"].toString(),
              name: clothData["productname"].toString(),
              image: clothData["productimage"],
              price: clothData["productprice"].toString(),
              description: clothData["productdescription"].toString());
        }).toList();
        // _isLoading = false;
      });
      return products;
    } else {
      Fluttertoast.showToast(msg: "Failed");
    }
  }

  @override
  void initState() {
    getData(c.name);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double a = MediaQuery.of(context).size.height * 0.65;
    double b = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${c.name}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  fontFamily: "NotoSans"),
            ),
            centerTitle: true,
            backgroundColor: Colors.pink,
          ),
          body: products.isNotEmpty
              ? GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: b / a,
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(products[index]),
                            ));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CachedNetworkImage(
                            imageUrl: MyUrl.fullurl + products[index].image,
                            // errorWidget: (context, url, error) =>
                            //     Icon(Icons.error),
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            imageBuilder: (context, imageProvider) {
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: Container(
                                  // height: MediaQuery.sizeOf(context).height,
                                  // width: 300,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // color: Colors.black,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Text(
                            products[index].name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          )
                        ],
                      ),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
