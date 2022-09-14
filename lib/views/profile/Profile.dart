// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../Model/profile/ProfileData.dart';
import '../../utils/API_Constant.dart';
import '../../validators/Message.dart';
import '../../widgets/utility/Utility.dart';

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
  String? specialityStr;
  String? addressStr;
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
    var response = await http.post(Uri.parse(Webservice().apiUrl + Webservice().get_user_profile), body: data);
    if (response.statusCode == 200) {
      profileData = ProfileData.fromJson(json.decode(response.body));
      setState(() {
        userName = "${profileData.data!.userProfile![0].firstname} ${profileData.data!.userProfile![0].lastname}";
        specialityStr = profileData.data!.userProfile![0].specialty;
        addressStr = profileData.data!.userProfile![0].address;
        emailStr = profileData.data!.userProfile![0].email;
        phoneStr = profileData.data!.userProfile![0].phone;
        if (phoneStr == "") {
          phoneStr = "xxx-xxxx-xxx";
        }
        pointsStr = profileData.data!.userProfile![0].points;
        if (profileData.data!.userProfile![0].profilePic.toString() != "") {
          profilePicStr = Webservice().imagePath + profileData.data!.userProfile![0].profilePic!;
        } else {
          profilePicStr = "${Webservice().imagePath}user_default.png";
        }
        rewardCardStr = "${profileData.data!.reward}";
        scannedNoStr = "${profileData.data!.scannedPosters}";
      });
    } else {
      log("Failure API");
    }
  }

  getProfileAPISec() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID"),
    };
    log(data.toString());
    var response = await http.post(Uri.parse(Webservice().apiUrl + Webservice().get_user_profile), body: data);

    Utility().onLoading(context, false);

    if (response.statusCode == 200) {
      profileData = ProfileData.fromJson(json.decode(response.body));
      setState(() {
        userName = "${profileData.data!.userProfile![0].firstname} ${profileData.data!.userProfile![0].lastname}";
        specialityStr = profileData.data!.userProfile![0].specialty;
        addressStr = profileData.data!.userProfile![0].address;
        emailStr = profileData.data!.userProfile![0].email;
        phoneStr = profileData.data!.userProfile![0].phone;
        if (phoneStr == "") {
          phoneStr = "xxx-xxxx-xxx";
        }
        pointsStr = profileData.data!.userProfile![0].points;

        if (profileData.data!.userProfile![0].profilePic.toString() != "") {
          profilePicStr = Webservice().imagePath + profileData.data!.userProfile![0].profilePic!;
        } else {
          profilePicStr = "${Webservice().imagePath}user_default.png";
        }
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    var stream = http.ByteStream(_image.openRead());
    var length = await _image.length();
    var uri = Uri.parse(Webservice().apiUrl + Webservice().update_profile_pic);
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('profile_pic', stream, length, filename: path.basename(_image.path));
    request.files.add(multipartFile);
    request.fields["user_id"] = sharedPreferences.getString("userID")!;

    var response = await request.send();

    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      Utility().toast(context, Message().profilePictureUpdate);
      getProfileAPISec();
    } else {
      Utility().onLoading(context, false);
      Utility().toast(context, Message().imageuploadErorMgs);
    }

    response.stream.transform(utf8.decoder).listen((value) {});
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source, maxHeight: 300, maxWidth: 300);
      if (image == null) {
        return;
      } else {
        final imageTemp = XFile(image.path);
        setState(() {
          _image = imageTemp;
          _uploadImage();
        });
      }
    } on PlatformException catch (e) {
      log('Failed to pick image : $e');
    }
  }

  actionSheetMethod(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          'PW Partner Perks',
          style: TextStyle(fontSize: 20.0, color: Color(0xff4725a3), fontFamily: 'texgyreadventor-regular'),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text("Open Camera"),
            onPressed: () {
              getImage(ImageSource.camera);
              Navigator.pop(context, 'About Us');
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Open Gallery'),
            onPressed: () {
              getImage(ImageSource.gallery);
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
            style: TextStyle(fontFamily: 'texgyreadventor-regular', color: Colors.red),
          ),
        ),
      ),
    );
  }

  phoneNumberAPI() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map data = {
      'user_id': sharedPreferences.getString("userID"),
      'phone': _phoneNumber.text,
    };
    var response = await http.post(Uri.parse(Webservice().apiUrl + Webservice().update_profile), body: data);

    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      setState(() {
        _phoneNumber.text = "";
      });
      Utility().toast(context, "Phone number updated");

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
    } else if (_phoneNumber.text == phoneStr!) {
      Utility().toast(context, Message().phoneNumberExists);
    } else {
      Utility().toast(context, Message().phoneNumberUpdate);
      phoneNumberAPI();
    }
  }

  showPhoneDialog() {
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
              style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'texgyreadventor-regular'),
            ),
          )
        ]).show();
    setState(() {
      if (phoneStr != "xxx-xxxx-xxx") {
        _phoneNumber.text = phoneStr!;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getProfileAPI();
    ToastContext().init(context);
  }

  @override
  Widget build(BuildContext context) {
    final userDetailCont = Container(
      margin: const EdgeInsets.only(top: 80.0, left: 15.0, right: 15.0),
      padding: const EdgeInsets.only(top: 83.0, left: 10.0, right: 10.0, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: const Color(0x1AFFFFFF),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'texgyreadventor-regular',
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (specialityStr != null) ...[
            Text(
              specialityStr ?? "Speciality",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontFamily: 'texgyreadventor-regular',
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
          ],
          if (addressStr != null)
            Text(
              addressStr ?? "Address",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'texgyreadventor-regular',
                fontWeight: FontWeight.w200,
              ),
              maxLines: 3,
            ),
          const SizedBox(height: 8),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            dense: true,
            leading: const Icon(
              Icons.email,
              color: Colors.white,
            ),
            title: Text(
              emailStr!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'texgyreadventor-regular',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(
              Icons.call,
              color: Colors.white,
            ),
            title: Text(
              phoneStr!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'texgyreadventor-regular',
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: IconButton(
              onPressed: showPhoneDialog,
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
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
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/dashboard-bg.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      userDetailCont,
                      const SizedBox(
                        height: 15.0,
                      ),
                      PointsCard(pointsStr: pointsStr, rewardCardStr: rewardCardStr, scannedNoStr: scannedNoStr),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
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
                    child: Stack(
                      fit: StackFit.loose,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                                  ),
                                ],
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: (profilePicStr == ""
                                      ? const AssetImage('Assets/as.png')
                                      : NetworkImage(profilePicStr)) as ImageProvider<Object>,
                                ),
                              ),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PointsCard extends StatelessWidget {
  const PointsCard({
    Key? key,
    required this.pointsStr,
    required this.rewardCardStr,
    required this.scannedNoStr,
  }) : super(key: key);

  final String? pointsStr;
  final String rewardCardStr;
  final String scannedNoStr;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          PointCircle(
            label: "Available Points",
            value: pointsStr!,
          ),
          PointCircle(
            label: "Reward Cards",
            value: rewardCardStr,
          ),
          PointCircle(
            label: "Scanned Posters",
            value: scannedNoStr,
          ),
        ],
      ),
    );
  }
}

class PointCircle extends StatelessWidget {
  const PointCircle({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 100.0,
              height: 100.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xff4725a3),
              ),
              alignment: Alignment.center,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontFamily: 'texgyreadventor-regular',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontFamily: 'texgyreadventor-regular',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
