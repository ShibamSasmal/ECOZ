import 'dart:convert';
import 'package:eshop/Check.dart';
import 'package:eshop/loadingdialog.dart';
import 'package:eshop/mainurl.dart';
import 'package:flutter/material.dart';
import 'package:eshop/order_confirm.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ShippingAddress extends StatefulWidget {
  Cloth cloth;
  int total;
  int quantity;
  String size;
  ShippingAddress(this.cloth, this.total, this.quantity, this.size);
  // ShippingAddress({Key? key}) : super(key: key);

  @override
  State<ShippingAddress> createState() =>
      _ShippingAddressState(cloth, total, quantity, size);
}

class _ShippingAddressState extends State<ShippingAddress> {
  Cloth cloth;
  int total;
  int quantity;
  String size;

  _ShippingAddressState(this.cloth, this.total, this.quantity, this.size);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _name = TextEditingController();

  var _phone = TextEditingController();

  var _pin = TextEditingController();

  var _address = TextEditingController();

  var _state = TextEditingController();

  var _city = TextEditingController();

  var _district = TextEditingController();

  Future address(String id, String name, String phone, String pin,
      String address, String state, String city, String district) async {
    Map data = {
      "id": id,
      "name": name,
      "ph_no": phone,
      "pin_code": pin,
      "address": address,
      "state": state,
      "city": city,
      "district": district,
    };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingDialog();
        });
    try {
      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "address.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        Address add = Address(
            address_id: jsondata["address_id"],
            id: jsondata["id"],
            name: jsondata["name"],
            ph_no: jsondata["ph_no"],
            pin_code: jsondata["pin_code"],
            address: jsondata["address"],
            state: jsondata["state"],
            city: jsondata["city"],
            district: jsondata["district"]);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderConfirm(add, cloth, total, quantity, size),
          ),
        );

        Fluttertoast.showToast(msg: jsondata["msg"]);
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(
            // msg: "Invalid Login Credentials",
            msg: jsondata["msg"]);
      }
    } catch (e) {
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
        // msg: "Invalid Login",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Shipping Address"),
          centerTitle: true,
          backgroundColor: Colors.pink,
          elevation: 0.0,
          // foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Full Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Mobile Number",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        } else if (value.length != 10) {
                          return 'Mobile number must be 10 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _address,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Address",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _city,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "City",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _state,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "State/Province/Region",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your state/province/region';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _district,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "District",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your district';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _pin,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Zip Code",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your zip code';
                        } else if (value.length != 6) {
                          return 'Zip code must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        String uid = pref.getString("id") ?? "";
                        if (_formKey.currentState!.validate()) {
                          address(
                              uid,
                              _name.text,
                              _phone.text,
                              _pin.text,
                              _address.text,
                              _state.text,
                              _city.text,
                              _district.text);
                        } else {
                          Fluttertoast.showToast(msg: 'Enter all details');
                        }
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
                            "Add Address",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
