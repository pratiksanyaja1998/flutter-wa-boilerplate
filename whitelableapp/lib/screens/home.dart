import 'package:flutter/material.dart';
import 'package:whitelableapp/components/home_screen/accommodation_card.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/screens/login.dart';
import 'package:whitelableapp/screens/profile.dart';
import 'package:whitelableapp/service/api.dart';
import 'package:whitelableapp/service/shared_preference.dart';
import 'package:whitelableapp/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<dynamic> accommodationCards = [
    {
      "Name": "Grove of Narberth",
      "Description": "Restored 17th-century country house with a bright modern interior",
      "Url": "https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    },
    {
      "Name": "AA Red Star hotel",
      "Description": "Red Star hotels stand out as the very best in the UK, regardless of style. They offer excellent levels of quality, and outstanding levels of hospitality and service throughout. These hard-earned accolades are a reliable sign that a hotel is not just great, but exceptional.",
      "Url": "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    }
  ];

  @override
  void initState() {
    // TODO: implement initState
    setFcmToken();
    super.initState();
  }

  Future<void> setFcmToken()async{
    if(SharedPreference.isLogin()){
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
        child: Column(
          children: [
            Expanded(child: Center()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Row(
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
                          });
                        }
                      },
                      text: SharedPreference.isLogin() ? "Log out" : "Log in",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              for(int i = 0; i < accommodationCards.length; i++)
                AccommodationCard(
                  name: accommodationCards[i]["Name"],
                  description: accommodationCards[i]["Description"],
                  imageUrl: accommodationCards[i]["Url"],
                ),
            ],
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