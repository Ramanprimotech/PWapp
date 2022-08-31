import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:pwlp/widgets/poster.dart';
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:convert';
import '../../utils/API_Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../validators/Message.dart';
import '../../Model/dashboard/DashboardData.dart';
import '../../Model/common/MoneyData.dart';
import '../../Model/common/PlaceOrderData.dart';
import '../../Model/common/PointsData.dart';
import '../../widgets/utility/Utility.dart';

typedef VoidWithIntCallback = void Function(int);

class Home extends StatefulWidget {
  final VoidWithIntCallback? changeScreen;

  const Home({Key? key, this.changeScreen}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String amount = "0";
  String points = "0";
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
        Uri.parse("${Webservice().apiUrl}" + "${Webservice().user_dashboard}"),
        body: data);
    if (response.statusCode == 200) {
      final user_dashboardData =
          DashboardData.fromJson(json.decode(response.body));
      double moneyD = double.parse(user_dashboardData.data!.money!);
      setState(() {
        points = "${user_dashboardData.data!.points.toString()}";
        amount = "${moneyD.round().toString()}";
        if (points == "0" && amount == "0") {
          Timer(const Duration(seconds: 3), () {
            Utility().toast(context, Message().noMoneyMsg);
          });
        }
      });
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
          child: const Text(
            "Yes",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'texgyreadventor-regular'),
          ),
        ),
        DialogButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          color: Colors.grey,
          child: const Text(
            "Cancel",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'texgyreadventor-regular'),
          ),
        ),
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

  pointsAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID"),
    };
    var response = await http.post(
        Uri.parse("${Webservice().apiUrl}" + "${Webservice().get_points}"),
        body: data);
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
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/dashboard-bg.png'),
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
          child: ListView(
            children: [pointCard(), redeemCard()],
          ),
        ));
  }

  Widget pointCard() {
    return Container(
      margin: const EdgeInsets.only(left: 12.0, top: 20.0, right: 12.0),
      child: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'Assets/cardBG.png',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                'Assets/point.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Text(
                              "\$$amount",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                                fontFamily: 'texgyreadventor-regular',
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: Column(
                      children: const <Widget>[
                        Text(
                          "PHYSICIAN'S WEEKLY",
                          style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.white,
                              fontFamily: "Garamond",
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(height: 7),
                        Text(
                          "Partner",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontFamily: 'texgyreadventor-regular',
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "Perks",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontFamily: 'texgyreadventor-regular',
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Flexible(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Available Points",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontFamily: 'texgyreadventor-regular',
                            fontWeight: FontWeight.w300),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Flexible(
                    flex: 3,
                    child: Text(
                      "$points",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 30.0,
                          color: Color(0xff4725a3),
                          fontFamily: 'texgyreadventor-regular',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget redeemCard() {
    return Container(
        margin: const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
        padding: const EdgeInsets.only(
            left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Color.fromRGBO(255, 255, 255, 0.15)),
        child: Column(
          children: <Widget>[
            PosterCard(
              mainTitle: "Redeem",
              subTitle: "For Gift Cards",
              onTap: () {
                pointsAPI();
              },
              imageAsset: "Assets/redeem.png",
            ),
            const SizedBox(height: 10.0),
            PosterCard(
              mainTitle: "Scan Poster",
              subTitle: "To earn More Points",
              onTap: () {
                widget.changeScreen!(2);
              },
              imageAsset: "Assets/scan.png",
            ),
          ],
        ));
  }
}
