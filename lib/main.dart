import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwlp/views/auth/Login.dart';
import 'package:pwlp/views/auth/RegisterVC.dart';
import 'package:pwlp/views/common/CongratulationVC.dart';
import 'package:pwlp/views/common/SplashScreen.dart';
import 'package:pwlp/views/dashboard/Dashboard.dart';
import 'package:pwlp/views/search/LocationSearch.dart';
import 'package:pwlp/widgets/utility/updateUI.dart';

import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UpdateUI(),
      )
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/SplashScreen': (BuildContext context) => const SplashScreen(),
          '/RegisterVC': (BuildContext context) => RegisterVC(),
          '/Login': (BuildContext context) => const Login(),
          '/LocationSearch': (BuildContext context) => const LocationSearch(),
          '/congratulationVC': (BuildContext context) => congratulationVC(),
          '/Dashboard': (BuildContext context) => const Dashboard(),
        }),
  ));
}
