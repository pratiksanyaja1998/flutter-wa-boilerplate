import 'package:flutter/material.dart';
import 'package:whitelableapp/firebase/firebase.dart';
import 'package:whitelableapp/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseProject().initializeFirebaseApp();
  runApp(const MyApp());
}

void initializeFirebaseApp() {
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whitelable App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: kThemeColor,
        splashColor: Colors.black,
        colorScheme: ColorScheme.light(
          secondary: kSecondaryColor,
          primaryContainer: kThemeColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: kThemeColor,
        ),
        applyElevationOverlayColor: true,
        cupertinoOverrideTheme: null,
        extensions: null,
        inputDecorationTheme: null,
        materialTapTargetSize: null,
        pageTransitionsTheme: null,
        platform: null,
        scrollbarTheme: null,
        splashFactory: null,
        visualDensity: null,
        backgroundColor: null,
        bottomAppBarColor: null,
        brightness: null,
        canvasColor: null,
        cardColor: null,
        colorSchemeSeed: null,
        dialogBackgroundColor: null,
        disabledColor: null,
        dividerColor: null,
        errorColor: null,
        focusColor: null,
        highlightColor: null,
        hintColor: null,
        hoverColor: null,
        indicatorColor: null,
        primaryColorDark: null,
        primaryColorLight: null,
        scaffoldBackgroundColor: null,
        secondaryHeaderColor: null,
        selectedRowColor: null,
        shadowColor: null,
        toggleableActiveColor: null,
        unselectedWidgetColor: null,
        fontFamily: null,
        iconTheme: null,
        primaryIconTheme: null,
        primaryTextTheme: null,
        textTheme: null,
        typography: null,
        bannerTheme: null,
        bottomAppBarTheme: null,
        bottomNavigationBarTheme: null,
        bottomSheetTheme: null,
        buttonBarTheme: null,
        buttonTheme: null,
        cardTheme: null,
        checkboxTheme: null,
        chipTheme: null,
        dataTableTheme: null,
        dialogTheme: null,
        dividerTheme: null,
        drawerTheme: null,
        elevatedButtonTheme: null,
        expansionTileTheme: null,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          splashColor: Colors.black.withOpacity(0.1),
        ),
        listTileTheme: null,
        navigationBarTheme: null,
        navigationRailTheme: null,
        outlinedButtonTheme: null,
        popupMenuTheme: null,
        progressIndicatorTheme: null,
        radioTheme: null,
        sliderTheme: null,
        snackBarTheme: null,
        switchTheme: null,
        tabBarTheme: null,
        textButtonTheme: null,
        textSelectionTheme: null,
        timePickerTheme: null,
        toggleButtonsTheme: null,
        tooltipTheme: null,
        accentColor: null,
        accentColorBrightness: null,
        accentTextTheme: null,
        accentIconTheme: null,
        buttonColor: null,
        fixTextFieldOutlineLabel: null,
        primaryColorBrightness: null,
        androidOverscrollIndicator: null,
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kThemeColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6
              )
            ],
          ),
          child: const Text(
            "Welcome to whitelable app",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(Icons.add),
      ),
    );
  }
}
