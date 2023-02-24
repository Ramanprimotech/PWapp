import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/utils/API_Constant.dart';
import 'package:pwlp/validators/Message.dart';
import 'package:pwlp/widgets/AppText.dart';
import 'package:pwlp/widgets/button/elevated_btn.dart';
import 'package:pwlp/widgets/textField/text_field.dart';
import 'package:pwlp/widgets/utility/already_account.dart';
import 'package:pwlp/widgets/utility/assetImage.dart';
import 'package:pwlp/widgets/utility/connectivity_result_message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/auth/UserRegisterData.dart';
import '../../Model/search/SpecialityData.dart';
import '../../widgets/utility/Utility.dart';

TextEditingController _FnameTF = TextEditingController();
TextEditingController _LnameTF = TextEditingController();
TextEditingController _EmailTF = TextEditingController();
TextEditingController _PhoneTF = TextEditingController();
TextEditingController _PasswordTF = TextEditingController();
TextEditingController _ConfirmPasswordTF = TextEditingController();
TextEditingController _LocationTF = TextEditingController();
TextEditingController _SpecialityTF = TextEditingController();
TextEditingController _addressOptTF = TextEditingController();

String address_id = "";
String addressStr = "";
String attnStr = "";

class RegisterVC extends StatefulWidget {
  const RegisterVC({Key? key}) : super(key: key);

  void updateUI(String selectStr, String address_ID, String attnStr) {
    address_id = address_ID;
    _LocationTF.text = selectStr;
    _addressOptTF.text = attnStr;
    addressStr = selectStr;
  }

  @override
  _RegisterVCState createState() => _RegisterVCState();
}

class _RegisterVCState extends State<RegisterVC> {
  bool checkBoxVal = false;
  bool _isVisible = false;
  int page = 0;
  final PageController _myPageView = PageController(initialPage: 0);
  SpecialityData? specialityData;

