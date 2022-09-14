import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/wallet/WalletData.dart';
import '../../utils/API_Constant.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  WalletData? walletData;
  bool _isvissibleLoader = true;

  getWalletAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      'user_id': sharedPreferences.getString("userID"),
    };
    var response = await http.post(Uri.parse("${Webservice().apiUrl}${Webservice().get_user_wallet}"), body: body);
    log("Got data");
    dynamic data = json.decode(response.body);
    log("Response = $data");
    if (data['success']) {
      setState(() {
        walletData = WalletData.fromJson(data);
      });
    } else {
      log("Failure API");
      // Utility().toast(context, data['message']);
      setState(() {
        _isvissibleLoader = false;
      });
    }
  }

  @override
  void initState() {
    getWalletAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Scaffold(
          body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/dashboard-bg.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: <Widget>[
                  const Flexible(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Activity",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontFamily: 'texgyreadventor-regular',
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 9,
                    child: walletData != null
                        ? ListView.builder(
                            itemCount: walletData!.data!.length,
                            itemBuilder: (context, index) {
                              String dateStr = "";
                              DateTime todayDate = DateTime.parse(walletData!.data![index].createdAt.toString());
                              dateStr = formatDate(todayDate, [dd, '-', mm, '-', yyyy]).toString();
                              if (walletData!.data![index].catgory.toString() == "wallet") {
                                return Container(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 20.0,
                                      right: 10.0,
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        color: Color.fromRGBO(255, 255, 255, 0.15)),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 6,
                                          child: Column(
                                            children: <Widget>[
                                              const Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "Redemption",
                                                    style: TextStyle(
                                                        fontSize: 17.0,
                                                        color: Colors.white,
                                                        fontFamily: 'texgyreadventor-regular',
                                                        fontWeight: FontWeight.w500),
                                                  )),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 5.0),
                                                  child: RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                      text: "Amount: ",
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.white,
                                                          fontFamily: 'texgyreadventor-regular',
                                                          fontWeight: FontWeight.w500),
                                                      children: [
                                                        TextSpan(
                                                          text: "\$${walletData!.data![index].amount} ",
                                                          style: const TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.white,
                                                              fontFamily: 'texgyreadventor-regular',
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: RichText(
                                                  textAlign: TextAlign.start,
                                                  text: TextSpan(
                                                      text: "Redeemed: ",
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.white,
                                                          fontFamily: 'texgyreadventor-regular',
                                                          fontWeight: FontWeight.w500),
                                                      children: [
                                                        TextSpan(
                                                          text: "${walletData!.data![index].points} Points",
                                                          style: const TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.white,
                                                              fontFamily: 'texgyreadventor-regular',
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: RichText(
                                                  textAlign: TextAlign.start,
                                                  text: TextSpan(
                                                      text: "Date: ",
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.white,
                                                          fontFamily: 'texgyreadventor-regular',
                                                          fontWeight: FontWeight.w500),
                                                      children: [
                                                        TextSpan(
                                                          text: dateStr,
                                                          style: const TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.white,
                                                              fontFamily: 'texgyreadventor-regular',
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                      ]),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 5,
                                          child: Container(
                                            height: 100.0,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('Assets/walletCard.png'),
                                                fit: BoxFit.fill,
                                                alignment: Alignment.topCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 20.0,
                                      right: 10.0,
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        color: Color.fromRGBO(255, 255, 255, 0.15)),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 4,
                                          child: Column(
                                            children: <Widget>[
                                              const Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "Scanned Poster",
                                                    style: TextStyle(
                                                        fontSize: 17.0,
                                                        color: Colors.white,
                                                        fontFamily: 'texgyreadventor-regular',
                                                        fontWeight: FontWeight.w500),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5.0, bottom: 3.0),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      "${walletData!.data![index].specialty}",
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors.white,
                                                          fontFamily: 'texgyreadventor-regular',
                                                          fontWeight: FontWeight.w500),
                                                    )),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: RichText(
                                                  textAlign: TextAlign.start,
                                                  text: TextSpan(
                                                      text: "Earned: ",
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.white,
                                                          fontFamily: 'texgyreadventor-regular',
                                                          fontWeight: FontWeight.w500),
                                                      children: [
                                                        TextSpan(
                                                          text: "${walletData!.data![index].points} Points",
                                                          style: const TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.white,
                                                              fontFamily: 'texgyreadventor-regular',
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: RichText(
                                                  textAlign: TextAlign.start,
                                                  text: TextSpan(
                                                      text: "Date: ",
                                                      style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.white,
                                                          fontFamily: 'texgyreadventor-regular',
                                                          fontWeight: FontWeight.w500),
                                                      children: [
                                                        TextSpan(
                                                          text: dateStr,
                                                          style: const TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors.white,
                                                              fontFamily: 'texgyreadventor-regular',
                                                              fontWeight: FontWeight.w300),
                                                        ),
                                                      ]),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage("${Webservice().imagePath}"
                                                    "${walletData!.data![index].posterImage}"),
                                                fit: BoxFit.fill,
                                                alignment: Alignment.topCenter,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        : Center(
                            child: _isvissibleLoader == true
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : const Text(
                                    "Here, you can see the posters you scanned and reward amount earned.",
                                    style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w400),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                  )
                ],
              )),
        ));
  }
}
