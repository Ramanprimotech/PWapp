import 'package:pwlp/pw_app.dart';

Future CommonShowDialog(context, {Widget? child, contentPadding}) {
  return showDialog(
      barrierColor: Colors.black87,
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6),
          backgroundColor: Colors.white24,
          content: Container(
            padding: contentPadding ?? const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), color: Colors.white),
            height: 240,
            child: child ?? const SizedBox(),
          ),
        );
      });
}

List<TextInputFormatter> emailFormatter = [
  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9\.\-\@\_]')),
  FilteringTextInputFormatter.deny(RegExp('[\<\>\?\\\/\|\=\;\:]')),
];

bool isValidEmail(value) {
  if (value.isEmpty) {
    return false;
  }
  RegExp exp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  bool result = exp.hasMatch(value);

  return result;
}
