import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class Utility {
  toast(BuildContext context, String message) {
    Toast.show(message,
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: const Color(0xffc22ea1));
  }

//For custom loading
  void onLoading(BuildContext context, bool iSloading) {
    if (iSloading == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text("Please wait..."),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

}
