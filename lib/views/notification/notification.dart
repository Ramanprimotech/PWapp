import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../widgets/utility/connectivity_result_message.dart';

typedef VoidWithIntCallback = void Function(int);

class PwNotification extends StatefulWidget {
  final VoidWithIntCallback? changeScreen;
  const PwNotification({Key? key, this.changeScreen}) : super(key: key);

  @override
  _PwNotificationState createState() => _PwNotificationState();
}

final List dummyList = List.generate(2, (index) {
  return {
    "id": index,
    "title": " Partner Perks",
    "subtitle": "This is the subtitle",
    "date": "01/10/2022 "
  };
});

Widget notification() {
  return SafeArea(
    child: ListView.builder(
      itemCount: dummyList.length,
      itemBuilder: (context, index) => Card(
        elevation: 6,
        color: Colors.grey.shade200.withOpacity(0.4),
        margin: const EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.purple,
            child: Text(dummyList[index]["id"].toString()),
          ),
          title: Text(
            dummyList[index]["title"],
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          subtitle: Text(
            dummyList[index]["subtitle"],
            style: const TextStyle(color: Colors.white30),
          ),
          trailing: Text(
            dummyList[index]["date"].toString(),
            style: const TextStyle(color: Colors.white30),
          ),
          onTap: () {
            final title = dummyList[index]["title"];
            final subTitle = dummyList[index]["subtitle"];
            viewNotification(context, title, subTitle);
          },
        ),
      ),
    ),
  );
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
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'texgyreadventor-regular'),
        ),
      ),
    ],
  ).show();
}

class _PwNotificationState extends State<PwNotification> {
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
          body: Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('Assets/dashboard-bg.png'),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              notification(),
            ],
          ),
        ));
  }
}
