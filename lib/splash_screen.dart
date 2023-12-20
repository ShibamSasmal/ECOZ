import 'dart:async';
import 'package:eshop/dashboard.dart';
import 'package:eshop/homepage.dart';
//import 'package:eshop/homepage.dart';
// import 'package:eshop/login.dart';
import 'package:eshop/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen> {
  static const String KEYLOGIN = "login";
  @override
  void initState() {
    super.initState();

    whereToGo();

    // Timer(
    //   Duration(seconds: 3),
    //   () {
    //     Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => homepage(),
    //         ));
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.white60),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/ez.png",
                        // height: 100,
                        // width: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "Developed By Shibam Sasmal",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'FontMain'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();

    var isLoggedIn = sharedPref.getBool(KEYLOGIN);
    String id = sharedPref.getString("id") ?? "";
    String name = sharedPref.getString("name") ?? "";
    String phone = sharedPref.getString("phone") ?? "";
    String email = sharedPref.getString("email") ?? "";
    String image = sharedPref.getString("image") ?? "";

    Timer(
      Duration(seconds: 2),
      () {
        if (isLoggedIn != null) {
          if (isLoggedIn) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      dashboard(User(id, name, phone, email, image)),
                ));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => homepage(),
                ));
          }
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => homepage(),
              ));
        }
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => homepage(),
        //     ));
      },
    );
  }
}
