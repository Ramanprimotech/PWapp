import 'dart:convert';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/widgets/AppText.dart';
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
    var response = await http
        .post(Uri.parse("${Api.baseUrl}${Api().get_user_wallet}"), body: body);
    dynamic data = json.decode(response.body);
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppText(
                  "Activity",
                  fontSize: 25.0,
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                ),
                FutureBuilder<List<WalletModel>>(
                  future: future,
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: MediaQuery.of(context).size.height * .6,
                        alignment: Alignment.center,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return Container(
                        height: MediaQuery.of(context).size.height * .6,
                        alignment: Alignment.center,
                        child: const Text(
                          "Here, you can see the posters you scanned and reward amount earned.",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    List<WalletModel> items = snapshot.data!;

                    return ListView.separated(
                      itemCount: items.length + 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 8, bottom: 100),
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return const SizedBox(height: 40);
                        }
                        final WalletModel wallet = items[index];
                        return _WalletCard(wallet);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard(
    this.wallet, {
    Key? key,
  }) : super(key: key);

  final WalletModel wallet;

  String get _date =>
      formatDate(DateTime.parse(wallet.createdAt), [dd, '-', mm, '-', yyyy])
          .toString();

  @override
  Widget build(BuildContext context) {
    final bool isWallet = wallet.catgory == "wallet";
    return Container(
      height: 150,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white24,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(isWallet ? "Redemption" : "Scanned Poster",
                    fontSize: 20),
                if (isWallet) ...[
                  Row(
                    children: [
                      const _CardText("Amount: "),
                      _CardText(
                        "\$${wallet.amount.isEmpty ? 0 : wallet.amount}",
                        isBold: false,
                      ),
                    ],
                  ),
                ] else ...[
                  wallet.specialty != null
                      ? _CardText(wallet.specialty)
                      : _CardText("specialty"),
                ],
                Row(
                  children: [
                    _CardText(
                      isWallet ? "Redeemed: " : "Earned: ",
                    ),
                    _CardText(
                      "${wallet.points.isEmpty ? 0 : wallet.points} Points",
                      isBold: false,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const _CardText("Date: "),
                    _CardText(
                      _date,
                      isBold: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: wallet.posterImage == null
                ? Image.asset("Assets/walletCard.png")
                : Align(
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        Api.baseImageUrl + wallet.posterImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _CardText extends StatelessWidget {
  const _CardText(
    this.label, {
    Key? key,
    this.fontSize = 16,
    this.isBold = true,
  }) : super(key: key);

  final String label;
  final double fontSize;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
          fontFamily: 'texgyreadventor-regular',
          fontWeight: isBold ? FontWeight.w500 : FontWeight.w200,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
