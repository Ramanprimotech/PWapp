import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:pwlp/widgets/button/elevated_btn.dart';
import 'package:pwlp/widgets/utility/Utility.dart';
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import '../../utils/API_Constant.dart';
import '../../Model/scanner/QRCodeCheckData.dart';
// ignore_for_file: deprecated_member_use

typedef VoidWithIntCallback = void Function(int);

class Scanner extends StatefulWidget {
  final VoidWithIntCallback? changeScreen;
  const Scanner({Key? key, this.changeScreen}) : super(key: key);
  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  bool _isVisible = true;
  bool _isVisibleScannedCont = false;
  String result = "Scanner Screen";
  String imageStr = "";
  late QrCodeCheckData qrCodeCheckData;
  //Check Poster API
  scanMatchAPI(String name) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Utility().onLoading(context, true);

    Map data = {
      'name': name,
      'specialty': sharedPreferences.getString("specialty"),
    };

    var response = await http.post(
        Uri.parse(Webservice().apiUrl + Webservice().check_qr_code),
        body: data);

    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      qrCodeCheckData = QrCodeCheckData.fromJson(json.decode(response.body));
      setState(() {
        imageStr = "${Webservice().imagePath}" +
            "${qrCodeCheckData.data![0].posterImage.toString()}";
        _isVisibleScannedCont = true;
        _isVisible = false;
      });
    } else {
      final qRCodeMatchError =
          QrCodeMatchError.fromJson(json.decode(response.body));
      setState(() {
        _isVisibleScannedCont = false;
        _isVisible = true;
      });
      Utility().toast(context, qRCodeMatchError.message.toString());
    }
  }

  posterConfirmAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'name': "${qrCodeCheckData.data![0].name}",
      'user_id': sharedPreferences.getString("userID"),
      'qr_code_id': "${qrCodeCheckData.data![0].id.toString()}",
      'specialty': "${qrCodeCheckData.data![0].specialty.toString()}",
      'points': "${qrCodeCheckData.data![0].point.toString()}"
    };

    var response = await http.post(
        Uri.parse("${Webservice().apiUrl}" + "${Webservice().save_poster}"),
        body: data);
    Utility().onLoading(context, false);

    if (response.statusCode == 200) {
      setState(() {
        _isVisibleScannedCont = false;
        _isVisible = true;

        Alert(
          context: context,
          title: "Partner Perks",
          desc:
              "${qrCodeCheckData.data![0].point.toString()} points added successfully.",
          buttons: [
            DialogButton(
              color: const Color(0xffc22ea1),
              onPressed: () {
                widget.changeScreen!(0);
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
      });
    } else {
      log("Failure API");

      Utility().toast(context, "This QR-code is not available");
    }
  }

  Future<void> _scanQR() async {
    try {
      String result = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (result != "-1") {
        setState(() {
          scanMatchAPI(result);
        });
      }
    } catch (e) {
      log('error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    final helpCont = Visibility(
      visible: _isVisible,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: const Text(
                "Scan QR Code",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, right: 30.0, bottom: 10.0, left: 30.0),
              child: Container(
                margin: const EdgeInsets.only(right: 40.0, left: 40.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('Assets/helpBG.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Flexible(
            flex: 3,
            child: SizedBox(
                height: 55.0,
                width: 250.0,
                child: CustomBtn(
                    btnLable: 'Scan Poster',
                    onPressed: () {
                      _scanQR();
                    })),
          ),
        ],
      ),
    );
    final scannedScreen = Visibility(
      visible: _isVisibleScannedCont,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: const Text(
                "Scanned Successfully",
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.network(
                imageStr,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Flexible(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 55.0,
                    width: 150.0,
                    child: CustomBtn(
                        btnLable: 'Scan Again',
                        onPressed: () {
                          _scanQR();
                        }),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 55.0,
                    width: 150.0,
                    child: CustomBtn(
                        btnLable: 'Confirm',
                        onPressed: () {
                          posterConfirmAPI();
                        }),
                  ),
                )
              ],
            ),
          ),
        ],
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
        child: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/dashboard-bg.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            helpCont,
            scannedScreen
          ]),
        ));
  }
}