  specialityAPI() async {
    String url = "${Api.baseUrl}" "${Api().get_speciality}";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      specialityData = SpecialityData.fromJson(json.decode(response.body));
      setState(() {});
    } else {
      throw Exception('Failed to load post');
    }
  }

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  _launchURLTnC() async {
    const url = 'https://www.physiciansweekly.com/terms-of-use/';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  _launchURLPnP() async {
    const url = 'https://www.physiciansweekly.com/privacy-policy/';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  void initState() {
    _myPageView.addListener(() {
      var newPage = _myPageView.page!.floor();
      if (page != newPage) {
        page = newPage;
        setState(() {});
      }
    });
    specialityAPI();
    super.initState();
  }

  @override
  void dispose() {
    _myPageView.dispose();
    super.dispose();
  }

  toast(String message) {
    Toast.show(message,
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: const Color(0xffc22ea1));
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
          leading: Visibility(
            visible: page > 0,
            child: BackButton(
              onPressed: () {
                _myPageView.animateToPage(page - 1,
                    duration: const Duration(microseconds: 10),
                    curve: Curves.linear);
              },
            ),
          ),
          title: Text(
            Message().AppBarTitle,
            style: const TextStyle(
                fontSize: 20.0, fontFamily: 'texgyreadventor-regular'),
          ),
          backgroundColor: const Color(0xff4725a3),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _myPageView,
          children: <Widget>[
            registerView1(),
            registerView2(),
            registerView3(),
            registerView4(),
          ],
        ),
      ),
    );
  }

  Widget registerView1() {
    return BGImageWithChild(
      imgUrl: "Rbg1.png",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                const AppText(
                  "Welcome",
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  padding: EdgeInsets.only(top: 40, bottom: 24),
                ),
                const AppText(
                  "Select Your Specialty Edition",
                  fontSize: 18,
                  padding: EdgeInsets.only(top: 40, bottom: 24),
                ),
                InputTextField(
                  readOnly: true,
                  label: 'Select Specialty',
                  controller: _SpecialityTF,
                  suffixIcon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      _isVisible = !_isVisible;
                      _LocationTF.text = "";
                      _addressOptTF.text = "";
                    });
                  },
                ),
                Visibility(
                  visible: _isVisible,
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 200.0,
                      width: 320.0,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Color.fromRGBO(255, 255, 255, 0.12)),
                      child: specialityData != null
                          ? ListView.builder(
                              itemCount: specialityData!.data!.length,
                              itemBuilder: (context, index) => Container(
                                color: _selectedIndex == index
                                    ? Colors.transparent
                                    : const Color.fromRGBO(255, 255, 255, 0.12),
                                child: ListTile(
                                  title: Text(
                                    '${specialityData!.data![index].name}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontFamily: 'texgyreadventor-regular'),
                                  ),
                                  onTap: () async {
                                    _onSelected(index);
                                    _isVisible = !_isVisible;
                                    _SpecialityTF.text =
                                        '${specialityData!.data![index].name}';
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    sharedPreferences.setString(
                                        "SelctedSpeciality",
                                        specialityData!.data![index].name!);
                                  },
                                ),
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )),
                ),
                const SizedBox(height: 20),
                CustomBtn(
                    btnLable: "Next",
                    onPressed: () {
                      checkSpecialityVal();
                    }),
                AlreadyAcc(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushReplacementNamed('/Login');
                    },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerView2() {
    return BGImageWithChild(
      imgUrl: "Rbg2.png",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: double.infinity,
          child: ListView(
            children: <Widget>[
              const AppText(
                "Registration",
                fontSize: 35,
                fontWeight: FontWeight.w600,
                padding: EdgeInsets.only(top: 40, bottom: 24),
              ),
              const AppText(
                "Select Your Location",
                fontSize: 20,
                padding: EdgeInsets.only(bottom: 10),
              ),
              Container(
                margin: const EdgeInsets.only(top: 35, bottom: 45),
                padding: const EdgeInsets.only(left: 5),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color.fromRGBO(255, 255, 255, 0.12)),
                child: TextField(
                  readOnly: true,
                  minLines: 1,
                  maxLines: 3,
                  controller: _LocationTF,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'texgyreadventor-regular'),
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: 'Select...',
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: 'texgyreadventor-regular')),
                  onTap: () {
                    Navigator.of(context).pushNamed('/LocationSearch');
                  },
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    color: Color.fromRGBO(255, 255, 255, 0.12),
                  ),
                  child: Column(
                    children: <Widget>[
                      const AppText(
                        "Please describe where your poster is located. (e.g. Staff Office, Staff Breakroom, or other)",
                        fontSize: 13,
                        maxLines: 4,
                        padding: EdgeInsets.only(bottom: 18),
                      ),
                      Container(
                        height: 44.0,
                        padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Color.fromRGBO(255, 255, 255, 1.0)),
                        child: TextField(
                          controller: _addressOptTF,
                          cursorColor: Colors.blueAccent,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'texgyreadventor-regular'),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              suffixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              hintText: 'Optional',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'texgyreadventor-regular')),
                        ),
                      ),
                    ],
                  )),
              CustomBtn(
                  btnLable: "Next",
                  onPressed: () {
                    checkLocVal();
                  }),
              AlreadyAcc(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushReplacementNamed('/Login');
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerView3() {
    return BGImageWithChild(
      imgUrl: "Rbg3.png",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          height: double.infinity,
          child: ListView(
            children: <Widget>[
              const AppText(
                "Registration",
                fontSize: 35,
                padding: EdgeInsets.only(top: 40, bottom: 50),
              ),
              InputTextField(
                textCapitalization: TextCapitalization.words,
                margin: const EdgeInsets.only(bottom: 15.0),
                controller: _FnameTF,
                label: 'First Name',
              ),
              InputTextField(
                textCapitalization: TextCapitalization.words,
                controller: _LnameTF,
                label: 'Last Name',
                margin: const EdgeInsets.only(bottom: 15.0),
              ),
              InputTextField(
                controller: _EmailTF,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                margin: const EdgeInsets.only(bottom: 15.0),
              ),
              InputTextField(
                margin: const EdgeInsets.only(bottom: 30),
                controller: _PhoneTF,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                label: 'Phone (Optional)',
                keyboardType: TextInputType.phone,
              ),
              CustomBtn(
                  btnLable: "Next",
                  onPressed: () {
                    checkUserDetail();
                  }),
              AlreadyAcc(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushReplacementNamed('/Login');
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerView4() {
    return BGImageWithChild(
      imgUrl: "Rbg4.png",
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: double.infinity,
          child: ListView(
            children: <Widget>[
              const AppText(
                "Registration",
                fontSize: 35,
                padding: EdgeInsets.only(top: 35, bottom: 24),
              ),
              const AppText(
                "Create your Password",
                fontSize: 20,
                padding: EdgeInsets.only(bottom: 30),
              ),
              InputTextField(
                controller: _PasswordTF,
                label: 'Password',
                obscureText: true,
                margin: const EdgeInsets.only(top: 15, bottom: 14),
              ),
              InputTextField(
                controller: _ConfirmPasswordTF,
                label: 'Confirm Password',
                obscureText: true,
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(bottom: 50),
                  horizontalTitleGap: 4,
                leading: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(
                        checkBoxVal == false
                            ? Icons.check_box_outline_blank
                            : Icons.check_box,
                        color: Colors.white),
                  ),
                  onTap: () {
                    if (checkBoxVal == false) {
                      setState(() {
                        checkBoxVal = true;
                      });
                    } else {
                      setState(() {
                        checkBoxVal = false;
                      });
                    }
                  },
                ),
                title: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                          child: AppText(
                        "I have read the ",
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      )),
                      TextSpan(
                        text: "Privacy Policy",
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontFamily: 'texgyreadventor-regular',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURLPnP();
                          },
                      ),
                      const WidgetSpan(
                          child: AppText(
                        " and",
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                      ))
                    ],
                  ),
                ),
                subtitle: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                          child: AppText(
                        "agree to the ",
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0,
                      )),
                      TextSpan(
                        text: "Terms & Conditions.",
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontFamily: 'texgyreadventor-regular',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURLTnC();
                          },
                      ),
                    ],
                  ),
                ),
              ),
              CustomBtn(
                  btnLable: 'Submit',
                  onPressed: () {
                    validationRegister();
                  }),
              AlreadyAcc(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushReplacementNamed('/Login');
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validationRegister() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_SpecialityTF.text == "" &&
        addressStr == "" &&
        _FnameTF.text == "" &&
        _LnameTF.text == "" &&
        _EmailTF.text == "" &&
        _PasswordTF.text == "") {
      toast(Message().FieldRequired);
    } else if (_SpecialityTF.text == "") {
      toast(Message().Speciality);
    } else if (addressStr == "") {
      toast(Message().Location);
    } else if (_FnameTF.text == "") {
      toast(Message().Fname);
    } else if (_FnameTF.text.length < 2 && _FnameTF.text.length > 26) {
      toast(Message().FnameCharacterValid);
    } else if (_LnameTF.text == "") {
      toast(Message().Lname);
    } else if (_LnameTF.text.length < 2 && _LnameTF.text.length > 26) {
      toast(Message().FnameCharacterValid);
    } else if (_EmailTF.text == "") {
      toast(Message().Email);
    } else if (!_EmailTF.text.contains("@") || !_EmailTF.text.contains(".")) {
      toast(Message().EmailValid);
    } else if (_PhoneTF.text.isNotEmpty && _PhoneTF.text.length != 10) {
      toast(Message().InvalidphoneNumberMsg);
    } else if (_PasswordTF.text == "") {
      toast(Message().Password);
    } else if (_PasswordTF.text.length < 6) {
      toast(Message().PasswordCharacter);
    } else if (_PasswordTF.text.length != _ConfirmPasswordTF.text.length) {
      toast(Message().PasswordMismatch);
    } else if (checkBoxVal == false) {
      toast(Message().tNcMsg);
    } else {
      register();
    }
  }

  register() async {
    Utility().onLoading(context, true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String phoneStr = "";
    if (_PhoneTF.text.isNotEmpty) {
      phoneStr = _PhoneTF.text;
    }
    Map data = {
      'firstname': _FnameTF.text,
      'lastname': _LnameTF.text,
      'email': _EmailTF.text,
      'password': _PasswordTF.text,
      'c_password': _ConfirmPasswordTF.text,
      'address': addressStr,
      'address_id': address_id,
      'specialty': _SpecialityTF.text,
      // 'device_id': '1234568iOSdummyValue',
      'device_id': '1234568iOSdummyValuey65675',
      'phone': phoneStr,
      'profile_pic': ""
    };
    log('data---register----------$data');
    var response = await http
        .post(Uri.parse("${Api.baseUrl}" "${Api().userRegister}"), body: data);
    Utility().onLoading(context, false);
    if (response.statusCode == 200) {
      final userRegisterData =
          UserRegisterData.fromJson(json.decode(response.body));
      log('Response final------------- ${userRegisterData.data!.firstname}');
      sharedPreferences.setString(
          "userID", userRegisterData.data!.id.toString());
      sharedPreferences.setString(
          "points", userRegisterData.data!.points.toString());
      sharedPreferences.setString(
          "specialty", userRegisterData.data!.specialty.toString());
      sharedPreferences.setString(
          "email", userRegisterData.data!.email.toString());
      sharedPreferences.setString(
          "firstname", userRegisterData.data!.firstname.toString());
      sharedPreferences.setString(
          "lastname", userRegisterData.data!.lastname.toString());
      sharedPreferences.setString("accountIdentifier",
          userRegisterData.data!.adminSetting!.accountIdentifier.toString());
      sharedPreferences.setString("platform_name",
          userRegisterData.data!.adminSetting!.platformName.toString());
      sharedPreferences.setString("platform_key",
          userRegisterData.data!.adminSetting!.platformKey.toString());
      sharedPreferences.setString("account_number",
          userRegisterData.data!.adminSetting!.accountNumber.toString());
      sharedPreferences.setString("customer_identifier",
          userRegisterData.data!.adminSetting!.customerIdentifier.toString());
      sharedPreferences.setString("sender_email",
          userRegisterData.data!.adminSetting!.senderEmail.toString());
      sharedPreferences.setString("sender_firstname",
          userRegisterData.data!.adminSetting!.senderFirstname.toString());
      sharedPreferences.setString("sender_lastname",
          userRegisterData.data!.adminSetting!.senderLastname.toString());
      sharedPreferences.setString(
          "etid", userRegisterData.data!.adminSetting!.etid.toString());
      sharedPreferences.setString("is_first", "0");
      clearTextField();
      Navigator.of(context).pushReplacementNamed('/congratulationVC');
    } else if (response.statusCode == 404) {
      toast(json.decode(response.body)['message'].toString());
      log(response.body, name: "register");
    } else {
      final registerErrorData =
          RegisterErrorData.fromJson(json.decode(response.body));
    }
  }

  clearTextField() {
    _SpecialityTF.text = "";
    _LocationTF.text = "";
    _addressOptTF.text = "";
    _FnameTF.text = "";
    _LnameTF.text = "";
    _EmailTF.text = "";
    _PhoneTF.text = "";
    _PasswordTF.text = "";
    _ConfirmPasswordTF.text = "";
  }

  void checkUserDetail() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_FnameTF.text == "") {
      toast(Message().Fname);
    } else if (_FnameTF.text.length < 2 && _FnameTF.text.length > 26) {
      toast(Message().FnameCharacterValid);
    } else if (_LnameTF.text == "") {
      toast(Message().Lname);
    } else if (_LnameTF.text.length < 2 && _LnameTF.text.length > 26) {
      toast(Message().FnameCharacterValid);
    } else if (_EmailTF.text == "") {
      toast(Message().Email);
    } else if (!_EmailTF.text.contains("@") || !_EmailTF.text.contains(".")) {
      toast(Message().EmailValid);
    } else if (_PhoneTF.text.isNotEmpty && _PhoneTF.text.length != 10) {
      toast(Message().InvalidphoneNumberMsg);
    } else {
      _myPageView.jumpToPage(3);
    }
  }

  void checkSpecialityVal() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_SpecialityTF.text == "") {
      toast(Message().Speciality);
    } else {
      _myPageView.jumpToPage(1);
    }
  }

  void checkLocVal() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (addressStr == "") {
      toast(Message().Location);
    } else {
      _myPageView.jumpToPage(2);
    }
  }
}
