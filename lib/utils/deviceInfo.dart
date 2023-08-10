import 'dart:developer';
import 'package:pwlp/pw_app.dart';

class DeviceInformation {
  Future<String> getDeviceId() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      log("${androidInfo.id}", name: "messafe");
      return androidInfo.id;
    }
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      log("Issue", name: "messafe");
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      log("${iosInfo.identifierForVendor}", name: "messafe");
      return iosInfo.identifierForVendor ?? "";
    }
    log("Unknown Device", name: "messafe");
    return "c";
  }
}
