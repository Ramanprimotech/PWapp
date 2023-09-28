import 'package:pwlp/pw_app.dart';

dialogAlert(BuildContext context, String message) {
  Alert(
    context: context,
    title: "Partner Perks",
    desc: message,
    buttons: [
      DialogButton(
        color: const Color(0xffc22ea1),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        width: 120,
        child: const Text(
          "Ok",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'texgyreadventor-regular'),
        ),
      ),
    ],
  ).show();
}

dialogLogoutAlert(BuildContext context, String message, Function logout) {
  Alert(
    context: context,
    title: "Partner Perks",
    desc: message,
    buttons: [
      DialogButton(
        color: const Color(0xffc22ea1),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        width: 120,
        child: const Text(
          "Cancel",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'texgyreadventor-regular'),
        ),
      ),
      DialogButton(
        color: const Color(0xffc22ea1),
        onPressed: () {
          logout();
        },
        width: 120,
        child: const Text(
          "Ok",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'texgyreadventor-regular'),
        ),
      ),
    ],
  ).show();
}
