import 'package:http/http.dart' as http;
import 'package:pwlp/Model/auth/version_response.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pwlp/pw_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VersionResponse data = VersionResponse();
  bool canNavigateInside = false;
  String version = "1.0.3";
  String code = "";

  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // version = packageInfo.version;
    version = "1.0.3";
    code = packageInfo.buildNumber;
    print("version ${version}");
    print("build number ${code}");
  }

  Future<bool?> checkVersion({required version}) async {
    bool isAllowed = false;

    // VersionResponse payload = VersionResponse(version: version.toString());

    try {
      Map payload = {
        "version": "2.0.1",
      };
      print("request ${payload}");
      var response = await http.post(
        Uri.parse("https://perks.physiciansweekly.com/api/version"),
        body: payload,
      );
      if (response.statusCode == 200) {
        // final userLoginData = UserLoginData.fromJson(json.decode(response.body));
        data = VersionResponse.fromJson(json.decode(response.body));
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
      data.success == true ? isAllowed = true : false;

      if (!isAllowed) {
        print("API[${data.version}] == APP[$version]");
      }

      return isAllowed;
    } catch (e, st) {
      print("[Common.CheckVersion] - Error $e\n$st");
      return false;
    }
  }

  void navigationPage() async {
    await checkVersion(version: version.toString()).then((value) async {
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
    packageInfo();
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
              AppText(
                "${data.message ?? ""}",
                // "We've just released a new update for the app which includes some great new features! To make sure you're getting the most out of the app, we recommend you update the app.",
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
