import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:pwlp/Model/notification/notification.dart';
import 'package:pwlp/utils/API_Constant.dart';
import 'package:pwlp/widgets/utility/Utility.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/utility/connectivity_result_message.dart';

typedef VoidWithIntCallback = void Function(int);

class PwNotification extends StatefulWidget {
  final VoidWithIntCallback? changeScreen;
  const PwNotification({Key? key, this.changeScreen}) : super(key: key);

  @override
  _PwNotificationState createState() => _PwNotificationState();
}

viewNotification(BuildContext context, String title, String subTitle) async {
  Alert(
    // alertAnimation: ,
    context: context,
    title: title,
    desc: subTitle,
    buttons: [
      DialogButton(
        color: const Color(0xffc22ea1),
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        width: 120,
        child: const Text(
          "Ok",
          style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'texgyreadventor-regular'),
        ),
      ),
    ],
  ).show();
}

class _PwNotificationState extends State<PwNotification> {
  late Future<List<NotificationModel>?> future;

  Future<List<NotificationModel>?> getNotificationData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences = await SharedPreferences.getInstance();
    Utility().onLoading(context, true);

    Map data = {
      'user_id': sharedPreferences.getString("userID"),
      'device_id': '1234568iOSdummyValue123456789',
    };

    final http.Response response =
        await http.post(Uri.parse(Webservice().apiUrl + Webservice().get_notification), body: data);

    Utility().onLoading(context, false);

    data = json.decode(response.body);
    if (response.statusCode == 200) {
      return (data['data'] as List).map((e) => NotificationModel.fromMap((e as List).first)).toList();
    } else {
      // Utility().toast(context, data['data']);
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    future = getNotificationData();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/dashboard-bg.png'),
              fit: BoxFit.fill,
              alignment: Alignment.topCenter,
            ),
          ),
          child: FutureBuilder<List<NotificationModel>?>(
            future: future,
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No Data Found!!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                );
              }
              List<NotificationModel> notifications = snapshot.data!;
              notifications.sort((a, b) => b.created_at.compareTo(a.created_at));
              return SafeArea(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) {
                    return _BuildNotificationCard(notification: notifications[index]);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BuildNotificationCard extends StatelessWidget {
  const _BuildNotificationCard({Key? key, required this.notification}) : super(key: key);

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: Colors.white30,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Text(notification.id.toString()),
        ),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        ),
        subtitle: Text(
          notification.message,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Text(
          formatDate(notification.created_at, ["M", " ", "dd", ", ", "yyyy"]),
          style: const TextStyle(color: Colors.white),
        ),
        onTap: () {
          // final title = notification.title;
          // final subTitle = notification.message;
          // viewNotification(context, title, subTitle);
          if (notification.link.isNotEmpty) {
            launchUrl(Uri.parse(notification.link));
          }
        },
      ),
    );
  }
}
