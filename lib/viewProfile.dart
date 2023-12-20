import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/user.dart';
import 'package:flutter/material.dart';

import 'mainurl.dart';

class ViewProfile extends StatefulWidget {
  // const ViewProfile({super.key});
  User user;
  ViewProfile(this.user);

  @override
  State<ViewProfile> createState() => _ViewProfileState(user);
}

class _ViewProfileState extends State<ViewProfile> {
  User user;
  _ViewProfileState(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: MyUrl.fullurl + MyUrl.imageurl + user.image,
            placeholder: (context, url) => const CircularProgressIndicator(),
            imageBuilder: (context, imageProvider) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(image: imageProvider)),
              );
            },
          ),
        ),
      ),
    );
  }
}
