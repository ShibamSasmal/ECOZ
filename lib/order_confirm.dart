import 'dart:convert';
import 'package:eshop/Check.dart';
import 'package:eshop/loadingdialog.dart';
import 'package:eshop/mainurl.dart';
import 'package:eshop/order_sucess.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderConfirm extends StatefulWidget {
  // const OrderConfirm({super.key});
  Address address;
  Cloth cloth;
  int total;
  int quantity;
  String size;
  OrderConfirm(this.address, this.cloth, this.total, this.quantity, this.size);

  @override
  State<OrderConfirm> createState() =>
      _OrderConfirmState(address, cloth, total, quantity, size);
}

class _OrderConfirmState extends State<OrderConfirm> {
  Address address;
  Cloth cloth;
  int total;
  int quantity;

  String size;

  _OrderConfirmState(
      this.address, this.cloth, this.total, this.quantity, this.size);

  Future<void> orderStatus(String id, String PId, String address,
      String product_size, String prd_quentity) async {
    Map data = {
      "user_id": id,
      "PId": PId,
      "address": address,
      "product_size": product_size,
      "prd_quentity": prd_quentity
    };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog();
        });
    try {
      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "order.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == 'true') {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OrderSucess()));

        Fluttertoast.showToast(msg: jsondata["msg"]);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            // msg: "Invalid Login Credentials",
            msg: jsondata["msg"]);
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
        // msg: "Invalid Login",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // var total = total + 40;
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Order"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Shipping Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              address.name,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     // Navigator.push(
                          //     //     context,
                          //     //     MaterialPageRoute(
                          //     //       builder: (context) =>
                          //     //           ShippingAddress(cloth, total),
                          //     //     ));
                          //   },
                          //   child: Text(
                          //     "Change",
                          //     style: TextStyle(
                          //         fontSize: 17, color: Color(0xFFDB3022)),
                          //   ),
                          // ),
                        ],
                      ),
                      Text(
                        address.address,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        address.city +
                            " ," +
                            address.state +
                            " ," +
                            address.district +
                            " ," +
                            address.pin_code,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Payment Method",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => PaymentMethodScreen(),
                    //       ),
                    //     );
                    //   },
                    //   child: Text(
                    //     "Change",
                    //     style:
                    //         TextStyle(fontSize: 17, color: Color(0xFFDB3022)),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text("Cash On Delivery"),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Delivery Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      height: 65,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2)
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Home Delivery",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.indigo,
                            ),
                          ),
                          Text("2-7 Days")
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub Total",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    Text(
                      "\$" + (total - 40).toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Shipping Fee",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    Text(
                      "\$40",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ],
                ),
                Divider(
                  height: 30,
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Payment",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    Text(
                      "\$" + total.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    String uid = pref.getString("id") ?? "";
                    print(quantity);

                    orderStatus(uid, cloth.id, address.address_id, size,
                        quantity.toString());
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFDB3022),
                    ),
                    child: Center(
                      child: Text(
                        "Confirm Order",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
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
  }
}
