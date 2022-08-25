import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:pwlp/validators/Message.dart';
import 'package:pwlp/widgets/button/elevated_btn.dart';
import 'package:pwlp/widgets/textField/text_field.dart';
import 'package:pwlp/widgets/utility/alert.dart';
import 'package:pwlp/widgets/utility/assetImage.dart';
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:convert';
import '../../utils/API_Constant.dart';
import '../../Model/auth/ForgotPasswordData.dart';
import '../../Model/auth/UserLoginData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/utility/Utility.dart';

TextEditingController _EmailTF = TextEditingController();
TextEditingController _PasswordTF = TextEditingController();
TextEditingController _forgotPsdController = TextEditingController();
bool _obscureText = true;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    login() async {
      Utility().onLoading(context, true);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      Map data = {
        'email': _EmailTF.text,
        'password': _PasswordTF.text,
        'device_id': "1234568iOSdummyValue123456789",
      };

      var response = await http.post(
          Uri.parse(Webservice().apiUrl + Webservice().login),
          body: data);

      Utility().onLoading(context, false);
      if (response.statusCode == 200) {
        final userLoginData =
            UserLoginData.fromJson(json.decode(response.body));
        sharedPreferences.setString(
            "userID", userLoginData.data!.id.toString());
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
        final loginFailData =
            LoginFailData.fromJson(json.decode(response.body));
        Utility().toast(context, loginFailData.message!);
      }
    }

    forgotPsdAPI() async {
      Utility().onLoading(context, true);
      Map data = {
        'email': _forgotPsdController.text,
      };
      log('data-------------$data');
      var response = await http.post(
          Uri.parse(Webservice().apiUrl + Webservice().forget_password),
          body: data);
      Utility().onLoading(context, false);
      if (response.statusCode == 200) {
        final forgotPasswordData =
            ForgotPasswordData.fromJson(json.decode(response.body));
        _forgotPsdController.text = "";
        dialogAlert(context,
            "Password reset successfully, We have sent your new password on registered email!");
      } else {
        log("Failure API");
        _forgotPsdController.text = "";
        final forgotPasswordErrorData =
            ForgotPasswordErrorData.fromJson(json.decode(response.body));
        Utility().toast(context, forgotPasswordErrorData.message!);
      }
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

    loginValidation() {
      FocusScope.of(context).requestFocus(FocusNode());
      if (_EmailTF.text.isEmpty) {
        Utility().toast(context, Message().Email);
      } else if (_PasswordTF.text.isEmpty) {
        Utility().toast(context, Message().PasswordEmpty);
      } else if (!_EmailTF.text.contains("@") || !_EmailTF.text.contains(".")) {
        Utility().toast(context, Message().EmailValid);
      } else if (_PasswordTF.text.length < 6) {
        Utility().toast(context, Message().PasswordCharacter);
      } else {
        login();
      }
    }

    final welcomeContainerLogin = Column(
      children: <Widget>[
        Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular'),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 15.0,
                ),
                child: Column(
                  children: <Widget>[
                    InputTextField(
                      label: "Email",
                      controller: _EmailTF,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15.0),
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
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          semanticLabel:
                              _obscureText ? 'show password' : 'hide password',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 70.0),
                    SizedBox(
                      height: 55.0,
                      width: 320.0,
                      child: CustomBtn(
                          btnLable: 'Login',
                          onPressed: () {
                            loginValidation();
                          }),
                    ),
                    SizedBox(
                        width: 320,
                        height: 50,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(14.0),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'texgyreadventor-regular'),
                          ),
                          onPressed: () {
                            Alert(
                                context: context,
                                title: "Forgot Password",
                                content: Column(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    TextField(
                                      controller: _forgotPsdController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0))),
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
                                    child: const Text(
                                      "Send",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily:
                                              'texgyreadventor-regular'),
                                    ),
                                  )
                                ]).show();
                          },
                        )),
                    const SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: RichText(
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
                      Navigator.of(context).pushReplacementNamed('/RegisterVC');
                    },
                ),
              ],
            ),
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
                    widgetName: welcomeContainerLogin)),
          ),
        ));
  }
}
