import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/Home.dart';
import '../../validators/Message.dart';
import '../profile/Profile.dart';
import '../rewards/Reward.dart';
import '../scanner/Scanner.dart';
import '../wallet/Wallet.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedTab = 0;
  late List<Widget> _pageOptions;

  _launchURL() async {
    const url = 'https://www.physiciansweekly.com';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  _aboutUsURL() async {
    const url = 'https://www.physiciansweekly.com/about/';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  _contactUsURL() async {
    const url = 'https://www.physiciansweekly.com/contact/';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    _pageOptions = [
      Home(changeScreen: changeScreen),
      const Wallet(),
      Scanner(changeScreen: changeScreen),
      Reward(changeScreen: changeScreen),
      Profile(changeScreen: changeScreen)
    ];
  }

  @override
  Widget build(BuildContext context) {
    actionSheetMethod(BuildContext context) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
            title: const Text(
              'PW Partner Perks',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xff4725a3),
                  fontFamily: 'texgyreadventor-regular'),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text("Physician's Weekly"),
                onPressed: () {
                  _launchURL();
                  Navigator.pop(context, "Physician's Weekly");
                },
              ),
              CupertinoActionSheetAction(
                child: const Text("My Profile"),
                onPressed: () {
                  log("Profile clicked--------");
                  setState(() {
                    _selectedTab = 4;
                  });
                  Navigator.pop(context, "Profile");
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('About Us'),
                onPressed: () {
                  _aboutUsURL();
                  Navigator.pop(context, 'About Us');
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Contact Us'),
                onPressed: () {
                  _contactUsURL();
                  Navigator.pop(context, 'Contact Us');
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Logout'),
                onPressed: () {
                  logout();
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontFamily: 'texgyreadventor-regular', color: Colors.red),
              ),
            )),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff4725a3),
        appBar: AppBar(
          title: Text(
            Message().AppBarTitle,
            style: const TextStyle(
                fontSize: 20.0, fontFamily: 'texgyreadventor-regular'),
          ),
          backgroundColor: const Color(0xff4725a3),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                actionSheetMethod(context);
              },
            ),
          ],
        ),
        body: _pageOptions[_selectedTab],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff4725a3),
          child: Container(
            height: 35.0,
            width: 35.0,
            child: const Image(
              image: AssetImage(
                'Assets/qr-scan.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          onPressed: () {
            setState(() {
              _selectedTab = 2;
            });
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: const Color.fromRGBO(255, 255, 255, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: _selectedTab == 0
                    ? Image.asset("Assets/home-active.png")
                    : Image.asset("Assets/home.png"),
                onPressed: () {
                  setState(() {
                    _selectedTab = 0;
                  });
                },
              ),
              const SizedBox(
                width: 15.0,
              ),
              IconButton(
                icon: _selectedTab == 1
                    ? Image.asset("Assets/reward-active.png")
                    : Image.asset("Assets/reward.png"),
                onPressed: () {
                  setState(() {
                    _selectedTab = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeScreen(int i) {
    setState(() {
      _selectedTab = i;
    });
  }
}
