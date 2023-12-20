import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            height: 80,
            width: 100,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 126, 123, 123),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Loading....",
                  style: TextStyle(fontSize: 8, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
