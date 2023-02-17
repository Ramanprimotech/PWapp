import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/common/MoneyData.dart';
import '../../Model/common/PlaceOrderData.dart';
import '../../Model/common/PointsData.dart';
import '../../utils/API_Constant.dart';
import '../../validators/Message.dart';
import '../../widgets/utility/Utility.dart';

typedef VoidWithIntCallback = void Function(int);

class Reward extends StatefulWidget {
  final VoidWithIntCallback? changeScreen;

  const Reward({Key? key, this.changeScreen}) : super(key: key);

  @override
  _RewardState createState() => _RewardState();
}

class _RewardState extends State<Reward> {
  double PointPercent = 0.0;
  String pointInStr = "0";
  int pointInt = 0;
  final bool _isvisiable = false;
  final bool _isPointscreenVisible = false;
  final bool _isRedeemscreenVisible = false;
  String messageStr = "";
  late MoneyData moneyData;
  late PlaceOrderData placeOrderData;
  late PointsData pointsData;
  double moneyD = 0.0;
  String moneyStr = "0";
  String? specialityStr = "";
  String dateStr = "";
  String pointsToredeemStr = "";
  String redeemMsg = "Redemption";

  _launchURL() async {
    var url =
        "${placeOrderData.reward!.credentials!.redemptionLink.toString()}";
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  pointsAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID"),
    };

    String uri = Webservice().apiUrl + Webservice().get_points;

    var response = await http.post(
      Uri.parse(uri),
      body: data,
    );

    if (response.statusCode == 200) {
      pointsData = PointsData.fromJson(json.decode(response.body));
      setState(() {
        pointInt = int.parse(pointsData.data!.points.toString());
        int totalPoint = int.parse(pointsData.data!.points!);
        int tempPoint = totalPoint;
        int remainderPoint = tempPoint % 50;
        int finalPoints = totalPoint - remainderPoint;
        pointsToredeemStr = finalPoints.toString();
      });
      moneyAPI(pointsToredeemStr);
    } else {
      log("Failure API Points");
      Utility().toast(context, Message().ErrorMsg);
    }
  }

  moneyAPI(String pointStr) async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID"),
      'points': pointStr
    };

    String uri = Webservice().apiUrl + Webservice().get_user_blance;

    var response = await http.post(
      Uri.parse(uri),
      body: data,
    );

    if (response.statusCode == 200) {
      setState(() {
        moneyData = MoneyData.fromJson(json.decode(response.body));
        moneyD = double.parse(moneyData.data!.money!);
        moneyStr = "${moneyD.round().toString()}";
        specialityStr = sharedPreferences.getString("specialty");
      });
      placeOrderAPI();
    } else {
      log("Failure API money");
      Utility().onLoading(context, false);
      Utility().toast(context, Message().ErrorMsg);
    }
  }

  saveOrder() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID").toString(),
      'fisrtname': sharedPreferences.getString("firstname").toString(),
      'lastname': sharedPreferences.getString("lastname").toString(),
      'email': sharedPreferences.getString("email").toString(),
      'points': pointsToredeemStr,
      'amount': moneyD.toString(),
      'tc_order_id': placeOrderData.referenceOrderID.toString(),
      'redemption_link':
          placeOrderData.reward!.credentials!.redemptionLink.toString(),
    };

    String uri = Webservice().apiUrl + Webservice().save_oder;

    var response = await http.post(
      Uri.parse(uri),
      body: data,
    );
    if (response.statusCode == 200) {
      sharedPreferences.setString("is_first", "1");
    } else {
      log("Failure API save order");
      Utility().toast(context, Message().ErrorMsg);
    }
  }

  placeOrderAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    var body = json.encode({
      "accountIdentifier": sharedPreferences.getString("accountIdentifier"),
      "amount": moneyD,
      "campaign": "Partner Perks",
      "customerIdentifier": sharedPreferences.getString("customer_identifier"),
      "emailSubject": "Partner Perks Reward Card",
      "etid": sharedPreferences.getString("etid"),
      // "externalRefID": "",
      "message": "You have got reward by Partner Perks.",
      "notes": "Partner Perks",
      "recipient": {
        "email": sharedPreferences.getString("email"),
        "firstName": sharedPreferences.getString("firstname"),
        "lastName": sharedPreferences.getString("lastname")
      },
      "sendEmail": true,
      "sender": {
        "email": sharedPreferences.getString("sender_email"),
        "firstName": sharedPreferences.getString("sender_firstname"),
        "lastName": sharedPreferences.getString("sender_lastname")
      },
      "utid": "U143628"
    });
    String? platformName = sharedPreferences.getString("platform_name");
    String? platformKey = sharedPreferences.getString("platform_key");

    String keyPair = '$platformName:$platformKey';
    String base = base64Encode(utf8.encode(keyPair));
    String basicAuth = 'Basic $base';
    String uri = Webservice().tangoCardBaseUrl + Webservice().orders;

    var response = await http.post(
      Uri.parse(uri),
      body: body,
      headers: <String, String>{
        'authorization': basicAuth,
        "Content-Type": "application/json",
      },
    );
    Utility().onLoading(context, false);
    log(jsonDecode(response.body).toString());
    if (response.statusCode == 201) {
      placeOrderData =
          PlaceOrderData.fromJson(json.decode(response.body.toString()));
      dateStr = placeOrderData.createdAt.toString();
      DateTime todayDate = DateTime.parse(dateStr);
      setState(() {
        dateStr = formatDate(todayDate, [dd, '-', mm, '-', yyyy]).toString();
        setState(() {
          redeemMsg = "You have Successfully Redeemed";
        });
        saveOrder();
      });
    } else {
      log("Failure Place Order API");
      if (mounted) {
        setState(() {
          redeemMsg = "Redemption unsuccessful";
        });
      }
    }
  }

  @override
  void initState() {
    pointsAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final redeemScreen = Visibility(
        child: Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            const SizedBox(
              height: 35.0,
            ),
            Center(
              child: Text(
                redeemMsg,
                style: const TextStyle(
                    fontSize: 21.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Center(
              child: Text(
                "$pointsToredeemStr Points!",
                style: const TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          margin: const EdgeInsets.only(left: 12.0, top: 20.0, right: 12.0),
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Image.asset(
                      'Assets/redeemBG.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, left: 10.0),
                            child: Container(
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Center(
                                        child: Image.asset(
                                          'Assets/redeemPointCir.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "\$$moneyStr",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.white,
                                          fontFamily: 'texgyreadventor-regular',
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 7,
                          child: Container(
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
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  "Partner Perks",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.white,
                                      fontFamily: 'texgyreadventor-regular',
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "",
                                  style: TextStyle(
                                      fontSize: 28.0,
                                      color: Colors.white,
                                      fontFamily: 'texgyreadventor-regular',
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 300.0,
                      padding: const EdgeInsets.only(
                        top: 23.0,
                      ),
                      child: Text(
                        "$dateStr",
                        style: const TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                            fontFamily: 'texgyreadventor-regular',
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: 12.0, top: 10.0, right: 12.0, bottom: 15.0),
          padding: const EdgeInsets.only(
              left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Color(0xffc22ea1)),
          child: const Text(
            "Please check your registered email for the Reward Card link!",
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular',
                fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ],
    ));
    return Scaffold(
      body: OfflineBuilder(
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
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/dashboard-bg.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            redeemScreen
          ],
        ),
      ),
    );
  }
}
