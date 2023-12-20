import 'dart:convert';
import 'package:eshop/dashboard.dart';
import 'package:eshop/loadingdialog.dart';
import 'package:eshop/login.dart';
import 'package:eshop/mainurl.dart';
import 'package:eshop/splash_screen.dart';
import 'package:eshop/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  bool _obsecureText = true;
  bool _obsecure = true;
  var _myFormkey = GlobalKey<FormState>();
  var _usernsme = TextEditingController();
  var _phone = TextEditingController();
  var _email = TextEditingController();
  var _password = TextEditingController();
  var _confirmPassword = TextEditingController();
  Future<void> loginStatus(
      String name, String phone, String email, String password) async {
    Map data = {
      "name": name,
      "phone": phone,
      "email": email,
      "password": password
    };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingDialog();
        });
    try {
      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "student_signup.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool(SplashscreenState.KEYLOGIN, true);
        sharedPref.setString("id", jsondata["id"].toString());
        sharedPref.setString("name", jsondata["name"].toString());
        sharedPref.setString("phone", jsondata["phone"].toString());
        sharedPref.setString("email", jsondata["email"].toString());
        sharedPref.setString("image", jsondata["image"].toString());
        User user = User(
            jsondata["id"].toString(),
            jsondata["name"].toString(),
            jsondata["phone"].toString(),
            jsondata["email"].toString(),
            jsondata["image"].toString());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => dashboard(user)));
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Center(
            child: Text('Register Here',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'FontThird')),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.black, Colors.blue]),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Colors.red,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _myFormkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _usernsme,
                            validator: (Value) {
                              if (Value == null || Value.isEmpty) {
                                return "Please Enter Name";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Enter Your Name',
                                labelStyle: TextStyle(color: Colors.black),
                                hintText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(CupertinoIcons.person)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _phone,
                            validator: (Value) {
                              if (Value!.isEmpty) {
                                return "Please Enter a Phone number";
                              }
                              if (Value.length != 10) {
                                return "Please Enter valid number";
                              }
                              return null;
                            },
                            // obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Enter Your Phone Number',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                hintText: 'Phone No',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: Icon(CupertinoIcons.phone)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _email,
                            validator: (Value) {
                              if (Value == null || Value.isEmpty) {
                                return "Please Enter a valid  Email";
                              }
                              return null;
                            },
                            // obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Enter Your Email',
                                labelStyle: TextStyle(color: Colors.black),
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                prefixIcon: Icon(CupertinoIcons.mail)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _password,
                            validator: (Value) {
                              if (Value == null || Value.isEmpty) {
                                return "Please Enter Password";
                              }
                              if (Value.length < 3) {
                                return "Password too short";
                              }
                              return null;
                            },
                            obscureText: _obsecureText,
                            decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obsecureText = !_obsecureText;
                                    });
                                  },
                                  child: Icon(_obsecureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                hintText: 'Enter Your Password',
                                prefixIcon: Icon(CupertinoIcons.lock),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _confirmPassword,
                            validator: (Value) {
                              if (Value != _password.text) {
                                return " please enter same password";
                                // return "Please Enter Password";
                              }
                              return null;
                            },
                            obscureText: _obsecure,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Confirm Your Password',
                              prefixIcon: Icon(CupertinoIcons.lock),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obsecure = !_obsecure;
                                  });
                                },
                                child: Icon(_obsecure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        //
                        SizedBox(
                          // height: 100,
                          height: 50,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_myFormkey.currentState!.validate()) {
                                loginStatus(_usernsme.text, _phone.text,
                                    _email.text, _password.text);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please Enter your all Details");
                              }
                            },
                            // ignore: sort_child_properties_last
                            child: const Center(
                              child: Text(
                                "signup",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(
                                  color: Colors.black,
                                  // fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "NotoSans"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => login(),
                                      ));
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
