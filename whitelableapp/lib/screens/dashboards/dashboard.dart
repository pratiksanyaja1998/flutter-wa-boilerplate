
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/components/assign_task_card.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/screens/developer_assign_task_detail.dart';
import 'package:whitelabelapp/screens/profile_settings.dart';
import 'package:whitelabelapp/screens/report_screen.dart';
import 'package:whitelabelapp/screens/settings.dart';
import 'package:whitelabelapp/screens/terms_and_condition.dart';
import 'package:whitelabelapp/service/api.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key, this.isFromManagerDashboard = false}) : super(key: key);

  final bool isFromManagerDashboard;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  bool showProgress = true;

  List<dynamic> developerTaskList = [];


  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    getDeveloperTaskList();
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> getDeveloperTaskList()async{
    await Future.delayed(const Duration(seconds: 0));
    if(SharedPreference.isLogin()) {
      await UserServices().getUserProfile();
      setState(() {});
      dynamic response;
      // if(SharedPreference.getUser()!.type == "manager"){
      //   response = await ServiceApis().getManagerTaskList();
      // }else{
        response = await ServiceApis().getDeveloperTaskList();
      // }
      var data = jsonDecode(response.body);
      if(!mounted) return;
      if (response.statusCode == 200) {
        developerTaskList = data;
        showProgress = false;
        setState(() {});
      } else {
        showProgress = false;
        setState(() {});
        CommonFunctions().showError(data: data, context: context);
      }
    }else{
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          SharedPreference.getBusinessConfig()!.appName,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          if(SharedPreference.isLogin())
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSettingsScreen())).then((value) {
                    setState(() {});
                  });
                },
                child: Widgets().networkImageContainer(
                  imageUrl: SharedPreference.getUser()!.photo,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
        ],
      ),
      drawer: Drawer(
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
              ListTile(
                leading: const Icon(Icons.home, color: Colors.black,),
                style: ListTileStyle.drawer,
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: (){
                  Navigator.pop(context);
                  if(widget.isFromManagerDashboard){
                    Navigator.pop(context);
                  }
                },
                title: const Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                leading: Image.asset("assets/images/clipboard.png", height: 30,),
                style: ListTileStyle.drawer,
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen()));
                },
                title: const Text(
                  "Report",
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
              // ListTile(
              //   leading: const Icon(Icons.my_library_books_rounded, color: Colors.black,),
              //   style: ListTileStyle.drawer,
              //   horizontalTitleGap: 0,
              //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              //   onTap: (){
              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TermsAndConditionScreen()));
              //   },
              //   title: Text(
              //     getTranslated(context, ["menu", "termPolicy"]),
              //     style: const TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              // ListTile(
              //   leading: const Icon(Icons.contacts_rounded, color: Colors.black,),
              //   style: ListTileStyle.drawer,
              //   horizontalTitleGap: 0,
              //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              //   onTap: (){
              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ContactUsScreen()));
              //   },
              //   title: Text(
              //     getTranslated(context, ["menu", "contactUs"]),
              //     style: const TextStyle(
              //       fontSize: 20,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              const Expanded(child: Center()),
              if(!widget.isFromManagerDashboard)
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
                                  showProgress = true;
                                  setState(() {});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  await UserServices().userLogOut();
                                  showProgress = false;
                                  setState(() {});
                                  if(!mounted) return;
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                                },
                              );
                            }else{
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
      ),
      body: Center(
        child: showProgress ? const CircularProgressIndicator(
          color: kThemeColor,
        ) : Container(
          constraints: BoxConstraints(
            maxWidth: 450,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: !SharedPreference.isLogin() ? Center(
            child: Widgets().textButton(
              onPressed: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              text: "Login",
            ),
          ) : RefreshIndicator(
            onRefresh: ()async{
              showProgress = true;
              setState(() {});
              getDeveloperTaskList();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: developerTaskList.isEmpty ? [
                  SizedBox(height: MediaQuery.of(context).size.height - 100,child: const Center(child: Text("Sorry no record available,"))),
                ] : [
                  const SizedBox(height: 20,),
                  for(int i = 0; i < developerTaskList.length; i++)
                    AssignTaskCard(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DeveloperAssignTaskDetailScreen(assignTaskData: developerTaskList[i]))).then((value) {
                          getDeveloperTaskList();
                        });
                      },
                      assignTaskData: developerTaskList[i],
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20,),
                    //   decoration: BoxDecoration(
                    //     color: kPrimaryColor,
                    //     borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(
                    //       color: kThemeColor.withOpacity(0.7),
                    //     ),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: kThemeColor.withOpacity(0.3),
                    //         blurRadius: 4,
                    //       ),
                    //     ],
                    //   ),
                    //   child: Material(
                    //     elevation: 0,
                    //     color: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10)
                    //     ),
                    //     child: ListTile(
                    //       onTap: (){
                    //         Navigator.push(context, MaterialPageRoute(builder: (context) => DeveloperAssignTaskDetailScreen(assignTaskData: developerTaskList[i]))).then((value) {
                    //           // showProgress = true;
                    //           // setState(() {});
                    //           getDeveloperTaskList();
                    //         });
                    //       },
                    //       contentPadding: const EdgeInsets.only(left: 0, right: 16, top: 10, bottom: 10),
                    //       splashColor: kThemeColor.withOpacity(0.1),
                    //       hoverColor: kThemeColor.withOpacity(0.1),
                    //       title: Row(
                    //         children: [
                    //           Container(
                    //             width: 7,
                    //             height: 100,
                    //             decoration: const BoxDecoration(
                    //               color: kThemeColor,
                    //               borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                    //             ),
                    //           ),
                    //           const SizedBox(width: 16,),
                    //           Expanded(
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 if(developerTaskList[i]["note"].isNotEmpty)
                    //                   Text(
                    //                     developerTaskList[i]["note"],
                    //                     maxLines: 2,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: const TextStyle(
                    //                       fontSize: 18,
                    //                       // fontWeight: FontWeight.w400,
                    //                     ),
                    //                   ),
                    //                 Text(
                    //                   DateFormat("dd MM yyyy hh:mm a").format(DateTime.parse(developerTaskList[i]["created_at"])),
                    //                   style: const TextStyle(
                    //                     fontWeight: FontWeight.w500,
                    //                     fontSize: 15,
                    //                     height: 2,
                    //                     fontStyle: FontStyle.italic,
                    //                   ),
                    //                 ),
                    //                 const Divider(
                    //                   color: Colors.grey,
                    //                 ),
                    //                 const SizedBox(height: 5,),
                    //                 Row(
                    //                   children: [
                    //                     SizedBox(
                    //                       width: 32,
                    //                       height: 32,
                    //                       child: Image.asset("assets/images/working_hours_person.png"),
                    //                     ),
                    //                     const SizedBox(width: 10,),
                    //                     Expanded(
                    //                       child: Column(
                    //                         mainAxisAlignment: MainAxisAlignment.center,
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: [
                    //                           const Text(
                    //                             "Total time",
                    //                             style: TextStyle(
                    //                               // fontSize: 16,
                    //                               fontWeight: FontWeight.w500,
                    //                             ),
                    //                           ),
                    //                           Text(
                    //                             "${(double.parse(developerTaskList[i]["total_time_hr"].toString())).abs().floor()} hour ${((double.parse(developerTaskList[i]["total_time_hr"].toString())*60.0)%60.0).abs().round()} min",
                    //                             style: const TextStyle(
                    //                               fontSize: 16,
                    //                               fontWeight: FontWeight.w500,
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       tileColor: kThemeColor.withOpacity(0.06),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       dense: true,
                    //     ),
                    //   ),
                    // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
