
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/screens/accommodation/accommodations.dart';
import 'package:whitelabelapp/screens/notifications.dart';
import 'package:whitelabelapp/screens/home.dart';
import 'package:whitelabelapp/screens/account.dart';
import 'package:whitelabelapp/screens/promotion.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final List _widgetOptions = <Widget>[
    const HomeScreen(),
    const AccommodationScreen(),
    const AccountScreen(),
    const NotificationScreen(),
    const PromotionScreen(),
  ];

  int selectedItem = 0;

  @override
  void initState() {
    setFcmToken();
    super.initState();
  }

  Future<void> setFcmToken()async{
    if(SharedPreference.isLogin() && !kIsWeb){
      await UserServices().crateFcmToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kThemeColor,
            Colors.white,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ((selectedItem == 2 || selectedItem == 0) && SharedPreference.isLogin() || (selectedItem != 2 && selectedItem != 0)) ? _widgetOptions[selectedItem] : const Center(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, -1),
              )
            ],
          ),
          child: BottomNavigationBar(
            selectedFontSize: 12,
            currentIndex: selectedItem,
            iconSize: 25,
            selectedLabelStyle: const TextStyle(
              // height: 2,
              fontWeight: FontWeight.w500,
            ),
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            onTap: (index){
              selectedItem = index;
              setState(() {});
              if(selectedItem == 2 && !SharedPreference.isLogin()){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())).then((value) {
                  setState(() {});
                });
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.home,
                ),
                label: getTranslated(context, ["menu", "home"],),
                activeIcon: const Icon(Icons.home,)
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.store,
                ),
                label: getTranslated(context, ["menu", "accommodation"]),
              ),
              if(SharedPreference.isLogin())
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.person,
                  ),
                  label: getTranslated(context, ["menu", "account"]),
                )
              else
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.login_outlined,
                  ),
                  label: getTranslated(context, ["menu", "login"]),
                ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.notifications,
                ),
                label: getTranslated(context, ["menu", "notifications"]),
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.discount_rounded,
                ),
                label: getTranslated(context, ["menu", "promotion"]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}