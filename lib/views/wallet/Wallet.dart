import 'dart:developer';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/pw_app.dart';

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

    print("fdsfsfsfsfsssfs $data");
    if (data['success']) {
      try {
        return (data['data'] as List)
            .map((e) => WalletModel.fromMap(e))
            .toList();
      } catch (e) {
        return [];
      }
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
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppText(
                  "Activity",
                  fontSize: 26.0,
                  fontWeight: FontWeight.w700,
                  padding: EdgeInsets.symmetric(vertical: 24),
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
                          child: const AppText(
                            "Here you can see the posters you have scanned and the total reward amount earned.",
                            fontSize: 21.0,
                            padding: EdgeInsets.all(26),
                            // color: Colors.black,
                            fontWeight: FontWeight.w500,
                            maxLines: 8,
                            textAlign: TextAlign.center,
                          ));
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
      formatDate(DateTime.parse(wallet.createdAt), [mm, '-', dd, '-', yyyy])
          .toString();

  @override
  Widget build(BuildContext context) {
    final bool isWallet = wallet.catgory == "scanned_posters";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppText(
                  isWallet
                      ? "Scanned Poster"
                      : wallet.catgory.toString() == "redemption"
                          ? "Redemption"
                          : "Wallboard Poster",
                  fontSize: 20,
                ),
                SizedBox(height: 8),
                if (wallet.specialty.isNotEmpty)
                  _CardText(label: "Specialty", label2: wallet.specialty),
                if (wallet.isApproved != "")
                  _CardText(label: "Status", label2: wallet.isApproved),
                if (wallet.points != "0")
                  _CardText(
                      label: isWallet ? "Redeemed: " : "Earned: ",
                      label2: wallet.points),
                if (wallet.points != "0")
                  _CardText(label: "Date", label2: _date),
                // if (isWallet) ...[
                //   wallet.amount != "" && wallet.amount != 0
                //       ? Row(
                //           children: [
                //             const _CardText("Amount: aFWFFAF"),
                //             _CardText(
                //               "\$${wallet.amount.isEmpty ? 0 : wallet.amount}",
                //               isBold: false,
                //             ),
                //           ],
                //         )
                //       : const SizedBox(height: 0, width: 0),
                // ] else ...[
                //   wallet.specialty != null
                //       ? _CardText(wallet.specialty)
                //       : _CardText("specialty"),
                // ],
                ///
                // Row(
                //   children: [
                //     _CardText(
                //       isWallet ? "Redeemed: " : "Earned: ",
                //     ),
                //     _CardText(
                //       "${wallet.points.isEmpty ? 0 : wallet.points} Points",
                //       isBold: false,
                //     ),
                //   ],
                // ),
                ///
                // Row(
                //   children: [
                //     const _CardText("Date: "),
                //     _CardText(
                //       _date,
                //       isBold: false,
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: wallet.posterImage == null
                  ? Container(child: Image.asset("Assets/walletCard.png"))
                  : Image.network(
                      Api.baseImageUrl + wallet.posterImage!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardText extends StatelessWidget {
  const _CardText({
    Key? key,
    this.label2,
    this.label,
    this.fontSize,
    this.isBold = true,
  }) : super(key: key);

  final String? label;
  final String? label2;
  final double? fontSize;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppText(
            "$label: ",
            fontSize: fontSize ?? 15,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
          Expanded(
            child: AppText(label2 ?? "",
                fontSize: fontSize ?? 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                maxLines: 3),
          ),
        ],
      ),
    );
  }
}
