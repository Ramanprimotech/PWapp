import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/Model/contactUs/ContactUsFailedResponse.dart';
import 'package:pwlp/validators/Message.dart';
import 'package:pwlp/widgets/button/elevated_btn.dart';
import 'package:pwlp/widgets/textField/text_field.dart';
import 'package:pwlp/widgets/utility/assetImage.dart';
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
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

  /// API------> Contact Us
  Future<void> contactUsAPI() async {
    Utility().onLoading(context, true);

    Map data = {
      'name': _EmailTF.text,
      'email': _NameTF.text,
      'phone': _ContactTF.text,
      'message': _MessageTF.text,
      'device_id': "1234568iOSdummyValue123456789",
    };

    var response = await http.post(
        Uri.parse(Webservice().apiUrl + Webservice().contact_us),
        body: data);

    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      var result = json.decode(response.body);

      log(result.toString(), name: "Response");
      if (result['success'] == true) {
        log(result['success'].toString(), name: "Response sccuc");
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
    } else if (_ContactTF.text.isEmpty || _ContactTF.text.length != 10) {
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

    final contactUsContainer = Column(
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Contact Us',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular'),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.only(
                  top: 15.0,
                ),
                child: Column(
                  children: <Widget>[
                    InputTextField(
                      controller: _NameTF,
                      label: 'Full Name',
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    InputTextField(
                      controller: _EmailTF,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    InputTextField(
                      controller: _ContactTF,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      label: 'Phone',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    InputTextField(
                      height: null,
                      controller: _MessageTF,
                      maxLines: 5,
                      maxLength: 1000,
                      minLines: 5,
                      label: 'Message',
                    ),
                    const SizedBox(height: 70.0),
                    SizedBox(
                      height: 55.0,
                      width: 320.0,
                      child: CustomBtn(
                          btnLable: 'Submit',
                          onPressed: () {
                            _contactValidation();
                          }),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                Message().AppBarTitle,
                style: const TextStyle(
                    fontSize: 20.0, fontFamily: 'texgyreadventor-regular'),
              ),
              backgroundColor: const Color(0xff4725a3),
            ),
            body: Center(
                child: AssetImages(
                    imageFromAsset: const AssetImage('Assets/loginBg.png'),
                    widgetName: contactUsContainer)),
          ),
        ));
  }
}
