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
  late Future<List<WalletModel>> future;

  Future<List<WalletModel>> getWalletAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      'user_id': sharedPreferences.getString("userID"),
    };
    var response = await http.post(Uri.parse("${Webservice().apiUrl}${Webservice().get_user_wallet}"), body: body);
    dynamic data = json.decode(response.body);
    log("Response = $data");
    if (data['success']) {
      return (data['data'] as List).map((e) => WalletModel.fromMap(e)).toList();
    } else {
      log("Failure API");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    future = getWalletAPI();
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
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/dashboard-bg.png'),
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "Activity",
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular',
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<WalletModel>>(
                  future: future,
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          "Here, you can see the posters you scanned and reward amount earned.",
                          style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w400),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    List<WalletModel> items = snapshot.data!;

                    return ListView.separated(
                      itemCount: items.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final WalletModel wallet = items[index];
                        DateTime todayDate = DateTime.parse(wallet.createdAt.toString());
                        String date = formatDate(todayDate, [dd, '-', mm, '-', yyyy]).toString();
                        return Container(
                          padding: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white24,
                          ),
                          child: Row(
                            children: [],
                          ),
                        );
                        if (wallet.catgory.toString() == "wallet") {
                          return Container(
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
                                                  text: "\$${wallet.amount} ",
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
                                                  text: "${wallet.points} Points",
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
                                                  text: date,
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
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.only(
                              left: 10.0,
                              top: 20.0,
                              right: 10.0,
                            ),
                            padding: const EdgeInsets.all(15.0),
                            decoration:
                                const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)), color: Color.fromRGBO(255, 255, 255, 0.15)),
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
                                              "${wallet.specialty}",
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
                                                  text: "${wallet.points} Points",
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
                                                  text: date,
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
                                            "${wallet.posterImage}"),
                                        fit: BoxFit.fill,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
