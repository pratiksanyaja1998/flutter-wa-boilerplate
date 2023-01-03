import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/firebase/firebase.dart';
import 'package:whitelabelapp/firebase/firebase_messaging.dart';
import 'package:whitelabelapp/screens/home.dart';
import 'dart:io' show Platform;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseProject().initializeFirebaseApp();
  if(!kIsWeb && !Platform.isWindows) {
    await FirebaseMessagingProject().getFcmToken();
  }
  initWA(
    screen: const HomeScreen(),
    domain: kDomain,
    apiUrl: "http://192.168.1.15:8000",
    theme: kThemeColor,
    primary: kPrimaryColor,
    secondary: kSecondaryColor,
    loginRequired: true,
    firebaseToken: FirebaseMessagingProject.fcmToken,
  );
  SharedPreference.init();

  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/logo.png"), context);
    return MaterialApp(
      locale: _locale,
      supportedLocales: const [
        Locale("en", "US"),
        Locale("hi", "IN"),
        Locale("ml", "IN"),
      ],
      localizationsDelegates: const [
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      title: kAppName,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: kThemeColor,
        colorScheme: const ColorScheme.light(
          primary: kThemeColor,
          onPrimary: kPrimaryColor,
          secondary: kSecondaryColor,
          surfaceTint: Colors.transparent,
          surfaceVariant: kThemeColor,
          primaryContainer: kThemeColor,
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: kThemeColor,
          foregroundColor: Colors.black,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          splashColor: Colors.black.withOpacity(0.1),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: kThemeColor,
          textTheme: ButtonTextTheme.primary,
        ),
        sliderTheme: const SliderThemeData(
          trackHeight: 1,
          activeTrackColor: kThemeColor,
          inactiveTrackColor: kSecondaryColor,
          showValueIndicator: ShowValueIndicator.always,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

