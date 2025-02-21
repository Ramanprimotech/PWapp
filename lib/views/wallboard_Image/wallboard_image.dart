import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:pwlp/pw_app.dart';

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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Utility().onLoading(context, true);
    http.MultipartRequest request = http.MultipartRequest(
        "POST", Uri.parse(Api.baseUrl + Api().add_poster_image));

    request.fields["user_id"] =
        sharedPreferences.getString("userID").toString();
    request.fields["specialty"] =
        sharedPreferences.getString("specialty").toString();
    request.fields["device_id"] = "1234568iOSdummyValue123456789";

    http.ByteStream stream = http.ByteStream(File(image).openRead().cast());
    int length = await File(image).length();
    http.MultipartFile multipartFile = http.MultipartFile(
        'poster_image', stream, length,
        filename: path.basename(image));
    request.files.add(multipartFile);

    http.StreamedResponse responseStream = await request.send();

    http.Response response = await http.Response.fromStream(responseStream);
    Utility().onLoading(context, false);
    log('this is response ${response.statusCode}');
    log(response.body);
    if (response.statusCode == 200) {
      setState(() {
        /// NEW
        submitWallboardImage();
        _isImageVisible = false;
        _isVisible = true;

        /// OLD
        // _isImageVisible = true;
        // _isVisible = false;
      });
    } else {
      setState(() {
        /// OLD
        // _isImageVisible = false;
        // _isVisible = true;
        /// NEW
        _isImageVisible = true;
        _isVisible = false;
      });
    }
  }

  submitWallboardImage() async {
    setState(() {
      _isImageVisible = false;
      _isVisible = true;

      Alert(
        closeIcon: const SizedBox(
          height: 0,
        ),
        // alertAnimation: ,
        context: context,
        title: "Partner Perks",
        image: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Image.asset(
            "Assets/submit_check.png",
            height: 100,
          ),
        ),
        desc:
            " Thank you for submitting the Wallboard Image. We'll review the submission and notify you soon.",
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
          .pickImage(source: source);
      if (image == null) {
        return;
      } else {
        imageStr = image.path;
        setState(() {
          ///New
          _isImageVisible = true;
          _isVisible = false;

          /// OLD
          // imageMatchAPI(imageStr);
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
        title: const AppText(
          "PW Partner Perks",
          fontSize: 20.0,
          color: Color(0xff4725a3),
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
            child: const AppText("Cancel", color: Colors.red)),
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
              child: const AppText(
                "Wallboard Image",
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
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
                    image: AssetImage('Assets/wallboard.jpeg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
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
              child: Image.file(
                File(imageStr),
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
                          /// NEW
                          imageMatchAPI(imageStr);

                          /// OLD
                          // submitWallboardImage();
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
