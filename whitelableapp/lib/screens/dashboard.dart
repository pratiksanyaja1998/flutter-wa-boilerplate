
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/screens/accommodation/accommodations.dart';
import 'package:whitelabelapp/screens/login.dart';
import 'package:whitelabelapp/screens/notifications.dart';
import 'package:whitelabelapp/screens/home.dart';
import 'package:whitelabelapp/screens/account.dart';
import 'package:whitelabelapp/screens/promotion.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';

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

  final List<List<String>> appBatTitle = [
    ["Products"],
    ["Accommodations"],
    ["Profile"],
    ["Notifications"],
    ["menu", "promotion"],
  ];

  int selectedItem = 0;

  @override
  void initState() {
    // TODO: implement initState
    setFcmToken();
    super.initState();
  }

  Future<void> setFcmToken()async{
    if(SharedPreference.isLogin() && !kIsWeb){
      await ServiceApis().crateFcmToken();
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
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   title: Text(getTranslated(context, appBatTitle[selectedItem])),
        //   actions: [
        //     if(selectedItem == 3 && SharedPreference.isLogin())
        //       SizedBox(
        //         height: 55,
        //         width: 55,
        //         child: IconButton(
        //           onPressed: (){
        //
        //           },
        //           style: ButtonStyle(
        //             shape: MaterialStateProperty.all(
        //               RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(5),
        //               ),
        //             ),
        //           ),
        //           icon: Icon(Icons.playlist_add_check_outlined, size: 25,),
        //         ),
        //       ),
        //     if(selectedItem == 3 && SharedPreference.isLogin())
        //       SizedBox(
        //         height: 55,
        //         width: 55,
        //         child: IconButton(
        //           onPressed: (){
        //
        //           },
        //           style: ButtonStyle(
        //             shape: MaterialStateProperty.all(
        //               RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(5),
        //               ),
        //             ),
        //           ),
        //           icon: const Icon(CupertinoIcons.delete_solid, size: 25,),
        //         ),
        //       ),
        //   ],
        // ),
        // drawer: Drawer(
        //   backgroundColor: kPrimaryColor,
        //   width: 200,
        //   child: Padding(
        //     padding: const EdgeInsets.all(20.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         const SizedBox(height: 50,),
        //         if(SharedPreference.isLogin())
        //           ListTile(
        //             leading: const Icon(Icons.settings, color: Colors.black,),
        //             style: ListTileStyle.drawer,
        //             horizontalTitleGap: 0,
        //             contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        //             onTap: (){
        //               Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingsScreen()));
        //             },
        //             title: const Text(
        //               "Bookings",
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //         ListTile(
        //           leading: const Icon(Icons.settings, color: Colors.black,),
        //           style: ListTileStyle.drawer,
        //           horizontalTitleGap: 0,
        //           contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
        //           },
        //           title: Text(
        //             getTranslated(context, ["menu", "settings"]),
        //             style: const TextStyle(
        //               fontSize: 20,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //         if(!kIsWeb)
        //           ListTile(
        //             leading: const Icon(Icons.my_library_books_rounded, color: Colors.black,),
        //             style: ListTileStyle.drawer,
        //             horizontalTitleGap: 0,
        //             contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        //             onTap: (){
        //               Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsAndConditionScreen()));
        //             },
        //             title: Text(
        //               getTranslated(context, ["menu", "termPolicy"]),
        //               style: const TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           ),
        //         ListTile(
        //           leading: const Icon(Icons.contacts_rounded, color: Colors.black,),
        //           style: ListTileStyle.drawer,
        //           horizontalTitleGap: 0,
        //           contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        //           onTap: (){
        //             Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUsScreen()));
        //           },
        //           title: Text(
        //             getTranslated(context, ["menu", "contactUs"]),
        //             style: const TextStyle(
        //               fontSize: 20,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ),
        //         const Expanded(child: Center()),
        //         Row(
        //           children: [
        //             Expanded(
        //               child: Widgets().textButton(
        //                 onPressed: (){
        //                   if(SharedPreference.isLogin()){
        //                     Widgets().showConfirmationDialog(
        //                       confirmationMessage: getTranslated(context, ["settingScreen", "logoutMessage"]),
        //                       confirmButtonText: getTranslated(context, ["settingScreen", "confirm"]),
        //                       cancelButtonText: getTranslated(context, ["settingScreen", "cancel"]),
        //                       context: context,
        //                       onConfirm: ()async{
        //                         Navigator.pop(context);
        //                         await ServiceApis().userLogOut();
        //                         selectedItem = 0;
        //                         setState(() {});
        //                       },
        //                     );
        //                   }else{
        //                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen())).then((value) {
        //                       selectedItem = 0;
        //                       setState(() {});
        //                       // getAccommodations();
        //                     });
        //                   }
        //                 },
        //                 text: SharedPreference.isLogin() ? getTranslated(context, ["menu", "logout"]) : getTranslated(context, ["menu", "login"]),
        //               ),
        //             ),
        //           ],
        //         ),
        //         const SizedBox(height: 20,),
        //         const Text(
        //           "Powered by\nSpyhunter IT Solution",
        //           style: TextStyle(
        //             fontSize: 10,
        //           ),
        //         ),
        //         const Text(
        //           "v 3.0.4",
        //           style: TextStyle(
        //             fontSize: 10,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: ((selectedItem == 2 || selectedItem == 0) && SharedPreference.isLogin() || (selectedItem != 2 && selectedItem != 0)) ? _widgetOptions[selectedItem] : Center(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 6,
                offset: Offset(0, -1),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())).then((value) {
                  setState(() {});
                });
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.home,
                  // color: kSecondaryColor,
                ),
                label: getTranslated(context, ["menu", "home"],),
                activeIcon: Icon(Icons.home,)
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.store,
                  // color: kSecondaryColor,
                ),
                label: getTranslated(context, ["menu", "accommodation"]),
              ),
              if(SharedPreference.isLogin())
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.person,
                    // color: kSecondaryColor,
                  ),
                  label: getTranslated(context, ["menu", "account"]),
                )
              else
                BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.login_outlined,
                    // color: kSecondaryColor,
                  ),
                  label: getTranslated(context, ["menu", "login"]),
                ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.notifications,
                  // color: kSecondaryColor,
                ),
                label: getTranslated(context, ["menu", "notifications"]),
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.discount_rounded,
                  // color: kSecondaryColor,
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