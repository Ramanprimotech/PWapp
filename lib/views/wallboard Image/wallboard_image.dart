import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pwlp/utils/API_Constant.dart';
import 'package:pwlp/widgets/button/elevated_btn.dart';
import 'package:pwlp/widgets/utility/Utility.dart';
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../../Model/scanner/QRCodeCheckData.dart';
// ignore_for_file: deprecated_member_use

typedef VoidWithIntCallback = void Function(int);

class Wallboard extends StatefulWidget {
  final VoidWithIntCallback? changeScreen;
  const Wallboard({Key? key, this.changeScreen}) : super(key: key);
  @override
  _WallboardState createState() => _WallboardState();
}

class _WallboardState extends State<Wallboard> {
  bool _isVisible = true;
  bool _isImageVisible = false;
  String imageStr = "";

  //Check Image API
  imageMatchAPI(String image) async {
    log('this is imge url $image');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Utility().onLoading(context, true);

    Map data = {
      'user_id': sharedPreferences.getString("userID"),
      'poster_image': image,
      'specialty': sharedPreferences.getString("specialty"),
      'device_id': '1234568iOSdummyValue123456789',
    };
    log(data.toString());
    var response = await http.post(
        Uri.parse(Webservice().apiUrl + Webservice().add_poster_image),
        body: data);
    log('this is response ${response.statusCode}');
    log('this is response body ${response.body.toString()}');
    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      setState(() {
        _isImageVisible = true;
        _isVisible = false;
      });
    } else {
      setState(() {
        _isImageVisible = false;
        _isVisible = true;
      });
    }
  }

  submitWallboardImage() async {
    setState(() {
      _isImageVisible = false;
      _isVisible = true;

      Alert(
        // alertAnimation: ,
        context: context,
        title: "Partner Perks",
        desc:
            " Thank you for sbumitting the Wallboard Image. We'll review the submission and notify you soon.",
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
  }

  Future getImageFromSource(ImageSource source) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: source, maxHeight: 300, maxWidth: 300);
      if (image == null) {
        return;
      } else {
        final imageCamera = image.path;
        setState(() {
          imageMatchAPI(imageCamera);
        });
      }
    } on PlatformException catch (e) {
      log('Failed to pick image : $e');
    }
  }

  actionSheetForImage(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'PW Partner Perks',
          style: TextStyle(
              fontSize: 20.0,
              color: Color(0xff4725a3),
              fontFamily: 'texgyreadventor-regular'),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text("Open Camera"),
            onPressed: () {
              getImageFromSource(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Open Gallery'),
            onPressed: () {
              getImageFromSource(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
                fontFamily: 'texgyreadventor-regular', color: Colors.red),
          ),
        ),
      ),
    );
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
                "Wallboard Image",
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
                    btnLable: 'Choose Picture',
                    onPressed: () {
                      actionSheetForImage(context);
                    })),
          ),
        ],
      ),
    );
    final imageScreen = Visibility(
      visible: _isImageVisible,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: const Text(
                "Successfully Uploaded",
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
                //  imageStr,
                'https://i.pinimg.com/736x/c1/9d/79/c19d7964360a0144b39a0e4b67ca2cfb.jpg',
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
                        btnLable: 'Retake',
                        onPressed: () {
                          actionSheetForImage(context);
                        }),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 55.0,
                    width: 150.0,
                    child: CustomBtn(
                        btnLable: 'Submit',
                        onPressed: () {
                          submitWallboardImage();
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
            imageScreen
          ]),
        ));
  }
}