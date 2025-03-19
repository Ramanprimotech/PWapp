import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:pwlp/views/notification/notification.dart';
import 'package:pwlp/views/wallboard_Image/wallboard_image.dart';
import '../profile/Profile.dart';
import '../rewards/Reward.dart';
import '../scanner/Scanner.dart';
import 'package:pwlp/pw_app.dart';

import '../user/api_call/api_call.dart';
import '../user/delete_account/delete_account.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedTab = 0;
  late List<Widget> _pageOptions;

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
      RewardView(changeScreen: changeScreen),
      Profile(changeScreen: changeScreen),
      Wallboard(changeScreen: changeScreen),
      PwNotification(changeScreen: changeScreen)
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
                  urlLaunch("https://www.physiciansweekly.com");
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
                child: const Text('Notification'),
                onPressed: () {
                  setState(() {
                    _selectedTab = 6;
                  });
                  Navigator.pop(context, "Notifications");
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('About Us'),
                onPressed: () {
                  urlLaunch("https://www.physiciansweekly.com/about/");

                  Navigator.pop(context, 'About Us');
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Contact Us'),
                onPressed: () {
                  Navigator.of(context).popAndPushNamed("/ContactUs");
                },
              ),
              CupertinoActionSheetAction(
                child: const Text('Delete account'),
                onPressed: (){
                  showDeleteAccountDialog(context);
                }
                // onPressed: (){
                //   dialogLogoutAlert(
                //     context,
                //     "one",
                //     () {
                //       dialogLogoutAlert(
                //         context,
                //         "to",
                //         () async {
                //           // bool isSuccess =
                //           //     await postUserId(apiUrl: Api().userDelete, isAccountDelete: false);
                //           Nav
                //           Utility().toast(context, Message().userDeleted);
                //
                //           // if (isSuccess) {
                //           //   Utility().toast(context, Message().userDeleted);
                //           //   SharedPreferences sharedPreferences =
                //           //       await SharedPreferences.getInstance();
                //           //   sharedPreferences.clear();
                //           //   Navigator.of(context).pushNamedAndRemoveUntil(
                //           //       '/Login', (Route<dynamic> route) => false);
                //           //   Utility().toast(context, Message().userDeleted);
                //           // } else {
                //           //   Utility().toast(context, Message().ErrorMsg);
                //           // }
                //         },
                //       );
                //     },
                //   );
                // },
              ),
              CupertinoActionSheetAction(
                child: const Text('Logout'),
                onPressed: () {
                  dialogLogoutAlert(context, "Do you want to Logout?", logout);
                },
              ),
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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          title: Text(
            Message().AppBarTitle,
            style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular'),
          ),
          backgroundColor: const Color(0xff4725a3),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                actionSheetMethod(context);
              },
            ),
          ],
        ),
        body: _pageOptions[_selectedTab],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.2),
            shape: BoxShape.circle, // Ensures the container is circular
          ),
          child: FloatingActionButton(
            backgroundColor: const Color(0xff4725a3),
            shape: CircleBorder(), // Ensures the button itself is circular
            child: SizedBox(
              height: 35.0,
              width: 35.0,
              child: Image.asset("Assets/qr-scan.png"),
            ),
            onPressed: () {
              setState(() {
                _selectedTab = 2;
              });
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 65,
          shape: const CircularNotchedRectangle(),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: const Color.fromRGBO(255, 255, 255, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: _selectedTab == 0
                    ? Image.asset(
                        "Assets/home-active.png",
                        height: 30,
                        width: 30,
                      )
                    : Image.asset(
                        "Assets/home.png",
                        height: 30,
                        width: 30,
                      ),
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
                    ? Image.asset(
                        "Assets/reward-active.png",
                        height: 35,
                        width: 35,
                      )
                    : Image.asset(
                        "Assets/reward.png",
                        height: 35,
                        width: 35,
                      ),
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

urlLaunch(String urlPage) async {
  final url = urlPage;
  final Uri uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    log(e.toString());
    throw 'Could not launch $url';
  }
}
