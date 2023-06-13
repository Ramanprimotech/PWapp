import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pwlp/widgets/utility/Utility.dart';
import 'package:pwlp/widgets/utility/alert.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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
    await Utility.checkVersion().
    then((value) async {
      canNavigateInside = true;
      if(value == true){
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        if (sharedPreferences.getString("userID") == null) {
          Navigator.of(context).pushReplacementNamed('/Login');
        } else {
          Navigator.of(context).pushReplacementNamed('/Dashboard');
        }
      }
      else{
        dialogAlert(context, "Please install the updated version from TestFlight");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

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
}
