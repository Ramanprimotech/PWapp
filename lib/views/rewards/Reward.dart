
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import '../../Model/common/MoneyData.dart';
import '../../Model/common/PointsData.dart';
import 'package:pwlp/pw_app.dart';

typedef VoidWithIntCallback = void Function(int);

class RewardView extends StatefulWidget {
  final VoidWithIntCallback? changeScreen;

  const RewardView({Key? key, this.changeScreen}) : super(key: key);

  @override
  _RewardViewState createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {
  double PointPercent = 0.0;
  String pointInStr = "0";
  int pointInt = 0;
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

  _redeemPointsNew(String pointStr) async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    String uri = Api.baseUrl + Api().save_redemption;
    var request = http.MultipartRequest('POST', Uri.parse(uri));
    request.fields['user_id'] = sharedPreferences.getString("userID") ?? "";
    request.fields['email'] = sharedPreferences.getString('email') ?? "";
    request.fields['speciality'] =
        sharedPreferences.getString('specialty') ?? "";
    request.fields['first_name'] =
        sharedPreferences.getString('firstname') ?? "";
    request.fields['last_name'] = sharedPreferences.getString('lastname') ?? "";
    request.fields['points'] = pointInt.toString();
    request.fields['amount'] = (pointInt / 10).toString();

    // Send the request
    var response = await request.send();
    // Get the response as a string
    var responseData = await response.stream.bytesToString();
    final jsonStr = json.decode(responseData);

    if (response.statusCode == 200) {
      Utility().toast(context, "${jsonStr['message']}");
      Utility().onLoading(context, false);
    } else {
      Utility().toast(context, Message().ErrorMsg);
      Utility().onLoading(context, false);
    }
  }

  _pointsAPINew() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID"),
    };

    String uri = Api.baseUrl + Api().get_points;

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
        int remainderPoint = tempPoint % 10;
        int finalPoints = totalPoint - remainderPoint;
        pointsToredeemStr = finalPoints.toString();
      });
      _redeemPointsNew(pointsToredeemStr);
    } else {
      Utility().toast(context, Message().ErrorMsg);
    }
  }

  @override
  void initState() {
    _pointsAPINew();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double amount = pointInt / 10;
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
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/dashboard-bg.png'),
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
          child: ListView(
            children: [
              AppText(
                redeemMsg,
                fontSize: 21.0,
                color: Colors.white,
                fontWeight: FontWeight.w300,
                textAlign: TextAlign.center,
                padding: const EdgeInsets.only(top: 35, bottom: 8),
              ),
              Text(
                "$pointsToredeemStr Points!",
                style: const TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),

              /// Card Image View
              Container(
                margin: const EdgeInsets.only(left: 16, top: 40, right: 16),
                child: Stack(
                  children: <Widget>[
                    Image.asset('Assets/redeemBG.png', fit: BoxFit.fill),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10),
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Image.asset(
                                          'Assets/redeemPointCir.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Text(
                                        amount.toStringAsFixed(0),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.white,
                                            fontFamily:
                                                'texgyreadventor-regular',
                                            fontWeight: FontWeight.w600),
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
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0,left: 10.0),
                                    child: Text(
                                      "PHYSICIAN'S WEEKLY",
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          color: Colors.white,
                                          fontFamily: "Garamond",
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ),
                                  SizedBox(height: 10),
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

              /// Card Image View
              Container(
                margin: const EdgeInsets.only(
                    left: 16, top: 30.0, right: 16, bottom: 15.0),
                padding: const EdgeInsets.only(
                    left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    color: Color(0xffc22ea1)),
                child: Column(
                  children: const [
                    AppText("Redemption Pending", fontWeight: FontWeight.w600,
                      fontSize: 20),
                    SizedBox(height: 12),
                    Text(
                      "Thank you. Your redemption request has been submitted. Please allow us 1-3 days to process your gift card!",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'texgyreadventor-regular',
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
