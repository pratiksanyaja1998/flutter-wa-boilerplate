
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/main.dart';
import 'package:whitelabelapp/screens/password/change_password.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  List language = [
    {
      "language": "English",
      "languageCode": "en"
    },
    {
      "language": "Hindi",
      "languageCode": "hi"
    },
    {
      "language": "Gujrati",
      "languageCode": "ml"
    },
  ];

  void _changeLanguage(var language) async {
    Locale _locale = await setLocale(language["languageCode"]);
    MyApp.setLocale(context, _locale);
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
              ]
          )
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(getTranslated(context, ["settingScreen", "settings"])),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              constraints: BoxConstraints(
                maxWidth: 370,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Material(),
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Material(
                        elevation: 0,
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Text(
                            getTranslated(context, ["settingScreen", "language"]),
                          ),
                          onTap: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                content: Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 150,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        for(int i = 0; i < language.length; i++)
                                          Column(
                                            children: [
                                              Material(
                                                elevation: 0,
                                                color: Colors.transparent,
                                                child: ListTile(
                                                  leading: Text(
                                                    language[i]["language"],
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    _changeLanguage(language[i]);
                                                  },
                                                  // tileColor: kPrimaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  dense: true,
                                                  trailing: SharedPreference.getLocale() == language[i]["languageCode"] ? const Text(
                                                    "✔",
                                                    style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.green
                                                    ),
                                                  ) : SizedBox(),
                                                ),
                                              ),
                                              if(i < language.length - 1)
                                                const Divider(
                                                  color: Colors.grey,
                                                  height: 0,
                                                ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                          tileColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          dense: true,
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    if(SharedPreference.getUser() != null)
                      if(SharedPreference.getUser()!.type == "admin")
                        Container(
                          margin: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Material(
                            elevation: 0,
                            color: Colors.transparent,
                            child: ListTile(
                              leading: Text(
                                getTranslated(context, ["settingScreen", "environment"]),
                              ),
                              onTap: (){

                              },
                              tileColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              dense: true,
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,),
                            ),
                          ),
                        ),
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Material(
                        elevation: 0,
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Text(
                            getTranslated(context, ["settingScreen", "changePassword"]),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()));
                          },
                          tileColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          dense: true,
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Material(
                        elevation: 0,
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Text(
                            getTranslated(context, ["settingScreen", "notificationSettings"]),
                          ),
                          onTap: (){

                          },
                          tileColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          dense: true,
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Material(
                        elevation: 0,
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Text(
                            getTranslated(context, ["settingScreen", "deleteAccount"]),
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onTap: (){
                            Widgets().showConfirmationDialog(
                              confirmationMessage: getTranslated(context, ["settingScreen", "deleteAccountMessage"]),
                              confirmButtonText: getTranslated(context, ["settingScreen", "confirm"]),
                              cancelButtonText: getTranslated(context, ["settingScreen", "cancel"]),
                              context: context,
                              onConfirm: ()async{
                                Navigator.pop(context);
                                var response = await ServiceApis().deleteAccount();
                                if(response.statusCode == 200){
                                  var data = jsonDecode(response.body);
                                  if(data["success"]) {
                                    Widgets().showAlertDialog(
                                      alertMessage: data["message"],
                                      context: context,
                                    );
                                  }
                                }else{
                                  Widgets().showAlertDialog(
                                    alertMessage: "Something went wrong.",
                                    context: context,
                                  );
                                }
                              }
                            );
                          },
                          tileColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          dense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
