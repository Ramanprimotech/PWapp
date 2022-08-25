import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:convert';
import '../../utils/API_Constant.dart';
import '../../validators/Message.dart';
import '../../Model/profile/ProfileData.dart';
import '../../widgets/utility/Utility.dart';
import 'package:path/path.dart' as path;

typedef VoidWithIntCallback = void Function(int);

TextEditingController _phoneNumber = TextEditingController();

class Profile extends StatefulWidget {
  final VoidWithIntCallback? changeScreen;

  const Profile({Key? key, this.changeScreen}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileData profileData;
  String userName = "";
  String? specialityStr = "";
  String? addressStr = "";
  String? emailStr = "";
  String? phoneStr = "";
  String? pointsStr = "";
  String rewardCardStr = "";
  String scannedNoStr = "";
  late XFile _image;
  String profilePicStr = "";

  getProfileAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID"),
    };
    var response = await http.post(
        Uri.parse(Webservice().apiUrl + Webservice().get_user_profile),
        body: data);

    log(response.body.toString());

    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      profileData = ProfileData.fromJson(json.decode(response.body));

      setState(() {
        userName =
            "${profileData.data!.userProfile![0].firstname} ${profileData.data!.userProfile![0].lastname}";
        specialityStr = profileData.data!.userProfile![0].specialty;
        addressStr = profileData.data!.userProfile![0].address;
        emailStr = profileData.data!.userProfile![0].email;
        phoneStr = profileData.data!.userProfile![0].phone;
        if (phoneStr == "") {
          phoneStr = "xxx-xxxx-xxx";
        }
        pointsStr = profileData.data!.userProfile![0].points;
        if (profileData.data!.userProfile![0].profilePic.toString() != "") {
          profilePicStr = Webservice().imagePath +
              profileData.data!.userProfile![0].profilePic!;
        } else {
          profilePicStr = "${Webservice().imagePath}user_default.png";
        }
        log(profilePicStr);
        rewardCardStr = "${profileData.data!.reward}";
        scannedNoStr = "${profileData.data!.scannedPosters}";
      });
    } else {
      log("Failure API");
    }
  }

  @override
  void initState() {
    getProfileAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    getProfileAPISec() async {
      Utility().onLoading(context, true);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences = await SharedPreferences.getInstance();
      Map data = {
        'user_id': sharedPreferences.getString("userID"),
      };
      log(data.toString());
      var response = await http.post(
          Uri.parse(Webservice().apiUrl + Webservice().get_user_profile),
          body: data);

      Utility().onLoading(context, false);

      if (response.statusCode == 200) {
        profileData = ProfileData.fromJson(json.decode(response.body));
        setState(() {
          userName =
              "${profileData.data!.userProfile![0].firstname} ${profileData.data!.userProfile![0].lastname}";
          specialityStr = profileData.data!.userProfile![0].specialty;
          addressStr = profileData.data!.userProfile![0].address;
          emailStr = profileData.data!.userProfile![0].email;
          phoneStr = profileData.data!.userProfile![0].phone;
          if (phoneStr == "") {
            phoneStr = "xxx-xxxx-xxx";
          }
          pointsStr = profileData.data!.userProfile![0].points;

          if (profileData.data!.userProfile![0].profilePic.toString() != "") {
            profilePicStr = Webservice().imagePath +
                profileData.data!.userProfile![0].profilePic!;
          } else {
            profilePicStr = "${Webservice().imagePath}user_default.png";
          }
          log(profilePicStr);
          rewardCardStr = "${profileData.data!.reward}";
          scannedNoStr = "${profileData.data!.scannedPosters}";
        });
      } else {
        log("Failure API");
        Utility().toast(context, Message().ErrorMsg);
      }
    }

    void _uploadImage() async {
      Utility().onLoading(context, true);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences = await SharedPreferences.getInstance();
      var stream = http.ByteStream(_image.openRead());
      var length = await _image.length();
      var uri =
          Uri.parse(Webservice().apiUrl + Webservice().update_profile_pic);
      var request = http.MultipartRequest("POST", uri);
      var multipartFile = http.MultipartFile('profile_pic', stream, length,
          filename: path.basename(_image.path));
      request.files.add(multipartFile);
      request.fields["user_id"] = sharedPreferences.getString("userID")!;

      var response = await request.send();

      Utility().onLoading(context, false);
      if (response.statusCode == 200) {
        log("Upload Profile pic successfully....");
        getProfileAPISec();
      } else {
        Utility().onLoading(context, false);
        Utility().toast(context, Message().imageuploadErorMgs);
      }

      response.stream.transform(utf8.decoder).listen((value) {});
    }

    Future getImage() async {
      var image = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxHeight: 300, maxWidth: 300);
      setState(() {
        _image = image!;
        _uploadImage();
      });
    }

    Future getGallery() async {
      try {
        var imageFile = await ImagePicker().pickImage(
            source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);
        setState(() {
          _image = imageFile!;
          _uploadImage();
        });
      } catch (e) {
        log(e.toString());
      }
    }

    actionSheetMethod(BuildContext context) {
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
                getImage();
                Navigator.pop(context, 'About Us');
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Open Gallery'),
              onPressed: () {
                getGallery();
                Navigator.pop(context, 'About Us');
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
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

    phoneNumberAPI() async {
      Utility().onLoading(context, true);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      Map data = {
        'user_id': sharedPreferences.getString("userID"),
        'phone': _phoneNumber.text,
      };
      var response = await http.post(
          Uri.parse(Webservice().apiUrl + Webservice().update_profile),
          body: data);

      Utility().onLoading(context, false);
      if (response.statusCode == 200) {
        setState(() {
          _phoneNumber.text = "";
        });
        getProfileAPI();
      } else {
        log("Failure API");
        Utility().toast(context, Message().ErrorMsg);
      }
    }

    validatePhoneNo() {
      if (_phoneNumber.text.isEmpty) {
        Utility().toast(context, Message().phoneNumberMsg);
      } else if (_phoneNumber.text.length != 10) {
        Utility().toast(context, Message().InvalidphoneNumberMsg);
      } else {
        phoneNumberAPI();
      }
    }

    final userDetailCont = Container(
      height: 278.0,
      margin: const EdgeInsets.only(top: 80.0, left: 15.0, right: 15.0),
      padding:
          const EdgeInsets.only(top: 83.0, left: 10.0, right: 10.0, bottom: 15),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Color.fromRGBO(255, 255, 255, 0.15)),
      child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Text(
                userName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w400),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                specialityStr!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w200),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            child: Center(
              child: Text(
                addressStr!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w200),
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            height: 1.0,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 5.0,
          ),
          Row(
            children: <Widget>[
              const Icon(
                Icons.email,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                emailStr!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w200),
              ),
            ],
          ),
          const SizedBox(
            height: 3.0,
          ),
          Row(
            children: <Widget>[
              const Icon(
                Icons.call,
                color: Colors.white,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                phoneStr!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w200),
              ),
              const SizedBox(
                width: 175.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Alert(
                        context: context,
                        title: "Phone Number",
                        content: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextField(
                              controller: _phoneNumber,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  hintText: "Phone Number"),
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            color: const Color(0xffc22ea1),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              validatePhoneNo();
                            },
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'texgyreadventor-regular'),
                            ),
                          )
                        ]).show();
                    setState(() {
                      if (phoneStr != "xxx-xxxx-xxx") {
                        _phoneNumber.text = phoneStr!;
                      }
                    });
                  },
                ),
              )
            ],
          )
        ],
      ),
    );

    final threeBoxCont = Container(
      margin: const EdgeInsets.only(
        top: 15.0,
        left: 15.0,
        right: 15.0,
      ),
      padding:
          const EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0, bottom: 13.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                  width: 100.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff4725a3),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff4725a3),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      pointsStr!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFamily: 'texgyreadventor-regular',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                  "Available Points",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'texgyreadventor-regular',
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                  width: 100.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff4725a3),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff4725a3),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      rewardCardStr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFamily: 'texgyreadventor-regular',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                  "Reward Cards",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'texgyreadventor-regular',
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
                  width: 100.0,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff4725a3),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff4725a3),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      scannedNoStr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontFamily: 'texgyreadventor-regular',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                  "Scanned Posters",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'texgyreadventor-regular',
                      fontWeight: FontWeight.w500),
                ),
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
          body: Container(
              child: Stack(children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/dashboard-bg.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  userDetailCont,
                  const SizedBox(
                    height: 15.0,
                  ),
                  threeBoxCont,
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
            Container(
              height: 130.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('Assets/coverImg.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Stack(fit: StackFit.loose, children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 1.0,
                              spreadRadius: 0.5,
                            )
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (profilePicStr == ""
                                      ? const AssetImage('Assets/as.png')
                                      : NetworkImage(profilePicStr))
                                  as ImageProvider<Object>)),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 90.0, left: 100.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: const CircleAvatar(
                            backgroundColor: Color(0xff4725a3),
                            radius: 20.0,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            log("Camera Pressed!");
                            actionSheetMethod(context);
                          },
                        ),
                      ],
                    )),
              ]),
            )
          ])),
        ));
  }
}
