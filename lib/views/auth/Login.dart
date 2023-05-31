import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/utils/extentions/validation_extentions.dart';
import 'package:pwlp/validators/Message.dart';
import 'package:pwlp/widgets/AppText.dart';
import 'package:pwlp/widgets/Widgets.dart';
import 'package:pwlp/widgets/button/elevated_btn.dart';
import 'package:pwlp/widgets/textField/text_field.dart';
import 'package:pwlp/widgets/utility/alert.dart';
import 'package:pwlp/widgets/utility/assetImage.dart';
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../Model/auth/ForgotPasswordData.dart';
import '../../Model/auth/UserLoginData.dart';
import '../../utils/API_Constant.dart';
import '../../widgets/utility/Utility.dart';


bool _obscureText = true;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// Text Editting Controllers
  late TextEditingController _EmailTF;
  late TextEditingController _PasswordTF;
  late TextEditingController _forgotPsdController;

  @override
  void initState() {
    super.initState();
    _EmailTF = TextEditingController();
    _PasswordTF = TextEditingController();
    _forgotPsdController = TextEditingController();
  }

  @override
  void dispose() {
    _EmailTF.dispose();
    _PasswordTF.dispose();
    _forgotPsdController.dispose();
    super.dispose();
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
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            Message().AppBarTitle,
            style: const TextStyle(
                fontSize: 20.0, fontFamily: 'texgyreadventor-regular'),
          ),
          backgroundColor: const Color(0xff4725a3),
        ),
        body: BGImageWithChild(
          imgUrl: "loginBg.png",
          child: SizedBox(height: double.infinity, child: loginView()),
        ),
      ),
    );
  }

  Widget loginView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppText(
              "Welcome",
              fontSize: 35,
              padding: EdgeInsets.only(top: 45, bottom: 55),
            ),
            InputTextField(
              label: "Email",
              controller: _EmailTF,
              inputFormatters: emailFormatter,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            InputTextField(
              controller: _PasswordTF,
              label: 'Password',
              obscureText: _obscureText,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  semanticLabel:
                      _obscureText ? 'show password' : 'hide password',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomBtn(
                btnLable: 'Login',
                onPressed: () {
                  loginValidation();
                }),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(14.0),
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const AppText(
                "Forgot Password?",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              onPressed: () {
                ForgotPassword();
              },
            ),
            const SizedBox(height: 30),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "Not joined yet? ",
                style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w300),
                children: [
                  TextSpan(
                    text: "Sign Up",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontFamily: 'texgyreadventor-regular',
                      fontWeight: FontWeight.w400,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context)
                            .pushReplacementNamed('/RegisterVC');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  static List<TextInputFormatter> checkEmail = [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{1,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{1,25})+')),];

  loginValidation() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_EmailTF.text.isEmpty) {
      Utility().toast(context, Message().Email);
    } else if (_PasswordTF.text.isEmpty) {
      Utility().toast(context, Message().PasswordEmpty);
    } else if (!isValidEmail(_EmailTF.text.trim())) {
    // } else if (!_EmailTF.text.contains("@") || !_EmailTF.text.contains(".")) {
      Utility().toast(context, Message().EmailValid);
    } else if (_PasswordTF.text.length < 6) {
      Utility().toast(context, Message().PasswordCharacter);
    } else {
      login();
    }
  }

  login() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Map data = {
      'email': _EmailTF.text,
      'password': _PasswordTF.text,
      'device_id': "1234568iOSdummyValue123456789",
    };

    var response =
        await http.post(Uri.parse(Api.baseUrl + Api().login), body: data);

    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      final userLoginData = UserLoginData.fromJson(json.decode(response.body));
      sharedPreferences.setString("userID", userLoginData.data!.id.toString());
      sharedPreferences.setString(
          "points", userLoginData.data!.points.toString());
      sharedPreferences.setString(
          "specialty", userLoginData.data!.specialty.toString());
      sharedPreferences.setString(
          "email", userLoginData.data!.email.toString());
      sharedPreferences.setString(
          "firstname", userLoginData.data!.firstname.toString());
      sharedPreferences.setString(
          "lastname", userLoginData.data!.lastname.toString());
      sharedPreferences.setString(
          "is_first", userLoginData.data!.isFirst.toString());
      sharedPreferences.setString("accountIdentifier",
          userLoginData.data!.adminSetting!.accountIdentifier.toString());
      sharedPreferences.setString("platform_name",
          userLoginData.data!.adminSetting!.platformName.toString());
      sharedPreferences.setString("platform_key",
          userLoginData.data!.adminSetting!.platformKey.toString());
      sharedPreferences.setString("account_number",
          userLoginData.data!.adminSetting!.accountNumber.toString());
      sharedPreferences.setString("customer_identifier",
          userLoginData.data!.adminSetting!.customerIdentifier.toString());
      sharedPreferences.setString("sender_email",
          userLoginData.data!.adminSetting!.senderEmail.toString());
      sharedPreferences.setString("sender_firstname",
          userLoginData.data!.adminSetting!.senderFirstname.toString());
      sharedPreferences.setString("sender_lastname",
          userLoginData.data!.adminSetting!.senderLastname.toString());
      sharedPreferences.setString(
          "etid", userLoginData.data!.adminSetting!.etid.toString());
      setState(() {
        _EmailTF.text = "";
        _PasswordTF.text = "";
      });
      Navigator.of(context).pushReplacementNamed('/Dashboard');
    } else {
      log("Failure API");
      final loginFailData = LoginFailData.fromJson(json.decode(response.body));
      Utility().toast(context, loginFailData.message!);
    }
  }

  Future<bool?> ForgotPassword() {
    return Alert(
      context: context,
      title: "Forgot Password",
      content: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          TextField(
            controller: _forgotPsdController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              hintText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      buttons: [
        DialogButton(

          color: const Color(0xffc22ea1),
          onPressed: () {
            validationForgotPsd();
          },
          child: const AppText("Send", fontSize: 20),
        ),
      ]).show();
  }

  void validationForgotPsd() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_forgotPsdController == "") {
      Utility().toast(context, Message().Email);
    } else if (!_forgotPsdController.text.contains("@") ||
        !_forgotPsdController.text.contains(".")) {
      Utility().toast(context, Message().EmailValid);
    } else {
      Navigator.pop(context);
      forgotPsdAPI();
    }
  }

  forgotPsdAPI() async {
    Utility().onLoading(context, true);
    Map data = {
      'email': _forgotPsdController.text,
    };
    log('data-------------$data');
    var response = await http
        .post(Uri.parse(Api.baseUrl + Api().forget_password), body: data);
    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      final forgotPasswordData =
          ForgotPasswordData.fromJson(json.decode(response.body));
      _forgotPsdController.text = "";
      dialogAlert(context,
          "Your password has been reset successfully. We have emailed your new password. Please check your inbox.");
    } else {
      log("Failure API");
      _forgotPsdController.text = "";
      final forgotPasswordErrorData =
          ForgotPasswordErrorData.fromJson(json.decode(response.body));
      Utility().toast(context, forgotPasswordErrorData.message!);
    }
  }
}
