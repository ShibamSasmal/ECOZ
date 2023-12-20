import 'dart:convert';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/homepage.dart';
import 'package:eshop/my_order.dart';
import 'package:eshop/user.dart';
import 'package:eshop/viewProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'loadingdialog.dart';
import 'mainurl.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage(this.user);

  @override
  State<ProfilePage> createState() => _ProfilePageState(user);
}

class _ProfilePageState extends State<ProfilePage> {
  String i = "";
  var namekey = GlobalKey<FormState>();
  var emailkey = GlobalKey<FormState>();
  var phonekey = GlobalKey<FormState>();
  var _name = TextEditingController();
  var _email = TextEditingController();
  var _phone = TextEditingController();
  User user;
  _ProfilePageState(this.user);
  File? pickedImage;
  Future pickImage(ImageSource imageType) async {
    try {
      final photo =
          await ImagePicker().pickImage(source: imageType, imageQuality: 50);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future createprofile(File photo, String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse(MyUrl.fullurl + "image_update.php"));
      request.files.add(await http.MultipartFile.fromBytes(
          'image', photo.readAsBytesSync(),
          filename: photo.path.split("/").last));
      request.fields['id'] = id;

      var response = await request.send();

      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == 'true') {
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString("image", jsondata['imgtitle']);
        user.image = jsondata['imgtitle'];
        setState(() {
          i = jsondata['imgtitle'];
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          gravity: ToastGravity.CENTER,
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        gravity: ToastGravity.CENTER,
        msg: e.toString(),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    x().whenComplete(() {
      setState(() {});
    });
    super.initState();
  }

  Future x() async {
    var sharedPref = await SharedPreferences.getInstance();
    i = sharedPref.getString("image") ?? '';
  }

  Future<void> updatename(String name) async {
    Map data = {'id': user.id, 'name': name};
    var sharedPref = await SharedPreferences.getInstance();
    if (namekey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "name_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sharedPref.setString("name", jsondata["name"]);
            user.name = jsondata["name"];
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<void> updatePhone(String phone) async {
    Map data = {'id': user.id, 'phone': phone};
    var sharedPref = await SharedPreferences.getInstance();
    if (emailkey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "phone_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sharedPref.setString("phone", jsondata["phone"]);
            user.phone = jsondata["phone"];
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  Future<void> updateEmail(String email) async {
    Map data = {'id': user.id, 'email': email};
    var sharedPref = await SharedPreferences.getInstance();
    if (emailkey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          });
      try {
        var res = await http.post(
            Uri.http(MyUrl.mainurl, MyUrl.suburl + "email_update.php"),
            body: data);

        var jsondata = jsonDecode(res.body);
        if (jsondata['status'] == true) {
          Navigator.of(context).pop();
          Navigator.pop(context);
          setState(() {
            sharedPref.setString("email", jsondata["email"]);
            user.email = jsondata["email"];
          });

          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: jsondata['msg'],
          );
        }
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: e.toString());
      }
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
          backgroundColor: Colors.white,
          title: Text(
            "Profile Details",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30))),
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 200,

                                  // color: Colors.amber,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        MaterialButton(
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          child: const Text(
                                            'view profile photo',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "NotoSans"),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewProfile(user),
                                            ));
                                          },
                                        ),
                                        MaterialButton(
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          child: const Text(
                                            'Select profile photo',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.normal,
                                                fontFamily: "NotoSans"),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                title: const Text(
                                                  "Choose Profile Photo",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontFamily: "NotoSans"),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          pickImage(ImageSource
                                                                  .camera)
                                                              .whenComplete(() {
                                                            if (pickedImage !=
                                                                null) {
                                                              createprofile(
                                                                  pickedImage!,
                                                                  user.id);
                                                            }
                                                          });
                                                        },
                                                        child: const Text(
                                                          'From Camera',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          shadowColor: Colors
                                                              .transparent,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          pickImage(ImageSource
                                                                  .gallery)
                                                              .whenComplete(() {
                                                            if (pickedImage !=
                                                                null) {
                                                              createprofile(
                                                                  pickedImage!,
                                                                  user.id);
                                                            }
                                                          });
                                                        },
                                                        child: Text(
                                                          'From Gallary',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15),
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            shadowColor: Colors
                                                                .transparent),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey,
                            child: pickedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      pickedImage!,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : ClipOval(
                                    // child: CircleAvatar(
                                    //   radius: 66,
                                    //   backgroundColor: Colors.white,
                                    //   backgroundImage: NetworkImage(
                                    //     MyUrl.fullurl +
                                    //         MyUrl.imageurl +
                                    //         user.image,
                                    //   ),
                                    // ),

                                    child: CachedNetworkImage(
                                      imageUrl: MyUrl.fullurl +
                                          MyUrl.imageurl +
                                          user.image,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      imageBuilder: (context, imageProvider) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                image: DecorationImage(
                                                    image: imageProvider)),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 90,
                            left: 90,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              CupertinoIcons.camera_circle_fill,
                              size: 40,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  title: const Text(
                                    "Choose Profile Photo",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            pickImage(ImageSource.camera)
                                                .whenComplete(() {
                                              if (pickedImage != null) {
                                                createprofile(
                                                    pickedImage!, user.id);
                                              }
                                            });
                                          },
                                          child: const Text(
                                            'From Camera',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            pickImage(ImageSource.gallery)
                                                .whenComplete(() {
                                              if (pickedImage != null) {
                                                createprofile(
                                                    pickedImage!, user.id);
                                              }
                                            });
                                          },
                                          child: Text(
                                            'From Gallary',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 5),
                              color: Colors.deepOrange.withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 10)
                        ]),
                    child: ListTile(
                      title: Text('Name'),
                      subtitle: Text(user.name),
                      leading: Icon(CupertinoIcons.person),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _name.text = user.name;
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Container(
                                child: AlertDialog(
                                  content: Form(
                                    key: namekey,
                                    child: TextFormField(
                                      controller: _name,
                                      keyboardType: TextInputType.name,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        labelText: "Name",
                                        hintText: "Enter your name",
                                        prefixIcon: Icon(CupertinoIcons.person),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Name Required";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "cancel",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          if (namekey.currentState!
                                              .validate()) {
                                            updatename(_name.text);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Please Enter Your Name");
                                          }
                                        },
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ))
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      tileColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 5),
                              color: Colors.deepOrange.withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 10)
                        ]),
                    child: ListTile(
                      title: Text('Phone'),
                      subtitle: Text(user.phone),
                      leading: Icon(CupertinoIcons.phone),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _phone.text = user.phone;
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Container(
                                child: AlertDialog(
                                  content: Form(
                                    key: phonekey,
                                    child: TextFormField(
                                      controller: _phone,
                                      keyboardType: TextInputType.phone,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        labelText: "Phone",
                                        hintText: "Enter your phone no",
                                        prefixIcon: Icon(CupertinoIcons.phone),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "phone no  Required";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "cancel",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        if (phonekey.currentState!.validate()) {
                                          updatePhone(_phone.text);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please Enter Your Phone no");
                                        }
                                      },
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      tileColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 5),
                              color: Colors.deepOrange.withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 10)
                        ]),
                    child: ListTile(
                      title: Text('Email'),
                      subtitle: Text(user.email),
                      leading: Icon(CupertinoIcons.mail),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _email.text = user.email;
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Container(
                                child: AlertDialog(
                                  content: Form(
                                    key: emailkey,
                                    child: TextFormField(
                                      controller: _email,
                                      keyboardType: TextInputType.emailAddress,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        hintText: "Enter your Email",
                                        prefixIcon: Icon(CupertinoIcons.mail),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Email Required";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "cancel",
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          if (emailkey.currentState!
                                              .validate()) {
                                            updateEmail(_email.text);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Please Enter Your Email");
                                          }
                                        },
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ))
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      tileColor: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyOrder(),
                          ));
                    },
                    child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 5),
                                color: Colors.deepOrange.withOpacity(.2),
                                spreadRadius: 2,
                                blurRadius: 10)
                          ]),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('My Order'),
                        ),
                        leading: Icon(CupertinoIcons.cube_box),
                        tileColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Do you want to logout',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          onConfirmBtnTap: () async {
                            var sharedPref =
                                await SharedPreferences.getInstance();
                            sharedPref.clear();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => homepage()),
                                (Route<dynamic> route) => false);
                          },
                          onCancelBtnTap: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.pink),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
