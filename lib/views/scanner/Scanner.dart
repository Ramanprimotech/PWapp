import 'dart:developer';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import '../../Model/scanner/QRCodeCheckData.dart';
import 'package:pwlp/pw_app.dart';

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
      'device_id': "1234568iOSdummyValue123456789",
    };
    log('This is the qr code ${data.toString()}');

    var response = await http.post(Uri.parse(Api.baseUrl + Api().check_qr_code),
        body: data);
    log(response.toString());

    Utility().onLoading(context, false);
    log('This is the Response ${response.statusCode.toString()}');
    if (response.statusCode == 200) {
      log('This is the Response ${response.body.toString()}');

      qrCodeCheckData = QrCodeCheckData.fromJson(json.decode(response.body));
      setState(() {
        imageStr = "${Api.baseImageUrl}" +
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

    var response = await http
        .post(Uri.parse("${Api.baseUrl}" + "${Api().save_poster}"), body: data);
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
          debugPrint("result --- $result");
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
            child: Center(
              child: Container(
                width: 250.0,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('Assets/helpBG.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Flexible(
              flex: 2,
              child: AppText("Scanned Successfully",
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            Flexible(flex: 6, child: Image.network(imageStr, fit: BoxFit.fill)),
            const SizedBox(height: 35),
            Flexible(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: CustomBtn(
                        btnLable: 'Scan Again',
                        onPressed: () {
                          _scanQR();
                        }),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomBtn(
                        btnLable: 'Confirm',
                        onPressed: () {
                          posterConfirmAPI();
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        body: Stack(
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
            helpCont,
            scannedScreen
          ],
        ),
      ),
    );
  }
}
