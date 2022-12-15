
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:whitelabelapp/components/drawer.dart';
import 'package:whitelabelapp/components/notification_card.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/screens/notification_detail.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  List<dynamic> notificationList = [];

  bool showProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    getNotifications();
    super.initState();
  }

  Future<void> getNotifications()async{
    var response = await ServiceApis().getNotificationList();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      notificationList = data;
      showProgress = false;
      setState(() {});
    } else {
      showProgress = false;
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {});
    super.didChangeDependencies();
  }

  bool selected = true;
  bool selectAll = false;
  List<dynamic> selectedNotifications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(getTranslated(context, ["menu", "notifications"])),
        actions: notificationList.isNotEmpty && SharedPreference.isLogin() ? [
          SizedBox(
              height: 55,
              width: 55,
              child: IconButton(
                onPressed: (){
                  selectAll = !selectAll;
                  setState(() {});
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                icon: Icon(Icons.playlist_add_check_outlined, size: 25,),
              ),
            ),
          SizedBox(
              height: 55,
              width: 55,
              child: IconButton(
                onPressed: (){
                  if(notificationList.isNotEmpty) {
                    Widgets().showConfirmationDialog(
                      confirmationMessage: getTranslated(
                          context, [
                        "notificationScreen",
                        selectedNotifications.isNotEmpty
                            ? "deleteSelectMessage"
                            : "deleteMultipleMessage"
                      ]),
                      confirmButtonText: getTranslated(
                          context, ["notificationScreen", "confirm"]),
                      cancelButtonText: getTranslated(
                          context, ["notificationScreen", "reject"]),
                      context: context,
                      onConfirm: () async {
                        showProgress = true;
                        setState(() {});
                        if (selectedNotifications.isNotEmpty) {
                          await ServiceApis().deleteMultipleNotification(
                              notificationId: selectedNotifications.toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", ""));
                        } else {
                          String id = "";
                          for (int i = 0; i < notificationList.length; i++) {
                            id = "$id${notificationList[i]["id"]}, ";
                          }
                          await ServiceApis().deleteMultipleNotification(
                              notificationId: id);
                          getNotifications();
                        }
                        getNotifications();
                      },
                    );
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                icon: const Icon(CupertinoIcons.delete_solid, size: 25,),
              ),
            ),
        ] : [],
      ),
      drawer: DrawerItem().drawer(context, setState),
      body: RefreshIndicator(
        onRefresh: ()async{
          showProgress = true;
          setState(() {});
          getNotifications();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: showProgress ? SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: const Center(
              child: CircularProgressIndicator(
                color: kThemeColor,
              ),
            ),
          ) : notificationList.isEmpty ?
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getTranslated(context, ["notificationScreen", "norecord", "title"]),
                    style: const TextStyle(
                      // color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    width: 150,
                    child: Divider(
                      // color: Colors.white,
                      height: 10,
                      thickness: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 250,
                    child: Text(
                      getTranslated(context, ["notificationScreen", "norecord", "message"]),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        // color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ) : Column(
            children: [
              for(int i = 0; i < notificationList.length; i++)
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationDetailScreen(notificationData: notificationList[i])));
                  },
                  child: Slidable(
                    enabled: SharedPreference.isLogin(),
                    closeOnScroll: !selectAll,
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: 0.2,
                      children: [
                        const Expanded(child: Center()),
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: kPrimaryColor,
                          ),
                          child: Widgets().textButton(
                            onPressed: ()async{

                            },
                            text: "select",
                            backgroundColor: kPrimaryColor,
                            borderRadius: 25,
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            overlayColor: Colors.black.withOpacity(0.1),
                            child: Checkbox(
                              fillColor: MaterialStateProperty.all(kThemeColor),
                              value: selectedNotifications.contains(i),
                              onChanged: (value){
                                selected = value!;
                                setState(() {});
                                if(value == true){
                                  selectedNotifications.add(i);
                                }else if(selectedNotifications.contains(i)){
                                  selectedNotifications.remove(i);
                                }
                                // if(value == true){
                                //   selectedNotifications.add(notificationList[i]["id"]);
                                // }else if(selectedNotifications.contains(notificationList[i]["id"])){
                                //   selectedNotifications.remove(notificationList[i]["id"]);
                                // }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: 0.2,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 0),
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: kPrimaryColor,
                          ),
                          child: Widgets().textButton(
                            onPressed: ()async{
                              Widgets().showConfirmationDialog(
                                confirmationMessage: getTranslated(
                                    context, ["notificationScreen", "deleteMessage"]),
                                confirmButtonText: getTranslated(
                                    context, ["notificationScreen", "confirm"]),
                                cancelButtonText: getTranslated(
                                    context, ["notificationScreen", "reject"]),
                                context: context,
                                onConfirm: () async{
                                  showProgress = true;
                                  setState(() {});
                                  await ServiceApis().deleteNotification(notificationId: notificationList[i]["id"]);
                                  await getNotifications();
                                },
                              );
                            },
                            text: "delete",
                            backgroundColor: kPrimaryColor,
                            borderRadius: 25,
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            overlayColor: Colors.black.withOpacity(0.1),
                            child: const Icon(CupertinoIcons.delete_solid, size: 25, color: Colors.black,),
                          ),
                        ),
                      ],
                    ),
                    child: NotificationCard(
                      selectAll: selectAll,
                      selected: selected,
                      date: DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(notificationList[i]["updated_at"])),
                      enabled: SharedPreference.isLogin(),
                      photo: notificationList[i]["photo"],
                      title: notificationList[i]["title"],
                      description: notificationList[i]["description"],
                    ),
                  ),
                  // child: NotificationCard(
                  //   selectAll: selectAll,
                  //   selected: selected,
                  //   enabled: SharedPreference.isLogin(),
                  //   onChanged: (value){
                  //     selected = value!;
                  //     setState(() {});
                  //   },
                  // ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
