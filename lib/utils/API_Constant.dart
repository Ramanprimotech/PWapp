
///Base URL
abstract class BaseUrl {
  static const String live = "https://perks.physiciansweekly.com/api/";
  static const String liveImage = "https://perks.physiciansweekly.com/images/";
  static const String liveTangoCard = "https://api.tangocard.com/raas/v2/";

  static const String stageUrl = "https://stage-perks.physiciansweekly.com/api/";
  static const String stageImage = "https://stage-perks.physiciansweekly.com/images/";
  static const String stageTangoCard = "https://integration-api.tangocard.com/raas/v2/";
}

const String kAppVersion = "2.0.1";

class Api {
  static const String baseUrl = BaseUrl.live;
  static const String baseImageUrl = BaseUrl.liveImage;
  static const String baseTangoCardUrl = BaseUrl.liveTangoCard;

  /// Method Name
  final version = "version";
  final get_address = "get_address";
  final userRegister = "userregister";
  final login = "login";
  final user_dashboard = "user_dashboard";
  final check_qr_code = "check_qr_code";
  final save_poster = "save_poster";
  final get_points = "get_points";
  final save_redemption = "save-redemption";
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