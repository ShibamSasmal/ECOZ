import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/Check.dart';
import 'package:eshop/detailscreen.dart';
import 'package:eshop/mainurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userCart extends StatefulWidget {
  const userCart({super.key});

  @override
  State<userCart> createState() => _userCartState();
}

class _userCartState extends State<userCart> {
  List<CartItem> cartItems = [];
  List<Cloth> cartData = [];
  late SharedPreferences sp;
  var incrementQuantity, decrementQuantity;
  Future<List<CartItem>> getCart() async {
    sp = await SharedPreferences.getInstance();
    var id = sp.getString("id") ?? "";
    try {
      var url = Uri.parse('${MyUrl.fullurl}fetch_allcart.php?id=$id');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata != null && jsondata.containsKey('data')) {
          // Check if 'data' is a non-null list
          if (jsondata['data'] is List) {
            cartItems.clear();
            for (int i = 0; i < jsondata['data'].length; i++) {
              CartItem cart = CartItem(
                  cart_id: jsondata['data'][i]['cart_id'].toString(),
                  PId: jsondata['data'][i]['PId'].toString(),
                  id: jsondata['data'][i]['id'].toString(),
                  date: jsondata['data'][i]['date'].toString(),
                  // quantity: jsondata['data'][i]['quantity'].toString(),
                  quantity: int.parse(jsondata['data'][i]['quantity']),
                  productname: jsondata['data'][i]['productname'].toString(),
                  productimage: jsondata['data'][i]['productimage'].toString(),
                  productprice: jsondata['data'][i]['productprice'].toString(),
                  productdescription:
                      jsondata['data'][i]['productdescription'].toString(),
                  categoryId: jsondata['data'][i]['categoryId'].toString(),
                  Featured: jsondata['data'][i]['Featured'].toString());

              Cloth cloth = Cloth(
                id: jsondata['data'][i]['PId'].toString(),
                name: jsondata['data'][i]['productname'],
                price: jsondata['data'][i]['productprice'],
                image: jsondata['data'][i]['productimage'],
                description: jsondata['data'][i]['productdescription'],
              );
              cartData.add(cloth);
              cartItems.add(cart);
            }
          } else {
            print('Error: Data is not a List');
          }
        } else {
          print('Error: No data key found or data is null');
        }
      } else {
        print('Error: ${response.statusCode}');
      }

      return cartItems;
    } catch (e) {
      print('Error: $e');
      throw e; // Propagate the error to the FutureBuilder
    }
  }

  Future<void> deleteProductFromCart(String cartId, int index) async {
    final url = Uri.parse('${MyUrl.fullurl}cart_item_delete.php');

    try {
      final response = await http.post(
        url,
        body: {
          'cart_id': cartId,
        },
      );
      // print("cart_id:$cartId");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'true') {
          setState(() {
            cartItems.removeAt(index);
          });
          print('Product deleted from cart successfully');
        } else {
          print('Failed to delete product from cart');
        }
      } else {
        print('Failed to delete product from cart. Server error.');
      }
    } catch (error) {
      print('Error deleting product from cart: $error');
    }
  }

  void updateProductInCart(String cartId, int newQuantity, int index) async {
    final url = Uri.parse('${MyUrl.fullurl}update_quantity.php');

    final response = await http.post(
      url,
      body: {
        'cart_id': cartId,
        'new_quantity': newQuantity.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'true') {
        setState(() {
          cartItems[index].quantity;
        });
        print(jsonResponse['msg']);
      } else {
        print(jsonResponse['msg']);
      }
    } else {
      print('Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        // appBar: AppBar(
        //   // centerTitle: true,
        //   title: Text(
        //     "YOUR BAG",
        //     style: TextStyle(
        //         fontSize: 20,
        //         fontWeight: FontWeight.normal,
        //         fontStyle: FontStyle.normal,
        //         fontFamily: "NotoSans"),
        //   ),
        //   elevation: 0.0,
        //   backgroundColor: Colors.pink,
        // ),
        body: FutureBuilder(
          builder: (BuildContext context, AsyncSnapshot data) {
            if (data.hasData) {
              // Calculate the total price
              double totalPrice = 0.0;
              for (var cartItem in cartItems) {
                totalPrice +=
                    double.parse(cartItem.productprice) * cartItem.quantity;
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailScreen(cartData[index])));
                          },
                          child: ListTile(
                            title: Text(cartItems[index].productname),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '${int.parse(cartItems[index].productprice) * cartItems[index].quantity}'),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        // Increase the quantity of the item
                                        setState(() {
                                          incrementQuantity =
                                              cartItems[index].quantity + 1;
                                        });
                                        updateProductInCart(
                                            cartItems[index].cart_id,
                                            incrementQuantity,
                                            index);
                                      },
                                    ),
                                    Text(
                                        'Quantity: ${cartItems[index].quantity}'),
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        // Decrease the quantity of the item, but ensure it's at least 1
                                        if (cartItems[index].quantity > 1) {
                                          setState(() {
                                            decrementQuantity =
                                                cartItems[index].quantity - 1;
                                          });
                                        } else {
                                          decrementQuantity = 1;
                                        }
                                        updateProductInCart(
                                            cartItems[index].cart_id,
                                            decrementQuantity,
                                            index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            leading: CachedNetworkImage(
                              // imageUrl: cartItems[index].productimage,
                              imageUrl:
                                  MyUrl.fullurl + cartItems[index].productimage,
                              width: 60,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.confirm,
                                  text:
                                      'Do you want to remove this product from cart',
                                  confirmBtnText: 'Yes',
                                  cancelBtnText: 'No',
                                  onConfirmBtnTap: () async {
                                    await deleteProductFromCart(
                                        cartItems[index].cart_id, index);
                                    Navigator.pop(context);
                                  },
                                  onCancelBtnTap: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Display total price
                  Visibility(
                    visible: cartItems.length > 0,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          // color: Colors.grey.shade200,
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Total Price:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$$totalPrice',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Checkout Button
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.amber),
                ),
              );
            }
          },
          future: getCart(),
        ),
      ),
    );
  }
}
