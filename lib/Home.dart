import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/Check.dart';
import 'package:eshop/category.dart';
import 'package:eshop/category_screen.dart';
import 'package:eshop/detailscreen.dart';
import 'package:eshop/mainurl.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'globalclass.dart' as globalclass;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Cloth> men = [];

  List<Cloth> women = [];

  List<Category> category = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getCategory();
    getDress();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getData() async {
    try {
      final response =
          await http.get(Uri.parse('${MyUrl.fullurl}cloth_fetch.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // print(data);

        setState(() {
          men = data.map((clothData) {
            return Cloth(
                id: clothData["PId"].toString(),
                name: clothData["productname"].toString(),
                image: clothData["productimage"],
                price: clothData["productprice"].toString(),
                description: clothData["productdescription"].toString());
          }).toList();
          // _isLoading = false;
        });
        for (int i = 0; i < men.length; i++) {
          globalclass.menproduct.add(men[i]);
        }
      }
      return men;
    } catch (e) {
      print(e);
    }
  }

  Future getDress() async {
    try {
      final response = await http.get(Uri.parse('${MyUrl.fullurl}women.php'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          women = data.map((dressData) {
            return Cloth(
                id: dressData["PId"],
                name: dressData["productname"],
                image: dressData["productimage"],
                price: dressData["productprice"],
                description: dressData["productdescription"]);
          }).toList();
          // _isLoading = false;
        });
        for (int i = 0; i < women.length; i++) {
          globalclass.womenproduct.add(women[i]);
        }
      }
      return women;
    } catch (e) {
      print(e);
    }
  }

  Future getCategory() async {
    try {
      final response =
          await http.post(Uri.parse("${MyUrl.fullurl}categories_fetch.php"));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          category = data.map((categoryData) {
            return Category(
              id: categoryData["categoryId"].toString(),
              name: categoryData["categoryname"].toString(),
              image: categoryData['categoryimage'],
            );
          }).toList();
        });
        for (int i = 0; i < category.length; i++) {
          globalclass.categories.add(category[i]);
        }
      }
      return category;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _refreshData() async {
    await getCategory();
    setState(
      () {
        category.clear();
        men.clear();
        women.clear();
        getCategory();
        getDress();
        getData();
        FocusScope.of(context).unfocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontFamily: "NotoSans"),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 150,
                    child: ListView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: category.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8, right: 4),
                          child: InkWell(
                            splashColor: Colors.blueAccent,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CategoryScreen(category[index]),
                                  ));
                            },
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Container(
                                // color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 50,
                                      child: CachedNetworkImage(
                                        imageUrl: MyUrl.fullurl +
                                            category[index].image,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageBuilder: (context, imageProvider) {
                                          return Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Container(
                                              height: 100,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          category[index].name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Featured",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontFamily: "NotoSans"),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  men.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Container(
                            alignment: Alignment.center,
                            height: 350,
                            child: ListView.builder(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: men.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 4),
                                  child: InkWell(
                                    onTap: () {
                                      // Handle tap on image
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                // image:
                                                //     MyUrl.fullurl + _clothes[index].image,
                                                // name: _clothes[index].name,
                                                // price: _clothes[index].price,
                                                // description: _clothes[index].description,
                                                men[index]),
                                          ));
                                    },
                                    child: SizedBox(
                                      height: 180,
                                      width: 180,
                                      child: Container(
                                        // color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: MyUrl.fullurl +
                                                  men[index].image,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Container(
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                men[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.all(8.0),
                                            //   child: Text(
                                            //     _clothes[index].description,
                                            //     style: TextStyle(
                                            //       fontSize: 12,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 50),
                          child: CircularProgressIndicator(),
                        ),
                  const Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Featured",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                              fontFamily: "NotoSans"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  women.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Container(
                            alignment: Alignment.center,
                            height: 350,
                            child: ListView.builder(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: women.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(left: 4, right: 4),
                                  child: InkWell(
                                    onTap: () {
                                      // Fluttertoast.showToast(
                                      //     msg: _dress[index].image.toString());
                                      // Handle tap on image
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                                // image:
                                                //     MyUrl.fullurl + _clothes[index].image,
                                                // name: _clothes[index].name,
                                                // price: _clothes[index].price,
                                                // description: _clothes[index].description,
                                                women[index]),
                                          ));
                                    },
                                    child: SizedBox(
                                      height: 180,
                                      width: 180,
                                      child: Container(
                                        // color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: MyUrl.fullurl +
                                                  women[index].image,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return Container(
                                                  height: 250,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                women[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.all(8.0),
                                            //   child: Text(
                                            //     _clothes[index].description,
                                            //     style: TextStyle(
                                            //       fontSize: 12,
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 50),
                          child: CircularProgressIndicator(),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
