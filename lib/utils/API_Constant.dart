class Webservice {
  /// Staging
  final apiUrl = "https://stage-perks.physiciansweekly.com/api/";
  final imagePath = "https://stage-perks.physiciansweekly.com/images/";

  /// Live Store
  // final apiUrl = "https://perks.physiciansweekly.com/api/";
  // final imagePath = "https://perks.physiciansweekly.com/images/";

  /// SandBox Tango
  //final tangoCardBaseUrl = "https://integration-api.tangocard.com/raas/v2/";

  /// Production Tango
  final tangoCardBaseUrl = "https://api.tangocard.com/raas/v2/";

  /// Method Name
  final get_address = "get_address";
  final userRegister = "userregister";
  final login = "login";
  final user_dashboard = "user_dashboard";
  final check_qr_code = "check_qr_code";
  final save_poster = "save_poster";
  final get_points = "get_points";
  final get_user_blance = "get_user_blance";
  final save_oder = "save_oder";
  final get_user_profile = "get_user_profile";
  final update_profile = "update_profile";
  final get_user_wallet = "get_user_wallet";
  final update_profile_pic = "update_profile_pic";
  final get_speciality = "get_speciality";
  final forget_password = "forget_password";
  final add_poster_image = "add_poster_image";
  final get_notification = "get_notification";
  final contact_us = "contact-us-app";

  /// Tango Card Method Name
  final orders = "orders";
}
