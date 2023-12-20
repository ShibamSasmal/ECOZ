import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/Check.dart';
import 'package:eshop/mainurl.dart';
import 'package:eshop/payment_method_screen.dart';
import 'package:eshop/user_cart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  Cloth cloth;
  DetailScreen(this.cloth);

  @override
  State<DetailScreen> createState() => _DetailScreenState(cloth);
}

class _DetailScreenState extends State<DetailScreen> {
  Cloth cloth;
  _DetailScreenState(this.cloth);

  Future<void> addToCart(String productId, int quantity) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String id = pref.getString("id") ?? "";

    // Create the request body
    Map<String, String> requestBody = {
      'id': id,
      'PId': productId,
      'quantity': quantity.toString(),
    };

    try {
      final url = Uri.parse('${MyUrl.fullurl}addcart.php');

      final response = await http.post(url, body: requestBody);

      // Make POST request to your PHP script
      // final response = await http.post(Uri.parse(apiUrl),
      //  body: requestBody);

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> data = jsonDecode(response.body);
        // print(data);

        // Handle the response data
        if (data['status'] == 'true') {
          // Product added successfully
          Fluttertoast.showToast(msg: '${data['msg']}');
          print('Product added to cart: ${data['msg']}');
        } else {
          // Failed to add product
          Fluttertoast.showToast(msg: '${data['msg']}');
          print('Failed to add product to cart: ${data['msg']}');
        }
      } else {
        // Handle errors
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  List<bool> clickedColor = [false, false, false, false];
  List<Color> productColor = [
    Color.fromARGB(255, 240, 85, 73),
    Color.fromARGB(255, 113, 246, 117),
    Color.fromARGB(255, 87, 164, 226),
    Color.fromARGB(255, 247, 25, 99)
  ];
  List<bool> clickedSize = [false, false, false, false];

  List<String> productSize = ["s", "M", "L", "XL"];

  String size = '';

  int count = 1;
  Widget _buildSizeProduct({required String name, required bool click}) {
    if (click) {
      size = name;
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: click
            ? Border.all(color: Colors.blue, width: 4)
            : Border.all(color: Colors.white, width: 2),
      ),
      height: 60,
      width: 60,
      // color: Color(0xfff2f2f2),
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildColorProduct({required Color color, required bool clicked}) {
    // if (clicked) {
    //   print(color);
    // }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        border: clicked
            ? Border.all(color: Colors.amber, width: 4)
            : Border.all(color: Colors.white, width: 2),
      ),
      height: 60,
      width: 60,
    );
  }

  Widget _buildImage() {
    return Center(
      child: Container(
        height: 500,
        width: 350,
        child: Card(
          child: Container(
            padding: EdgeInsets.all(13),
            child: Container(
              height: 220,
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //         fit: BoxFit.fill,
              //         image: Image.network(widget.image))),
              child: CachedNetworkImage(
                imageUrl: MyUrl.fullurl + cloth.image,
                placeholder: (context, url) => Center(
                  child: const CircularProgressIndicator(),
                ),
                imageBuilder: (context, imageProvider) {
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameToDescriptionPart() {
    return Container(
      // width: double.infinity,
      width: MediaQuery.of(context).size.width,
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cloth.name,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
          Text(
            "\$ ${cloth.price.toString()}",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
          Text(
            "Description",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerDescription() {
    return Container(
      // height: 170,
      // color: Colors.blue,
      child: Wrap(
        children: [
          Text(
            "${cloth.description}",
            style: TextStyle(
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }

  Widget _buldColorPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Colour",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     _buildColorProduct(
          //       color: Color.fromARGB(255, 240, 85, 73),
          //     ),
          //     _buildColorProduct(
          //       color: Color.fromARGB(255, 113, 246, 117),
          //     ),
          //     _buildColorProduct(
          //       color: Color.fromARGB(255, 87, 164, 226),
          //     ),
          //     _buildColorProduct(
          //       color: const Color.fromARGB(255, 247, 25, 99),
          //     )
          //   ],
          // ),

          height: 60,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    for (int i = 0; i < 4; i++) {
                      if (i == index)
                        clickedColor[i] = true;
                      else
                        clickedColor[i] = false;
                    }
                  });
                },
                child: _buildColorProduct(
                    color: productColor[index], clicked: clickedColor[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Size",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    for (int i = 0; i < 4; i++) {
                      if (i == index)
                        clickedSize[i] = true;
                      else
                        clickedSize[i] = false;
                    }
                  });
                },
                child: _buildSizeProduct(
                  name: productSize[index],
                  click: clickedSize[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuentityPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "Quentity",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          width: 130,
          decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (count > 1) {
                      count--;
                    }
                  });
                },
                child: Icon(Icons.remove),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
                child: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonPart() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 60,
            // width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (clickedSize.contains(true) && clickedColor.contains(true)) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    text: 'Do you want to Add this product',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    onConfirmBtnTap: () async {
                      await addToCart(cloth.id, count);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => userCart(),
                        ),
                      );
                    },
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  // Show an alert to inform the user that size and color need to be selected.
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.info,
                    text:
                        'Please select size and color before adding to the cart.',
                  );
                }
              },
              child: Text(
                "Add to cart",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                primary: Colors.pink,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: SizedBox(
            height: 60,
            // width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (clickedSize.contains(true) && clickedColor.contains(true)) {
                  // User has selected size and color
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    text: 'BUY NOW',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    onConfirmBtnTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PaymentMethodScreen(cloth, count, size),
                          ));
                    },
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  // Show an alert to inform the user that size and color need to be selected.
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.info,
                    text:
                        'Please select size and color before adding to the Order.',
                  );
                }
              },
              child: Text(
                "Buy now",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  primary: Colors.white,
                  foregroundColor: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Details Page",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
          backgroundColor: Colors.pink,
          elevation: 0.0,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //         builder: (context) => Home(),
          //       ),
          //     );
          //   },
          // ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.black,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                SizedBox(height: 16),
                _buildNameToDescriptionPart(),
                SizedBox(height: 16),
                _buildInnerDescription(),
                SizedBox(height: 100),
                _buildSize(),
                SizedBox(height: 16),
                _buldColorPart(),
                SizedBox(height: 16),
                _buildQuentityPart(),
                SizedBox(height: 16),
                _buildButtonPart(),
              ],
            ),
          ),
        ));
  }
}
