
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/screens/accommodation/bookings.dart';
import 'package:whitelabelapp/screens/contact_us.dart';
import 'package:whitelabelapp/screens/settings.dart';
import 'package:whitelabelapp/screens/terms_and_condition.dart';

class DrawerItem{
  Widget drawer(BuildContext context, void Function(void Function()) setState){
    return Drawer(
      backgroundColor: kPrimaryColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      width: 200,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15,),
            if(SharedPreference.isLogin())
              ListTile(
                leading: const Icon(Icons.book_online, color: Colors.black,),
                style: ListTileStyle.drawer,
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BookingsScreen()));
                },
                title: const Text(
                  "Bookings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black,),
              style: ListTileStyle.drawer,
              horizontalTitleGap: 0,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
              },
              title: Text(
                getTranslated(context, ["menu", "settings"]),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // if(!kIsWeb)
              ListTile(
                leading: const Icon(Icons.my_library_books_rounded, color: Colors.black,),
                style: ListTileStyle.drawer,
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TermsAndConditionScreen()));
                },
                title: Text(
                  getTranslated(context, ["menu", "termPolicy"]),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.contacts_rounded, color: Colors.black,),
              style: ListTileStyle.drawer,
              horizontalTitleGap: 0,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ContactUsScreen()));
              },
              title: Text(
                getTranslated(context, ["menu", "contactUs"]),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Expanded(child: Center()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Widgets().textButton(
                      onPressed: (){
                        if(SharedPreference.isLogin()){
                          CommonFunctions().showConfirmationDialog(
                            confirmationMessage: getTranslated(context, ["settingScreen", "logoutMessage"]),
                            confirmButtonText: getTranslated(context, ["settingScreen", "confirm"]),
                            cancelButtonText: getTranslated(context, ["settingScreen", "cancel"]),
                            context: context,
                            onConfirm: ()async{
                              Navigator.pop(context);
                              await UserServices().userLogOut();
                              setState(() {});
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                            },
                          );
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen())).then((value) {
                            setState(() {});
                          });
                        }
                      },
                      text: SharedPreference.isLogin() ? getTranslated(context, ["menu", "logout"]) : getTranslated(context, ["menu", "login"]),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Powered by\nSpyhunter IT Solution\nv 3.0.4",
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}