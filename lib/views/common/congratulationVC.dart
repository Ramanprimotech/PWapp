import 'dart:developer';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import '../../Model/common/MoneyData.dart';
import 'package:pwlp/pw_app.dart';

class CongratulationVC extends StatefulWidget {
  const CongratulationVC({Key? key}) : super(key: key);

  @override
  _CongratulationVCState createState() => _CongratulationVCState();
}

class _CongratulationVCState extends State<CongratulationVC> {
  String pointsStr = "0";
  String moneyStr = "0";
  late MoneyData moneyData;
  double moneyD = 0.0;

  moneyAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();

    Map data = {
      'user_id': sharedPreferences.getString("userID"),
      'points': sharedPreferences.getString("points").toString(),
    };
    var response = await http.post(
        Uri.parse("${Api.baseUrl}" + "${Api().get_user_blance}"),
        body: data);

    if (response.statusCode == 200) {
      setState(() {
        moneyData = MoneyData.fromJson(json.decode(response.body));
        moneyD = double.parse(moneyData.data!.money!);
        moneyStr = "${moneyD.round().toString()}";
        pointsStr = "${sharedPreferences.getString("points").toString()}";
        sharedPreferences.setString("CheckUser", "newuser");
      });
    } else {
      log("Failure API");
      Utility().toast(context, Message().ErrorMsg);
    }
  }

  @override
  void initState() {
    moneyAPI();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firstExp = Container(
        child: Container(
      margin: const EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      child: Column(
        children: <Widget>[
          const Text(
            "Congratulations!",
            style: TextStyle(
                fontSize: 37.0,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular'),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: const Center(
              child: Text(
                "Your Registration is Successful",
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    ));
    final SecondContainer = Container(
        child: Container(
      margin: const EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
      padding: const EdgeInsets.only(
          left: 15.0, top: 15.0, right: 15.0, bottom: 20.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Color.fromRGBO(255, 255, 255, 0.15)),
      child: Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
                text: "You have earned ",
                style: const TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular'),
                children: [
                  TextSpan(
                    text: "$pointsStr ",
                    style: const TextStyle(
                        fontSize: 22.0,
                        color: Colors.lightBlueAccent,
                        fontFamily: 'texgyreadventor-regular',
                        fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: "Points",
                    style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontFamily: 'texgyreadventor-regular'),
                  )
                ]),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Center(
                child: RichText(
              text: TextSpan(
                  text: "Worth ",
                  style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                      fontFamily: 'texgyreadventor-regular'),
                  children: [
                    TextSpan(
                      text: "\$$moneyStr ",
                      style: const TextStyle(
                          fontSize: 22.0,
                          color: Colors.lightBlueAccent,
                          fontFamily: 'texgyreadventor-regular',
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            )),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Center(
                child: RichText(
              text: const TextSpan(
                text: "Start Scanning Now!",
                style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular'),
              ),
            )),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Center(
                child: RichText(
              text: const TextSpan(
                text: "To earn more points",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular'),
              ),
            )),
          )
        ],
      ),
    ));
    final ThridContainer = Container(
        margin: const EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
        padding: const EdgeInsets.only(
            left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Color.fromRGBO(255, 255, 255, 0.15)),
        child: Column(
          children: <Widget>[
            InkWell(
              child: Container(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: const <Widget>[
                          Text(
                            "Dashboard",
                            style: TextStyle(
                                fontSize: 30.0,
                                color: Color(0xff4725a3),
                                fontFamily: 'texgyreadventor-regular'),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Partner Perks",
                            style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                                fontFamily: 'texgyreadventor-regular'),
                            textAlign: TextAlign.start,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Container(
                      child: Image.asset('Assets/dashboardIcon.png'),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/Dashboard');
              },
            ),
          ],
        ));
    final FourthContainer = Container(
      margin: const EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0),
      padding: const EdgeInsets.only(
          left: 15.0, top: 15.0, right: 15.0, bottom: 20.0),
      child: const Text(
        "Scan poster to earn more points.",
        style: TextStyle(
            fontSize: 22.0,
            color: Colors.white,
            fontFamily: 'texgyreadventor-regular'),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
    );
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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                Message().AppBarTitle,
                style: const TextStyle(
                    fontSize: 20.0, color: Colors.white, fontFamily: 'texgyreadventor-regular'),
              ),
              backgroundColor: const Color(0xff4725a3),
            ),
            body: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('Assets/congratesBG.png'),
                        fit: BoxFit.fill,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      firstExp,
                      const SizedBox(
                        height: 10.0,
                      ),
                      SecondContainer,
                      const SizedBox(
                        height: 10.0,
                      ),
                      ThridContainer,
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
