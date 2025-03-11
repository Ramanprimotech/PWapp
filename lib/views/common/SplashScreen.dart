import 'package:http/http.dart' as http;
import 'package:pwlp/Model/auth/version_response.dart';
import 'package:pwlp/pw_app.dart';

import '../user/api_call/api_call.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  VersionResponse data = VersionResponse();
  bool canNavigateInside = false;
  String version = "2.0.1";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ToastContext().init(context);
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  Future<bool?> checkVersion({required version}) async {
    bool isAllowed = false;
    try {
      Map payload = {"version": version};
      var response = await http.post(
        Uri.parse("${Api.baseUrl}${Api().version}"),
        body: payload,
      );
      if (response.statusCode == 200) {
        data = VersionResponse.fromJson(json.decode(response.body));
      } else {
        print("staesfdf${response.statusCode}");
      }

      if (data == null) {
        return false;
      }
      data.success == true ? isAllowed = true : false;

      if (!isAllowed) {
        debugPrint("API[${data.version}] == APP[$version]");
      }

      return isAllowed;
    } catch (e, st) {
      print("[Common.CheckVersion] - Error $e\n$st");
      return false;
    }
  }

  void navigationPage() async {
    bool isSuccess =
    await postUserId(apiUrl: Api().userSession);
    await checkVersion(version: version.toString()).then((value) async {
      canNavigateInside = true;
      if (value == true) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        if (sharedPreferences.getString("userID") == null) {
          Navigator.of(context).pushReplacementNamed('/Login');
        } else if(!isSuccess){
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.clear();
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
          Utility().toast(context, Message().userNotMatch);
        }else {
          Navigator.of(context).pushReplacementNamed('/Dashboard');
        }
      } else {
        _showDialog(context);
      }
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: data.message != null ? 250 : 180,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const AppText("Partner Perks",
                    color: Colors.black, fontSize: 20),
                AppText(
                  data.message ??
                      "Exciting changes are on the way. Thanks for your patience, we'll be back shortly.",
                  color: Colors.black,
                  fontSize: 16,
                  maxLines: 10,
                  textAlign: TextAlign.center,
                  padding: const EdgeInsets.only(top: 18, bottom: 16),
                ),
                if (data.message != null)
                  DialogButton(
                    color: const Color(0xffc22ea1),
                    onPressed: () {
                      urlLaunch(Platform.isAndroid
                          ? Api.androidAppLinked.toString()
                          : Api.iosAppLinked.toString());
                    },
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    child: const AppText(
                      "Update",
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
