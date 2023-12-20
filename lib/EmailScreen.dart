import 'dart:convert';

import 'package:email_otp/email_otp.dart';
import 'package:eshop/verification.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;
import 'emailClass.dart';
import 'loadingdialog.dart';
import 'mainurl.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController _email = TextEditingController();
  EmailOTP myauth = EmailOTP();
  Future<void> check(String email) async {
    Map data = {'email': email};
    if (formkey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "email_verification.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          // Email.email = jsondata['email'];
          Email email = Email(jsondata["email"].toString());
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OtpScreen(email)));
        } else {
          Navigator.of(context).pop();

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Email Id not found",
            confirmBtnText: "Ok",
            onConfirmBtnTap: () {
              Navigator.of(context).pop();
            },
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    } else {
      Fluttertoast.showToast(msg: 'Invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                HexColor("#4b4293").withOpacity(0.8),
                HexColor("#4b4293"),
                HexColor("#08418e"),
                HexColor("#08418e")
              ],
            ),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/forgotpass.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
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
                        decoration: InputDecoration(
                          labelText: "Enter Your Email",
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 55,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      onPressed: () async {
                        check(_email.text);
                      },
                      child: Text("Send the code"),
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
