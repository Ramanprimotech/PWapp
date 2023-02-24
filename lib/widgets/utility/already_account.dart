import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pwlp/widgets/AppText.dart';

// ignore: must_be_immutable
class AlreadyAcc extends StatelessWidget {
  AlreadyAcc({Key? key, required this.recognizer}) : super(key: key);
  GestureRecognizer? recognizer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            children: [
              const WidgetSpan(
                child: AppText(
                  "Already have an Account? ",
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                  text: "Login",
                  style: const
                  TextStyle(
                    fontSize: 18.0,
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
