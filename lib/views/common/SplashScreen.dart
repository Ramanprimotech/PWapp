import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwlp/widgets/AppText.dart';
import 'package:pwlp/widgets/utility/Utility.dart';
import 'package:pwlp/widgets/utility/alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/Dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool canNavigateInside = false;

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() async {
    await Utility.checkVersion().then((value) async {
      canNavigateInside = true;
      if (value == true) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        if (sharedPreferences.getString("userID") == null) {
          Navigator.of(context).pushReplacementNamed('/Login');
        } else {
          Navigator.of(context).pushReplacementNamed('/Dashboard');
        }
      } else {
        // dialogAlert(context, "Please install the updated version from TestFlight");
        _showDialog(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  static const String iosAppLinked =
      "https://apps.apple.com/in/app/pw-partner-perks/id1497536937";
  static const String androidAppLinked =
      "https://play.google.com/store/apps/details?id=com.partnerperks.pwlp&hl=en-IN";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/Logo.png'),
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            // title: const Text("Partner Perks",),
            content: Container(
          height: 250,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const AppText("Partner Perks", color: Colors.black, fontSize: 22),
              const AppText(
                "We've just released a new update for the app which includes some great new features! To make sure you're getting the most out of the app, we recommend you update the app.",
                color: Colors.black,
                fontSize: 16,
                maxLines: 6,
                textAlign: TextAlign.center,
                padding: EdgeInsets.only(top: 18, bottom: 16),
              ),
              DialogButton(
                color: const Color(0xffc22ea1),
                onPressed: () {
                  urlLaunch(Platform.isAndroid
                      ? androidAppLinked
                      : Platform.isIOS
                          ? iosAppLinked
                          : iosAppLinked);
                },
                width: double.infinity,
                padding: EdgeInsets.zero,
                child: const Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'texgyreadventor-regular'),
                ),
              ),
            ],
          ),
        )

            // const Text("Please install the updated version from TestFlight"),
            // actions: <Widget>[
            //    IconButton(
            //     icon:  const Text("OK"),
            //     onPressed: () {
            //       // Navigator.of(context).pop();
            //     },
            //   ),
            // ],
            );
      },
    );
  }
}
