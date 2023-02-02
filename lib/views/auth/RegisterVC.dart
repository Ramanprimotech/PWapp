import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/utils/API_Constant.dart';
import 'package:pwlp/validators/Message.dart';
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

PageController _myPageView = PageController();
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
  void updateUI(String selectStr, String address_ID, String attnStr) {
    print(address_ID);
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

  SpecialityData? specialityData;

  specialityAPI() async {
    String url = "${Webservice().apiUrl}" + "${Webservice().get_speciality}";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print("API SUCCESS.......");
      specialityData = SpecialityData.fromJson(json.decode(response.body));
    } else {
      print("API FAIL.......");
      throw Exception('Failed to load post');
    }
  }

  final List<String> _listViewData = [
    "Allergy",
    "Cardiology",
    "Critical Care",
    "Dermatology",
    "Diabetes",
    "Emergency",
    "Gastroenterology",
    "Infectious Disease",
    "Neurology",
    "Nephrology",
    "OBGYN",
    "Oncology",
    "Ophthalmology",
    "Pain",
    "Pediatrics",
    "Primary Care",
    "Pulmonology",
    "Psychiatry",
    "Rheumatology",
    "Surgery",
  ];
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
    ToastContext().init(context);
    specialityAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    toast(String message) {
      Toast.show(message,
          duration: Toast.lengthShort,
          gravity: Toast.bottom,
          backgroundColor: const Color(0xffc22ea1));
    }

    clearTextFiels() {
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

    register() async {
      Utility().onLoading(context, true);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
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
        'device_id': '1234568iOSdummyValue',
        'phone': phoneStr,
        'profile_pic': ""
      };
      log('data---register----------$data');
      var response = await http.post(
          Uri.parse("${Webservice().apiUrl}" "${Webservice().userRegister}"),
          body: data);
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
        clearTextFiels();
        Navigator.of(context).pushReplacementNamed('/congratulationVC');
        print("Success API");
      } else {
        print("Failure API");
        final registerErrorData =
            RegisterErrorData.fromJson(json.decode(response.body));
        toast(registerErrorData.message.toString());
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

    final welcomeContainer = Center(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          const Text(
            'Welcome',
            style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular'),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Select Your Specialty Edition',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular'),
          ),
          const SizedBox(
            height: 25,
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
                          color:
                              _selectedIndex != null && _selectedIndex == index
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
                              sharedPreferences.setString("SelctedSpeciality",
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
          SizedBox(
            height: 55.0,
            width: 320.0,
            child: CustomBtn(
                btnLable: "Next",
                onPressed: () {
                  checkSpecialityVal();
                }),
          ),
          AlreadyAcc(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pushReplacementNamed('/Login');
              },
          ),
        ],
      ),
    );
    final welcomeContainer2 = Center(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Registration',
            style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular'),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Select Your Location',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular'),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.only(left: 5.0, top: 0.0, right: 0.0),
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
          const SizedBox(
            height: 15,
          ),
          Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25.0),
              padding:
                  const EdgeInsets.only(left: 18.0, top: 15.0, right: 18.0),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Color.fromRGBO(255, 255, 255, 0.12)),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Please describe where your poster is located. (e.g. Staff Office, Staff Breakroom, or other)",
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontFamily: 'texgyreadventor-regular'),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Container(
                    height: 44.0,
                    padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                            borderSide: BorderSide(color: Colors.transparent),
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
                  const SizedBox(
                    height: 25.0,
                  ),
                ],
              )),
          const SizedBox(
            height: 30.0,
          ),
          SizedBox(
            height: 55.0,
            width: 320.0,
            child: CustomBtn(
                btnLable: "Next",
                onPressed: () {
                  checkLocVal();
                }),
          ),
          AlreadyAcc(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).pushReplacementNamed('/Login');
              },
          ),
        ],
      ),
    );
    final welcomeContainer3 = Center(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Registration',
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
                  controller: _FnameTF,
                  label: 'First Name',
                ),
                const SizedBox(
                  height: 15.0,
                ),
                InputTextField(
                  controller: _LnameTF,
                  label: 'Last Name',
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
                  controller: _PhoneTF,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  label: 'Phone (Optional)',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 80.0,
                ),
                SizedBox(
                  height: 55.0,
                  width: 320.0,
                  child: CustomBtn(
                      btnLable: "Next",
                      onPressed: () {
                        checkUserDetail();
                      }),
                ),
                AlreadyAcc(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushReplacementNamed('/Login');
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
    final welcomeContainer4 = Center(
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Registration',
            style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular'),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Create your Password',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular'),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 15.0,
            ),
            child: Column(
              children: <Widget>[
                InputTextField(
                  controller: _PasswordTF,
                  label: 'Password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                InputTextField(
                  controller: _ConfirmPasswordTF,
                  label: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(
                  height: 7.0,
                ),
                Container(
                  height: 60.0,
                  margin: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: IconButton(
                          icon: checkBoxVal == false
                              ? const Icon(
                                  Icons.check_box_outline_blank,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.check_box,
                                  color: Colors.white,
                                ),
                          onPressed: () {
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
                      ),
                      Flexible(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 14.0,
                            ),
                            Row(
                              children: <Widget>[
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text: "I have read the ",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontFamily: 'texgyreadventor-regular',
                                        fontWeight: FontWeight.w300),
                                    children: [
                                      TextSpan(
                                        text: "Privacy Policy",
                                        style: const TextStyle(
                                          fontSize: 15.0,
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
                                      const TextSpan(
                                        text: " and",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontFamily: 'texgyreadventor-regular',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                RichText(
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text: "agree to the ",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontFamily: 'texgyreadventor-regular',
                                        fontWeight: FontWeight.w300),
                                    children: [
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
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                SizedBox(
                    height: 55,
                    width: 320,
                    child: CustomBtn(
                        btnLable: 'Submit',
                        onPressed: () {
                          validationRegister();
                        })),
                AlreadyAcc(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushReplacementNamed('/Login');
                    },
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
            child: PageView(
              controller: _myPageView,
              children: <Widget>[
                AssetImages(
                    imageFromAsset: const AssetImage('Assets/Rbg1.png'),
                    widgetName: welcomeContainer),
                AssetImages(
                    imageFromAsset: const AssetImage('Assets/Rbg2.png'),
                    widgetName: welcomeContainer2),
                AssetImages(
                    imageFromAsset: const AssetImage('Assets/Rbg3.png'),
                    widgetName: welcomeContainer3),
                AssetImages(
                    imageFromAsset: const AssetImage('Assets/Rbg4.png'),
                    widgetName: welcomeContainer4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
