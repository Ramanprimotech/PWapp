import 'pw_app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
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
            '/RegisterVC': (BuildContext context) => const RegisterVC(),
            '/Login': (BuildContext context) => const Login(),
            '/LocationSearch': (BuildContext context) => const LocationSearch(),
            '/congratulationVC': (BuildContext context) => CongratulationVC(),
            '/Dashboard': (BuildContext context) => const Dashboard(),
            '/ContactUs': (BuildContext context) => const ContactUs(),
          }),
    ),
  );
}
