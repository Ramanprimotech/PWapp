import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/Model/contactUs/ContactUsFailedResponse.dart';
import 'package:pwlp/Model/profile/ProfileData.dart';
import 'package:pwlp/validators/Message.dart';
import 'package:pwlp/validators/input_helper.dart';
import 'package:pwlp/widgets/AppText.dart';
import 'package:pwlp/widgets/button/elevated_btn.dart';
import 'package:pwlp/widgets/textField/text_field.dart';
import 'package:pwlp/widgets/utility/assetImage.dart';
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../Model/contactUs/ContactUsResponse.dart';
import '../../utils/API_Constant.dart';
import '../../widgets/utility/Utility.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  late final TextEditingController _EmailTF;
  late final TextEditingController _NameTF;
  late final TextEditingController _ContactTF;
  late final TextEditingController _MessageTF;

  @override
  void initState() {
    _EmailTF = TextEditingController();
    _NameTF = TextEditingController();
    _ContactTF = TextEditingController();
    _MessageTF = TextEditingController();
    getProfileAPI();
    super.initState();
  }

  @override
  void dispose() {
    _EmailTF.dispose();
    _NameTF.dispose();
    _ContactTF.dispose();
    _MessageTF.dispose();
    super.dispose();
  }

  getProfileAPI() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': sharedPreferences.getString("userID"),
    };
    var response = await http
        .post(Uri.parse(Api.baseUrl + Api().get_user_profile), body: data);
    if (response.statusCode == 200) {
      ProfileData profileData =
          ProfileData.fromJson(json.decode(response.body));
      setState(() {
        _NameTF.text =
            "${profileData.data!.userProfile![0].firstname} ${profileData.data!.userProfile![0].lastname}";
        _EmailTF.text = profileData.data!.userProfile![0].email ?? "";
        String phone = profileData.data!.userProfile![0].phone ?? "";
        _ContactTF.text = InputHelper.phoneToFormat(phone);
      });
    } else {
      log("Failure API");
    }
  }

  /// API------> Contact Us
  Future<void> contactUsAPI() async {
    Utility().onLoading(context, true);
    String phone = InputHelper.phoneRegular(_ContactTF.text);
    Map data = {
      'name': _EmailTF.text,
      'email': _NameTF.text,
      'phone': phone,
      'message': _MessageTF.text,
      'device_id': "1234568iOSdummyValue123456789",
    };
    var response =
        await http.post(Uri.parse(Api.baseUrl + Api().contact_us), body: data);

    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      if (result['success'] == true) {
        final contactUsResponse =
            ContactUsResponse.fromJson(json.decode(response.body));
        Utility().toast(context, contactUsResponse.message!);
      } else {
        final contactUsFailedResponse =
            ContactUsFailedResponse.fromJson(json.decode(response.body));
        Utility().toast(context, contactUsFailedResponse.message!);
      }
      Navigator.of(context).pop();
    } else {
      log("Failure API");

      Utility().toast(context, "Something went wrong");
    }
  }

  toast(String message) {
    Toast.show(message,
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: const Color(0xffc22ea1));
  }

  void _contactValidation() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_NameTF.text == "") {
      toast("Please enter your name");
    } else if (_NameTF.text.length < 2) {
      toast(Message().FnameCharacterValid);
    } else if (_EmailTF.text == "") {
      toast(Message().Email);
    } else if (!_EmailTF.text.contains("@") || !_EmailTF.text.contains(".")) {
      toast(Message().EmailValid);
    } else if (_ContactTF.text.isEmpty || _ContactTF.text.length != 14) {
      toast(Message().InvalidphoneNumberMsg);
    } else if (_MessageTF.text.isEmpty) {
      toast(Message().MessageEmpty);
    } else {
      contactUsAPI();
      log("contact Sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new)),
            centerTitle: true,
            title: Text(
              Message().AppBarTitle,
              style: const TextStyle(
                  fontSize: 20.0, fontFamily: 'texgyreadventor-regular'),
            ),
            backgroundColor: const Color(0xff4725a3),
          ),
          body: BGImageWithChild(
            imgUrl: "loginBg.png",
            child: SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      const AppText(
                        "Contact Us",
                        fontSize: 35,
                        padding: EdgeInsets.only(top: 40, bottom: 50),
                      ),
                      InputTextField(
                        controller: _NameTF,
                        label: 'Full Name',
                        margin: const EdgeInsets.only(bottom: 16),
                      ),
                      InputTextField(
                        controller: _EmailTF,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        margin: const EdgeInsets.only(bottom: 16),
                      ),
                      InputTextField(
                        controller: _ContactTF,
                        label: 'Phone',
                        maxLength: 14,
                        inputFormatters: InputHelper.phoneFormatter,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          _MessageTF.text = InputHelper.phoneRegular(value);
                        },
                        margin: const EdgeInsets.only(bottom: 16),
                      ),
                      InputTextField(
                        height: null,
                        controller: _MessageTF,
                        maxLines: 5,
                        maxLength: 1000,
                        minLines: 5,
                        label: 'Message',
                        margin: const EdgeInsets.only(bottom: 50),
                      ),
                      CustomBtn(
                          btnLable: 'Submit',
                          onPressed: () {
                            _contactValidation();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
