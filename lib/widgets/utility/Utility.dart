import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pwlp/Model/auth/version_response.dart';
import 'package:pwlp/utils/API_Constant.dart';
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

  static Future<bool?> checkVersion() async {
    bool isAllowed = false;
    VersionResponse data = VersionResponse();
    try {
      var response =
      await http.get(Uri.parse("https://stage-perks.physiciansweekly.com/api/version"));
      if (response.statusCode == 200) {
        data = VersionResponse.fromJson(jsonDecode(response.body));
        print("respojseo${data}");
      } else {
        print("staesfdf${response.statusCode}");
        // return false;
      }

      if (data == null) {
        print("[Common.CheckVersion] - Received Null");
        return false;
      }

      // if (response()['status'] != 1) {
      //   print("[Common.CheckVersion] - ${show()['msg']}");
      //   return false;
      // }
      data.version == kAppVersion ? isAllowed = true:false;


      if (!isAllowed) {
        print("API[${data.version}] == APP[$kAppVersion]");
      }

      return isAllowed;
    } catch (e, st) {
      print("[Common.CheckVersion] - Error $e\n$st");
      return false;
    }
  }

 /* static show() async {
    var response =
    await http.get(Uri.parse("https://stage-perks.physiciansweekly.com/api/version"));
    if (response.statusCode == 200) {
      print(response.body);
      var data = jsonDecode(response.body);
      return data;
    } else {
      print(response.statusCode);
      return;
    }
  }*/

}
