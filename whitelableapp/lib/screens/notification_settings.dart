
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {

  bool showProgress = false;

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
            title: Text(getTranslated(context, ["notificationSettings", "title"])),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Stack(
              children: [
                Container(
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
                          padding: const EdgeInsets.all(10),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(context, ["notificationSettings", "orderUpdate"]),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      getTranslated(context, ["notificationSettings", "orderUpdateDescription"]),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                value: SharedPreference.getUser() != null ? SharedPreference.getUser()!.setting.orderUpdateNotification : false,
                                fillColor: MaterialStateProperty.all(kThemeColor),
                                onChanged: (value) async {
                                  showProgress = true;
                                  setState(() {});
                                  await UserServices().userSettingUpdate(
                                    userId: SharedPreference.getUser() != null ? SharedPreference.getUser()!.setting.id : 0,
                                    orderUpdateNotification: value!,
                                    promotionNotification: SharedPreference.getUser() != null ? SharedPreference.getUser()!.setting.promotionNotification : false,
                                  );
                                  var user =  SharedPreference.getUser();
                                  if(user != null){
                                    user.setting.orderUpdateNotification = value;
                                    printMessage("--------------- ${user.setting.orderUpdateNotification} --------------------");
                                  }
                                  await SharedPreference.setUser(userModel: user);
                                  showProgress = false;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Container(
                          padding: const EdgeInsets.all(10),
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
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated(context, ["notificationSettings", "offer"]),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      getTranslated(context, ["notificationSettings", "offerDescrption"]),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                value: SharedPreference.getUser() != null ? SharedPreference.getUser()!.setting.promotionNotification : false,
                                fillColor: MaterialStateProperty.all(kThemeColor),
                                onChanged: (value) async {
                                  showProgress = true;
                                  setState(() {});
                                  await UserServices().userSettingUpdate(
                                    userId: SharedPreference.getUser() != null ? SharedPreference.getUser()!.setting.id : 0,
                                    orderUpdateNotification: SharedPreference.getUser() != null ? SharedPreference.getUser()!.setting.orderUpdateNotification : false,
                                    promotionNotification: value!,
                                  );
                                  var user =  SharedPreference.getUser();
                                  if(user != null){
                                    user.setting.promotionNotification = value;
                                    printMessage("--------------- ${user.setting.promotionNotification} --------------------");
                                  }
                                  await SharedPreference.setUser(userModel: user);
                                  showProgress = false;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if(showProgress)
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: kThemeColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
