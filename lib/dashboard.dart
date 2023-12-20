import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/About.dart';
import 'package:eshop/Home.dart';
import 'package:eshop/ProfilePage.dart';
import 'package:eshop/SearchPage.dart';
import 'package:eshop/homepage.dart';
import 'package:eshop/mainurl.dart';
import 'package:eshop/my_order.dart';
import 'package:eshop/user.dart';
import 'package:eshop/user_cart.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types, must_be_immutable
class dashboard extends StatefulWidget {
  // const dashboard({super.key});
  User user;
  dashboard(this.user);
  // Check check;

  @override
  State<dashboard> createState() => _dashboardState(user);
}

class _dashboardState extends State<dashboard> {
  // List<Widget> pages = const [
  //   Home(),
  //   Search(),
  //   CartScreen(),
  // ];
  List<Widget> pages = [];
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages = [
      Home(),
      Search(),
      userCart(),
    ];
  }

  User user;
  _dashboardState(this.user);

  bool homeColor = true;
  bool accountColor = false;
  bool orderColor = false;
  bool categoriesColor = false;
  bool favouriteColor = false;

  bool aboutColor = false;

  int _SelectedIndex = 0;

  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: unused_field
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Index 0: Home',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 1: Business',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 2: School',
  //     style: optionStyle,
  //   ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _SelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // bottomNavigationBar: BottomNavigationBar(
        //   items: const <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //       backgroundColor: Colors.blueGrey,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.category),
        //       label: 'Categories',
        //       backgroundColor: Colors.cyan,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.account_circle),
        //       label: 'Account',
        //       backgroundColor: Colors.purple,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.shopping_cart),
        //       label: 'Cart',
        //       backgroundColor: Colors.teal,
        //     ),
        //   ],
        //   currentIndex: _SelectedIndex,
        //   selectedItemColor: Colors.amber[800],
        //   onTap: _onItemTapped,
        // ),

        // backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          // centerTitle: true,

          title: Text(
            "E C O Z",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontFamily: "NotoSans"),
          ),
          elevation: 0.0,
          backgroundColor: Colors.pink,
          // leading:
          // Icon(
          //   Icons.menu,
          //   color: Colors.white,
          // ),
          // actions: [
          //   Icon(Icons.notifications),
          //   SizedBox(
          //     width: 20,
          //   ),
          //   SizedBox(
          //     width: 20,
          //   )
          // ],
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => Search(),
          //           ));
          //     },
          //     icon: Icon(
          //       Icons.search,
          //       color: Colors.white,
          //     ),
          //   ),
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => Cart(),
          //             ));
          //       },
          //       icon: Icon(
          //         Icons.shopping_cart,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ],
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyOrder()));
                },
                icon: Icon(CupertinoIcons.cube_box))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user.name),
                accountEmail: Text(user.email),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    // child: Image.network(
                    //   'https://pngtree.com/freepng/business-man-avatar_8855195.html',
                    //   fit: BoxFit.cover,
                    //   width: 90,
                    //   height: 90,
                    // ),
                    // child: Image.network(
                    //   MyUrl.fullurl + MyUrl.imageurl + user.image,
                    //   fit: BoxFit.cover,
                    //   height: 90,
                    //   width: 90,
                    // ),

                    child: CachedNetworkImage(
                      imageUrl: MyUrl.fullurl + MyUrl.imageurl + user.image,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      imageBuilder: (context, imageProvider) {
                        return Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(image: imageProvider)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  // image: DecorationImage(
                  //     fit: BoxFit.fill,
                  //     image: NetworkImage(
                  //         'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),

                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/header.jpeg"),
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  // setState(
                  //   () {
                  //     homeColor = true;
                  //     accountColor = false;
                  //     orderColor = false;
                  //     categoriesColor = false;
                  //     favouriteColor = false;
                  //     aboutColor = false;
                  //   },
                  // )
                },
                child: ListTile(
                  selected: homeColor,
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
              ),
              InkWell(
                onTap: () => {
                  // setState(
                  //   () {
                  //     accountColor = true;
                  //     orderColor = false;
                  //     homeColor = false;
                  //     categoriesColor = false;
                  //     favouriteColor = false;
                  //     aboutColor = false;
                  //   },
                  // ),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(user),
                    ),
                  )
                },
                child: ListTile(
                  selected: accountColor,
                  leading: Icon(Icons.person),
                  title: Text('My Account'),
                ),
              ),
              InkWell(
                onTap: () => {
                  setState(
                    () {
                      orderColor = true;
                      accountColor = false;
                      homeColor = false;
                      categoriesColor = false;
                      favouriteColor = false;
                      aboutColor = false;
                    },
                  )
                },
                child: ListTile(
                  selected: orderColor,
                  leading: Icon(Icons.shopping_basket),
                  title: Text('My Orders'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyOrder(),
                      ),
                    );
                  },
                ),
              ),
              InkWell(
                // onTap: () {
                //   setState(() {
                //     categoriesColor = true;
                //     accountColor = false;
                //     orderColor = false;
                //     homeColor = false;
                //     favouriteColor = false;
                //     aboutColor = false;
                //   });
                // },
                child: ListTile(
                  selected: categoriesColor,
                  leading: Icon(Icons.dashboard),
                  title: Text('My Cart'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => userCart(),
                        ));
                  },
                ),
              ),

              // InkWell(
              //   onTap: () => {
              //     setState(
              //       () {
              //         favouriteColor = true;
              //         accountColor = false;
              //         orderColor = false;
              //         categoriesColor = false;
              //         homeColor = false;
              //         aboutColor = false;
              //       },
              //     ),
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => WishListScreen(),
              //         ))
              //   },
              //   child: ListTile(
              //     selected: favouriteColor,
              //     leading: Icon(Icons.favorite),
              //     title: Text('Favourites'),
              //   ),
              // ),
              Divider(),

              // InkWell(
              //   onTap: () => {},
              //   child: ListTile(
              //     leading: Icon(Icons.settings),
              //     title: Text('Settings'),
              //   ),
              // ),
              InkWell(
                onTap: () => {
                  // setState(
                  //   () {
                  //     aboutColor = true;
                  //     accountColor = false;
                  //     orderColor = false;
                  //     categoriesColor = false;
                  //     favouriteColor = false;
                  //     homeColor = false;
                  //   },
                  // ),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => About(),
                      ))
                },
                child: ListTile(
                  selected: aboutColor,
                  leading: Icon(
                    Icons.help,
                  ),
                  title: Text(
                    'About',
                  ),
                ),
              ),

              // Divider(),
              ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.exit_to_app),
                onTap: () async {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    text: 'Do you want to logout',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    onConfirmBtnTap: () async {
                      var sharedPref = await SharedPreferences.getInstance();
                      sharedPref.clear();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => homepage()),
                          (Route<dynamic> route) => false);
                    },
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: _SelectedIndex > 2 ? ProfilePage(user) : pages[_SelectedIndex],

        bottomNavigationBar: Container(
          // color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              gap: 8,
              padding: const EdgeInsets.all(15),
              tabBackgroundColor: Colors.grey.shade800,
              activeColor: Colors.white,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: "Home",
                  backgroundColor: Colors.cyan,
                ),
                GButton(
                  icon: Icons.search,
                  text: "Search",
                ),
                GButton(
                  icon: Icons.shopping_cart,
                  text: "Cart",
                  backgroundColor: Colors.blueGrey,
                ),
                GButton(
                  icon: Icons.person,
                  text: "Profile",
                  backgroundColor: Colors.purple,
                ),
              ],
              selectedIndex: _SelectedIndex,
              onTabChange: (index) {
                setState(() {
                  _SelectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
