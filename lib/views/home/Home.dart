import 'package:pwlp/pw_app.dart';
import 'dart:developer';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import '../../Model/common/MoneyData.dart';
import '../../Model/common/PointsData.dart';
import '../../Model/dashboard/DashboardData.dart';
import '../rewards/RedeemSuccess.dart';

typedef VoidWithIntCallback = void Function(int);

class Home extends StatefulWidget {
  final VoidWithIntCallback? changeScreen;

  const Home({Key? key, this.changeScreen}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String amount = "";
  String points = "";
  int pointInt = 0;
  MoneyData? moneyData;
  double moneyD = 0.0;
  String moneyStr = "0";
  String specialityStr = "";
  String dateStr = "";
  PlaceOrderData? placeOrderData;
  late PointsData pointsData;

  dashboardAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID"),
    };
    var response = await http.post(
        Uri.parse("${Api.baseUrl}" "${Api().user_dashboard}"),
        body: data);
    if (response.statusCode == 200) {
      final user_dashboardData =
          DashboardData.fromJson(json.decode(response.body));
      double moneyD = double.parse(user_dashboardData.data!.money!);
      if (mounted) {
        setState(() {
          points = "${user_dashboardData.data!.points.toString()}";
          amount = "${moneyD.round().toString()}";
          if (points == "0" && amount == "0") {
            Timer(const Duration(seconds: 3), () {
              Utility().toast(context, Message().noMoneyMsg);
            });
          }
        });
      }
    } else {
      log("Failure API");
      Utility().toast(context, Message().ErrorMsg);
    }
  }

  dialogAlert(BuildContext context, String message) {
    Alert(
      context: context,
      title: "Partner Perks",
      desc: message,
      buttons: [
        DialogButton(
          color: const Color(0xffc22ea1),
          onPressed: () {
            setState(() {
              widget.changeScreen!(3);
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
          width: 120,
          child: const AppText("Yes", fontSize: 18),
        ),
        DialogButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            color: Colors.grey,
            child: const AppText("Cancel", fontSize: 18)),
      ],
    ).show();
  }

  pointCheckDialog(BuildContext context, String message) {
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
          child: const AppText("Ok", fontSize: 18),
        ),
      ],
    ).show();
  }

  pointsAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID"),
    };
    var response = await http
        .post(Uri.parse("${Api.baseUrl}" "${Api().get_points}"), body: data);

    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      pointsData = PointsData.fromJson(json.decode(response.body));

      pointInt = int.parse(pointsData.data!.points.toString());
      setState(() {
        if (sharedPreferences.getString("is_first") == "0") {
          if (pointInt < 100) {
            int remainPoint = 100 - pointInt;
            setState(() {
              pointCheckDialog(context,
                  "You are just ${remainPoint.toString()} points away.");
            });
          } else {
            dialogAlert(context, Message().RedeemConfirmMsg);
          }
        } else {
          if (pointInt < 50) {
            int remainPoint = 50 - pointInt;
            setState(() {
              pointCheckDialog(context,
                  "You are just ${remainPoint.toString()} points away.");
            });
          } else {
            dialogAlert(context, Message().RedeemConfirmMsg);
          }
        }
      });
    } else {
      log("Failure API");
      Utility().toast(context, Message().ErrorMsg);
    }
  }

  @override
  void initState() {
    dashboardAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return OfflineBuilder(
        debounceDuration: Duration.zero,
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          if (connectivity == ConnectivityResult.none) {
            return const ConnectivityMessage();
          }
          return child;
        },
        child: BGImageWithChild(
          imgUrl: "dashboard-bg.png",
          child: ListView(
            children: [
              pointCard(),
              redeemCard(),
              const SizedBox(height: 40),
            ],
          ),
        ));
  }

  Widget pointCard() {
    double pointLimit = double.parse('${'$points.0'}');

    double percentage = (double.parse('${'0.$amount'}'));
    if (pointLimit >= 100) {
      percentage = 1.0;
    } else {
      percentage = percentage;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('Assets/cardBG.png'), fit: BoxFit.cover)),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CircularPercentIndicator(
                          radius: 55.0,
                          animation: true,
                          lineWidth: 8.0,
                          percent: percentage,
                          progressColor: const Color(0xff31bbd2),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        AppText(
                          "\$$amount",
                          textAlign: TextAlign.center,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            "PHYSICIAN'S WEEKLY",
                            style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                              fontFamily: "Garamond",
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Partner\nPerks",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontFamily: 'texgyreadventor-regular',
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Available Points: ",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: 'texgyreadventor-regular',
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(width: 5.0),
                  Text(
                    "$points",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: Color(0xff4725a3),
                      fontFamily: 'texgyreadventor-regular',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget redeemCard() {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromRGBO(255, 255, 255, 0.15),
      ),
      child: Column(
        children: <Widget>[
          PosterCard(
            title: "Redeem",
            subTitle: "For Gift Cards",
            onTap: () {
              pointsAPI();
            },
            imageAsset: "Assets/redeem.png",
          ),
          const SizedBox(height: 15.0),
          PosterCard(
            title: "Scan Poster",
            subTitle: "To earn More Points",
            onTap: () {
              widget.changeScreen!(2);
            },
            imageAsset: "Assets/scan.png",
          ),
          const SizedBox(height: 15.0),
          PosterCard(
            title: "Wallboard Image",
            subTitle: "To earn Bonus Points",
            onTap: () {
              widget.changeScreen!(5);
            },
          ),
        ],
      ),
    );
  }
}
