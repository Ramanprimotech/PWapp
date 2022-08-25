import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AlreadyAcc extends StatelessWidget {
  AlreadyAcc({Key? key, required this.recognizer}) : super(key: key);
  GestureRecognizer? recognizer;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: "Already have an Account? ",
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontFamily: 'texgyreadventor-regular',
                fontWeight: FontWeight.w300),
            children: [
              TextSpan(
                  text: "Login",
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontFamily: 'texgyreadventor-regular',
                    fontWeight: FontWeight.w400,
                  ),
                  recognizer: recognizer),
            ],
          ),
        ),
      ),
    );
  }
}

/**TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushReplacementNamed('/Login');
                  }, */