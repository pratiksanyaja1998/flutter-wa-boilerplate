import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/firebase/firebase.dart';
import 'package:whitelabelapp/firebase/firebase_messaging.dart';
import 'package:whitelabelapp/localization/demo_localization.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/screens/splash.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseProject().initializeFirebaseApp();

  await SharedPreference.init();
  await ServiceApis.init();

  if(!kIsWeb) {
    await FirebaseMessagingProject().getFcmToken();
  }

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
        this._locale = locale;
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
        // splashColor: kThemeColor,
        colorScheme: const ColorScheme.light(
          primary: kThemeColor,
          onPrimary: kPrimaryColor,
          secondary: kSecondaryColor,
          surfaceTint: Colors.transparent,
          surfaceVariant: kThemeColor,
          // shadow: kThemeColor,
          primaryContainer: kThemeColor,
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: kThemeColor,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          splashColor: Colors.black.withOpacity(0.1),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: kThemeColor,
          textTheme: ButtonTextTheme.primary,
          // colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
        ),
        sliderTheme: const SliderThemeData(
          trackHeight: 1,
          activeTrackColor: kThemeColor,
          inactiveTrackColor: kSecondaryColor,
          showValueIndicator: ShowValueIndicator.always,
        ),
        // applyElevationOverlayColor: true,
        // cupertinoOverrideTheme: null,
        // extensions: null,
        // inputDecorationTheme: null,
        // materialTapTargetSize: null,
        // pageTransitionsTheme: null,
        // platform: null,
        // scrollbarTheme: null,
        // splashFactory: null,
        // visualDensity: null,
        // backgroundColor: null,
        // bottomAppBarColor: null,
        // brightness: null,
        // canvasColor: null,
        // cardColor: null,
        // colorSchemeSeed: null,
        // dialogBackgroundColor: null,
        // disabledColor: null,
        // dividerColor: null,
        // errorColor: null,
        // focusColor: null,
        // highlightColor: null,
        // hintColor: null,
        // hoverColor: null,
        // indicatorColor: null,
        // primaryColorDark: null,
        // primaryColorLight: null,
        // scaffoldBackgroundColor: null,
        // secondaryHeaderColor: null,
        // selectedRowColor: null,
        // shadowColor: null,
        // toggleableActiveColor: null,
        // unselectedWidgetColor: null,
        // fontFamily: null,
        // iconTheme: null,
        // primaryIconTheme: null,
        // primaryTextTheme: null,
        // textTheme: null,
        // typography: null,
        // bannerTheme: null,
        // bottomAppBarTheme: null,
        // bottomNavigationBarTheme: null,
        // bottomSheetTheme: null,
        // buttonBarTheme: null,
        // buttonTheme: null,
        // cardTheme: null,
        // checkboxTheme: null,
        // chipTheme: null,
        // dataTableTheme: null,
        // dialogTheme: null,
        // dividerTheme: null,
        // drawerTheme: null,
        // elevatedButtonTheme: null,
        // expansionTileTheme: null,
        // listTileTheme: null,
        // navigationBarTheme: null,
        // navigationRailTheme: null,
        // outlinedButtonTheme: null,
        // popupMenuTheme: null,
        // progressIndicatorTheme: null,
        // radioTheme: null,
        // sliderTheme: null,
        // snackBarTheme: null,
        // switchTheme: null,
        // tabBarTheme: null,
        // textButtonTheme: null,
        // textSelectionTheme: null,
        // timePickerTheme: null,
        // toggleButtonsTheme: null,
        // tooltipTheme: null,
        // accentColor: null,
        // accentColorBrightness: null,
        // accentTextTheme: null,
        // accentIconTheme: null,
        // buttonColor: null,
        // fixTextFieldOutlineLabel: null,
        // primaryColorBrightness: null,
        // androidOverscrollIndicator: null,
        useMaterial3: true,
      ),

      // darkTheme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   primaryColor: kThemeColor,
      //   splashColor: Colors.black,
      //   colorScheme: const ColorScheme.dark(
      //     secondary: kSecondaryColor,
      //     primaryContainer: kThemeColor,
      //   ),
      //   appBarTheme: const AppBarTheme(
      //     backgroundColor: kThemeColor,
      //   ),
      //   floatingActionButtonTheme: FloatingActionButtonThemeData(
      //     splashColor: Colors.black.withOpacity(0.1),
      //   ),
      //   buttonTheme: ButtonThemeData(
      //     buttonColor: kThemeColor,
      //     textTheme: ButtonTextTheme.primary,
      //     // colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
      //   ),
      //   // applyElevationOverlayColor: true,
      //   // cupertinoOverrideTheme: null,
      //   // extensions: null,
      //   // inputDecorationTheme: null,
      //   // materialTapTargetSize: null,
      //   // pageTransitionsTheme: null,
      //   // platform: null,
      //   // scrollbarTheme: null,
      //   // splashFactory: null,
      //   // visualDensity: null,
      //   // backgroundColor: null,
      //   // bottomAppBarColor: null,
      //   // brightness: null,
      //   // canvasColor: null,
      //   // cardColor: null,
      //   // colorSchemeSeed: null,
      //   // dialogBackgroundColor: null,
      //   // disabledColor: null,
      //   // dividerColor: null,
      //   // errorColor: null,
      //   // focusColor: null,
      //   // highlightColor: null,
      //   // hintColor: null,
      //   // hoverColor: null,
      //   // indicatorColor: null,
      //   // primaryColorDark: null,
      //   // primaryColorLight: null,
      //   // scaffoldBackgroundColor: null,
      //   // secondaryHeaderColor: null,
      //   // selectedRowColor: null,
      //   // shadowColor: null,
      //   // toggleableActiveColor: null,
      //   // unselectedWidgetColor: null,
      //   // fontFamily: null,
      //   // iconTheme: null,
      //   // primaryIconTheme: null,
      //   // primaryTextTheme: null,
      //   // textTheme: null,
      //   // typography: null,
      //   // bannerTheme: null,
      //   // bottomAppBarTheme: null,
      //   // bottomNavigationBarTheme: null,
      //   // bottomSheetTheme: null,
      //   // buttonBarTheme: null,
      //   // buttonTheme: null,
      //   // cardTheme: null,
      //   // checkboxTheme: null,
      //   // chipTheme: null,
      //   // dataTableTheme: null,
      //   // dialogTheme: null,
      //   // dividerTheme: null,
      //   // drawerTheme: null,
      //   // elevatedButtonTheme: null,
      //   // expansionTileTheme: null,
      //   // listTileTheme: null,
      //   // navigationBarTheme: null,
      //   // navigationRailTheme: null,
      //   // outlinedButtonTheme: null,
      //   // popupMenuTheme: null,
      //   // progressIndicatorTheme: null,
      //   // radioTheme: null,
      //   // sliderTheme: null,
      //   // snackBarTheme: null,
      //   // switchTheme: null,
      //   // tabBarTheme: null,
      //   // textButtonTheme: null,
      //   // textSelectionTheme: null,
      //   // timePickerTheme: null,
      //   // toggleButtonsTheme: null,
      //   // tooltipTheme: null,
      //   // accentColor: null,
      //   // accentColorBrightness: null,
      //   // accentTextTheme: null,
      //   // accentIconTheme: null,
      //   // buttonColor: null,
      //   // fixTextFieldOutlineLabel: null,
      //   // primaryColorBrightness: null,
      //   // androidOverscrollIndicator: null,
      //   useMaterial3: true,
      // ),
      home: const SplashScreen(),
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     precacheImage(const AssetImage("assets/images/logo.png"), context);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: kAppName,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         primaryColor: kThemeColor,
//         // splashColor: kThemeColor,
//         colorScheme: const ColorScheme.light(
//           primary: kThemeColor,
//           onPrimary: kPrimaryColor,
//           secondary: kSecondaryColor,
//           surfaceTint: kThemeColor,
//           surfaceVariant: kThemeColor,
//           // shadow: kThemeColor,
//           primaryContainer: kThemeColor,
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: kThemeColor,
//         ),
//         floatingActionButtonTheme: FloatingActionButtonThemeData(
//           splashColor: Colors.black.withOpacity(0.1),
//         ),
//         buttonTheme: const ButtonThemeData(
//           buttonColor: kThemeColor,
//           textTheme: ButtonTextTheme.primary,
//           // colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
//         ),
//         // applyElevationOverlayColor: true,
//         // cupertinoOverrideTheme: null,
//         // extensions: null,
//         // inputDecorationTheme: null,
//         // materialTapTargetSize: null,
//         // pageTransitionsTheme: null,
//         // platform: null,
//         // scrollbarTheme: null,
//         // splashFactory: null,
//         // visualDensity: null,
//         // backgroundColor: null,
//         // bottomAppBarColor: null,
//         // brightness: null,
//         // canvasColor: null,
//         // cardColor: null,
//         // colorSchemeSeed: null,
//         // dialogBackgroundColor: null,
//         // disabledColor: null,
//         // dividerColor: null,
//         // errorColor: null,
//         // focusColor: null,
//         // highlightColor: null,
//         // hintColor: null,
//         // hoverColor: null,
//         // indicatorColor: null,
//         // primaryColorDark: null,
//         // primaryColorLight: null,
//         // scaffoldBackgroundColor: null,
//         // secondaryHeaderColor: null,
//         // selectedRowColor: null,
//         // shadowColor: null,
//         // toggleableActiveColor: null,
//         // unselectedWidgetColor: null,
//         // fontFamily: null,
//         // iconTheme: null,
//         // primaryIconTheme: null,
//         // primaryTextTheme: null,
//         // textTheme: null,
//         // typography: null,
//         // bannerTheme: null,
//         // bottomAppBarTheme: null,
//         // bottomNavigationBarTheme: null,
//         // bottomSheetTheme: null,
//         // buttonBarTheme: null,
//         // buttonTheme: null,
//         // cardTheme: null,
//         // checkboxTheme: null,
//         // chipTheme: null,
//         // dataTableTheme: null,
//         // dialogTheme: null,
//         // dividerTheme: null,
//         // drawerTheme: null,
//         // elevatedButtonTheme: null,
//         // expansionTileTheme: null,
//         // listTileTheme: null,
//         // navigationBarTheme: null,
//         // navigationRailTheme: null,
//         // outlinedButtonTheme: null,
//         // popupMenuTheme: null,
//         // progressIndicatorTheme: null,
//         // radioTheme: null,
//         // sliderTheme: null,
//         // snackBarTheme: null,
//         // switchTheme: null,
//         // tabBarTheme: null,
//         // textButtonTheme: null,
//         // textSelectionTheme: null,
//         // timePickerTheme: null,
//         // toggleButtonsTheme: null,
//         // tooltipTheme: null,
//         // accentColor: null,
//         // accentColorBrightness: null,
//         // accentTextTheme: null,
//         // accentIconTheme: null,
//         // buttonColor: null,
//         // fixTextFieldOutlineLabel: null,
//         // primaryColorBrightness: null,
//         // androidOverscrollIndicator: null,
//         useMaterial3: true,
//       ),
//
//       // darkTheme: ThemeData(
//       //   primarySwatch: Colors.blue,
//       //   primaryColor: kThemeColor,
//       //   splashColor: Colors.black,
//       //   colorScheme: const ColorScheme.dark(
//       //     secondary: kSecondaryColor,
//       //     primaryContainer: kThemeColor,
//       //   ),
//       //   appBarTheme: const AppBarTheme(
//       //     backgroundColor: kThemeColor,
//       //   ),
//       //   floatingActionButtonTheme: FloatingActionButtonThemeData(
//       //     splashColor: Colors.black.withOpacity(0.1),
//       //   ),
//       //   buttonTheme: ButtonThemeData(
//       //     buttonColor: kThemeColor,
//       //     textTheme: ButtonTextTheme.primary,
//       //     // colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
//       //   ),
//       //   // applyElevationOverlayColor: true,
//       //   // cupertinoOverrideTheme: null,
//       //   // extensions: null,
//       //   // inputDecorationTheme: null,
//       //   // materialTapTargetSize: null,
//       //   // pageTransitionsTheme: null,
//       //   // platform: null,
//       //   // scrollbarTheme: null,
//       //   // splashFactory: null,
//       //   // visualDensity: null,
//       //   // backgroundColor: null,
//       //   // bottomAppBarColor: null,
//       //   // brightness: null,
//       //   // canvasColor: null,
//       //   // cardColor: null,
//       //   // colorSchemeSeed: null,
//       //   // dialogBackgroundColor: null,
//       //   // disabledColor: null,
//       //   // dividerColor: null,
//       //   // errorColor: null,
//       //   // focusColor: null,
//       //   // highlightColor: null,
//       //   // hintColor: null,
//       //   // hoverColor: null,
//       //   // indicatorColor: null,
//       //   // primaryColorDark: null,
//       //   // primaryColorLight: null,
//       //   // scaffoldBackgroundColor: null,
//       //   // secondaryHeaderColor: null,
//       //   // selectedRowColor: null,
//       //   // shadowColor: null,
//       //   // toggleableActiveColor: null,
//       //   // unselectedWidgetColor: null,
//       //   // fontFamily: null,
//       //   // iconTheme: null,
//       //   // primaryIconTheme: null,
//       //   // primaryTextTheme: null,
//       //   // textTheme: null,
//       //   // typography: null,
//       //   // bannerTheme: null,
//       //   // bottomAppBarTheme: null,
//       //   // bottomNavigationBarTheme: null,
//       //   // bottomSheetTheme: null,
//       //   // buttonBarTheme: null,
//       //   // buttonTheme: null,
//       //   // cardTheme: null,
//       //   // checkboxTheme: null,
//       //   // chipTheme: null,
//       //   // dataTableTheme: null,
//       //   // dialogTheme: null,
//       //   // dividerTheme: null,
//       //   // drawerTheme: null,
//       //   // elevatedButtonTheme: null,
//       //   // expansionTileTheme: null,
//       //   // listTileTheme: null,
//       //   // navigationBarTheme: null,
//       //   // navigationRailTheme: null,
//       //   // outlinedButtonTheme: null,
//       //   // popupMenuTheme: null,
//       //   // progressIndicatorTheme: null,
//       //   // radioTheme: null,
//       //   // sliderTheme: null,
//       //   // snackBarTheme: null,
//       //   // switchTheme: null,
//       //   // tabBarTheme: null,
//       //   // textButtonTheme: null,
//       //   // textSelectionTheme: null,
//       //   // timePickerTheme: null,
//       //   // toggleButtonsTheme: null,
//       //   // tooltipTheme: null,
//       //   // accentColor: null,
//       //   // accentColorBrightness: null,
//       //   // accentTextTheme: null,
//       //   // accentIconTheme: null,
//       //   // buttonColor: null,
//       //   // fixTextFieldOutlineLabel: null,
//       //   // primaryColorBrightness: null,
//       //   // androidOverscrollIndicator: null,
//       //   useMaterial3: true,
//       // ),
//       home: const SplashScreen(),
//     );
//   }
// }

