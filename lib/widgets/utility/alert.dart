import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

dialogAlert(BuildContext context, String message) {
  Alert(
    context: context,
    title: "Partner Perks",
    desc: message,
    buttons: [
      DialogButton(
        color: const Color(0xffc22ea1),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        width: 120,
        child: const Text(
          "Ok",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'texgyreadventor-regular'),
        ),
      ),
    ],
  ).show();
}
