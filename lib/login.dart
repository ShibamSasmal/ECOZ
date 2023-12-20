import 'dart:convert';
import 'package:eshop/EmailScreen.dart';
import 'package:eshop/dashboard.dart';
import 'package:eshop/loadingdialog.dart';
import 'package:eshop/mainurl.dart';
import 'package:eshop/signup.dart';
import 'package:eshop/splash_screen.dart';
import 'package:eshop/user.dart';
import 'package:flutter/cupertino.dart';
// import 'package:eshop/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  var _myFormKey = GlobalKey<FormState>();
  var _password = TextEditingController();
  var _email = TextEditingController();
  bool _obsecureText = true;
  Future<void> loginStatus(String email, String password) async {
    Map data = {"email": email, "password": password};
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LoadingDialog();
        });
    try {
      var response = await http.post(
          Uri.http(MyUrl.mainurl, MyUrl.suburl + "student_login.php"),
          body: data);
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1.6),
                colors: [
                  Color(0xFF065574),
                  Color(0xFF074D67),
                  Color(0xFF0A3E53),
                  Color(0xFF0E242F),
                  Color(0xFF111619)
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _myFormKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _email,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email Required";
                                } else if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return "Please enter valid email";
                                } else {
                                  return null;
                                }
                              },
                              // autovalidateMode:
                              //     AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: "NotoSans",
                                ),
                                hintText: "Email",
                                prefixIcon: Icon(CupertinoIcons.mail),
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _password,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password Required";
                                } else if (_password.text.length <= 5) {
                                  return 'Password must be atleast 6 Characters';
                                } else {
                                  return null;
                                }
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
                                labelText: 'password',
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "NotoSans"),
                                hintText: "password",
                                prefixIcon: Icon(CupertinoIcons.lock),
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmailScreen(),
                                  ));
                            },
                            child: Text(
                              "Forget password?",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    // height: 100,
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_myFormKey.currentState!.validate()) {
                          loginStatus(_email.text, _password.text);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please Enter Email Id and Password");
                        }
                      },
                      child: Center(
                        child: Text(
                          "Login",
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
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
                                      builder: (context) => signup(),
                                    ));
                              },
                              child: Text(
                                "signup",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: "NotoSans"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
