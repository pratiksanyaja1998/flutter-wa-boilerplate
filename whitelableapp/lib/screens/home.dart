import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whitelableapp/components/home_screen/accommodation_card.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/localization/language_constants.dart';
import 'package:whitelableapp/screens/accommodation_detail.dart';
import 'package:whitelableapp/screens/bookings.dart';
import 'package:whitelableapp/screens/contact_us.dart';
import 'package:whitelableapp/screens/login.dart';
import 'package:whitelableapp/screens/profile.dart';
import 'package:whitelableapp/screens/settings.dart';
import 'package:whitelableapp/screens/terms_and_condition.dart';
import 'package:whitelableapp/service/api.dart';
import 'package:whitelableapp/service/shared_preference.dart';
import 'package:whitelableapp/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<dynamic> accommodationList = [];

  bool showProgress = true;

  @override
  void initState() {
    // TODO: implement initState
    setFcmToken();
    getAccommodations();
    super.initState();
  }

  Future<void> getAccommodations()async{
    if(SharedPreference.getUser() != null) {
      var response = await ServiceApis().getAccommodationList();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        accommodationList = data;
        showProgress = false;
        setState(() {});
      } else {
        showProgress = false;
        setState(() {});
      }
    }else{
      showProgress = false;
      setState(() {});
    }
  }

  Future<void> setFcmToken()async{
    if(SharedPreference.isLogin() && !kIsWeb){
      await ServiceApis().crateFcmToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(kAppName),
        actions: [
          SizedBox(
            height: 55,
            width: 55,
            child: IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              icon: Icon(Icons.person_pin_rounded, size: 25,),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: kPrimaryColor,
        width: 200,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.black,),
                style: ListTileStyle.drawer,
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingsScreen()));
                },
                title: const Text(
                  "Bookings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.black,),
                style: ListTileStyle.drawer,
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
                title: Text(
                  getTranslated(context, ["menu", "settings"]),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if(!kIsWeb)
                ListTile(
                  leading: const Icon(Icons.my_library_books_rounded, color: Colors.black,),
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsAndConditionScreen()));
                  },
                  title: Text(
                    getTranslated(context, ["menu", "termPolicy"]),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ListTile(
                leading: const Icon(Icons.contacts_rounded, color: Colors.black,),
                style: ListTileStyle.drawer,
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUsScreen()));
                },
                title: Text(
                  getTranslated(context, ["menu", "contactUs"]),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(child: Center()),
              Row(
                children: [
                  Expanded(
                    child: Widgets().textButton(
                      onPressed: ()async{
                        if(SharedPreference.isLogin()){
                          await ServiceApis().userLogOut();
                          setState(() {});
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen())).then((value) {
                            setState(() {});
                            getAccommodations();
                          });
                        }
                      },
                      text: SharedPreference.isLogin() ? getTranslated(context, ["menu", "logout"]) : getTranslated(context, ["menu", "login"]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              const Text(
                "Powered by\nSpyhunter IT Solution",
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              const Text(
                "v 3.0.4",
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: showProgress ? const CircularProgressIndicator(
          color: kThemeColor,
        ) : RefreshIndicator(
          onRefresh: ()async{
            // Future.delayed(const Duration(seconds: 0), (){});
            showProgress = true;
            setState(() {});
            getAccommodations();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10,),
                for(int i = 0; i < accommodationList.length; i++)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccommodationDetailScreen(
                            accommodationList: accommodationList,
                            index: i,
                          )));
                        },
                        child: AccommodationCard(
                          name: accommodationList[i]["name"],
                          description: accommodationList[i]["description"],
                          images: accommodationList[i]["images"],
                        ),
                      ),
                      if(i < accommodationList.length - 1)
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 370,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(Icons.filter_alt_rounded),
      ),
    );
  }
}