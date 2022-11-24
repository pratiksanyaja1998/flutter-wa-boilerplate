import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/firebase/firebase.dart';
import 'package:whitelableapp/firebase/firebase_messaging.dart';
import 'package:whitelableapp/screens/splash.dart';
import 'package:whitelableapp/service/api.dart';
import 'package:whitelableapp/service/shared_preference.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseProject().initializeFirebaseApp();

  await SharedPreference.init();
  await ServiceApis.init();
  await FirebaseMessagingProject().getFcmToken();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/logo.png"), context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: kThemeColor,
        splashColor: Colors.black,
        colorScheme: const ColorScheme.light(
          secondary: kSecondaryColor,
          primaryContainer: kThemeColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kThemeColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          splashColor: Colors.black.withOpacity(0.1),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: kThemeColor,
          textTheme: ButtonTextTheme.primary,
          // colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
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
      home: const SplashScreen(),
    );
  }
}

