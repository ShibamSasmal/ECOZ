import 'dart:convert';

import 'package:eshop/order_details.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Check.dart';
import 'mainurl.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  late SharedPreferences sp;
  List order = [];
  // var istrue;
  bool istrue = true;
  @override
  void initState() {
    getOrder().whenComplete(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  Future getOrder() async {
    sp = await SharedPreferences.getInstance();
    var id = sp.getString("id") ?? "";
    try {
      var url = Uri.parse('${MyUrl.fullurl}fetch_order.php?id=$id');

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata != null && jsondata.containsKey('data')) {
          // Check if 'data' is a non-null list
          if (jsondata['data'] is List) {
            order.clear();
            for (int i = 0; i < jsondata['data'].length; i++) {
              // CartItem cart = CartItem(
              //     cart_id: jsondata['data'][i]['cart_id'].toString(),
              //     PId: jsondata['data'][i]['PId'].toString(),
              //     id: jsondata['data'][i]['id'].toString(),
              //     date: jsondata['data'][i]['date'].toString(),
              //     // quantity: jsondata['data'][i]['quantity'].toString(),
              //     quantity: int.parse(jsondata['data'][i]['quantity']),
              //     productname: jsondata['data'][i]['productname'].toString(),
              //     productimage: jsondata['data'][i]['productimage'].toString(),
              //     productprice: jsondata['data'][i]['productprice'].toString(),
              //     productdescription:
              //         jsondata['data'][i]['productdescription'].toString(),
              //     categoryId: jsondata['data'][i]['categoryId'].toString(),
              //     Featured: jsondata['data'][i]['Featured'].toString());
              Order ordr = Order(
                order_id: jsondata['data'][i]['order_id'],
                id: jsondata['data'][i]['id'],
                PId: jsondata['data'][i]['PId'],
                address_id: jsondata['data'][i]['address_id'],
                pick_date: jsondata['data'][i]['pick_date'],
                delivery_between: jsondata['data'][i]['delivery_between'],
                size: jsondata['data'][i]['size'],
                payment_option: jsondata['data'][i]['payment_option'],
                quantity: jsondata['data'][i]['quantity'],
                cancel_date: jsondata['data'][i]['cancel_date'],
                confirm_date: jsondata['data'][i]['confirm_date'],
                order_status: jsondata['data'][i]['order_status'],
                productname: jsondata['data'][i]['productname'],
                productimage: jsondata['data'][i]['productimage'],
                productprice: jsondata['data'][i]['productprice'],
                productdescription: jsondata['data'][i]['productdescription'],
                categoryId: jsondata['data'][i]['categoryId'],
                Featured: jsondata['data'][i]['Featured'],
                name: jsondata['data'][i]['name'],
                ph_no: jsondata['data'][i]['ph_no'],
                pin_code: jsondata['data'][i]['pin_code'],
                address: jsondata['data'][i]['address'],
                state: jsondata['data'][i]['state'],
                city: jsondata['data'][i]['city'],
                district: jsondata['data'][i]['district'],
              );
              order.add(ordr);
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

      return order;
    } catch (e) {
      print('Error: $e');
      throw e; // Propagate the error to the FutureBuilder
    }
  }

  Future<void> check(String order_id, int index) async {
    Map data = {'order_id': order_id};
    try {
      var res = await http.post(
          Uri.http(
              MyUrl.mainurl, MyUrl.suburl + "order_cancel_verification.php"),
          body: data);

      var jsondata = jsonDecode(res.body);
      if (jsondata['status'] == true) {
        if (jsondata['order_status'] == '0') {
          istrue = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetails(order[index], istrue)));
        } else {
          istrue = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetails(order[index], istrue)));
        }
      } else {
        istrue = true;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetails(order[index], istrue)));
      }
    } catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Order',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
              fontFamily: "NotoSans"),
        ),
        backgroundColor: Colors.pink,
      ),
      body: order.isNotEmpty
          ? ListView.builder(
              itemCount: order.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Image.network(
                            MyUrl.fullurl + order[index].productimage),
                        title: Text(
                          order[index].productname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('Price: \$${order[index].productprice}'),
                        onTap: () {
                          check(order[index].order_id, index);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             OrderDetails(order[index], istrue)));
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                          onPressed: () {
                            check(order[index].order_id, index);
                          },
                        ),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
