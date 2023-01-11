
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/components/project_card.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/screens/app_users_screen.dart';
import 'package:whitelabelapp/screens/contact_us.dart';
import 'package:whitelabelapp/screens/dashboards/dashboard.dart';
import 'package:whitelabelapp/screens/profile_settings.dart';
import 'package:whitelabelapp/screens/project_detail.dart';
import 'package:whitelabelapp/screens/settings.dart';
import 'package:whitelabelapp/screens/terms_and_condition.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:intl/intl.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {

  bool showProgress = true;

  List<dynamic> projectList = [];
  List<dynamic> businessUserList = [];
  List<dynamic> managerList = [];
  int? selectedProjectIndex;
  int? selectedUserIndex;

  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    getProjectList();
    getBusinessUserList();
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

  Future<void> getProjectList()async{
    await Future.delayed(const Duration(seconds: 0));
    if(SharedPreference.isLogin()) {
      var response = await ServiceApis().getProjectList();
      var data = jsonDecode(response.body);
      if(!mounted) return;
      if (response.statusCode == 200) {
        projectList = data;
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

  Future<void> getBusinessUserList()async{
    await Future.delayed(const Duration(seconds: 0));
    if(SharedPreference.isLogin()) {
      var response = await ServiceApis().getBusinessStaffList();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        businessUserList = data;
        if(businessUserList.isNotEmpty) {
          managerList = businessUserList.where((element) => element["type"] == "manager").toList();
        }
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        centerTitle: true,
        title: Text(
          SharedPreference.getBusinessConfig()!.appName,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          if(SharedPreference.isLogin())
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSettingsScreen())).then((value) {
                  setState(() {});
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SharedPreference.getUser()!.photo.isNotEmpty ?
                  Image.network(
                    SharedPreference.getUser()!.photo,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress){
                      if(loadingProgress != null){
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kThemeColor,
                            strokeWidth: 3,
                          ),
                        );
                      }else{
                        return child;
                      }
                    },
                    errorBuilder: (context, obj, st){
                      return Widgets().noProfileContainer(
                        name: SharedPreference.getUser()!.firstName[0]+
                            SharedPreference.getUser()!.lastName[0],
                      );
                    },
                  ) : Widgets().noProfileContainer(
                    name: SharedPreference.getUser()!.firstName[0]+
                        SharedPreference.getUser()!.lastName[0],
                  ),
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
                },
                title: const Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if(SharedPreference.isLogin())
                if(SharedPreference.getUser()!.type == "merchant")
                  ListTile(
                    leading: const Icon(Icons.people, color: Colors.black,),
                    style: ListTileStyle.drawer,
                    horizontalTitleGap: 0,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AppUsersScreen())).then((value) {
                        getBusinessUserList();
                      });
                    },
                    title: const Text(
                      "Users",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ListTile(
                leading: const Icon(Icons.dashboard, color: Colors.black,),
                style: ListTileStyle.drawer,
                horizontalTitleGap: 0,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen(isFromManagerDashboard: true,))).then((value){
                    showProgress = true;
                    setState(() {});
                    getProjectList();
                  });
                },
                title: const Text(
                  "My tasks",
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
              getProjectList();
              getBusinessUserList();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: projectList.isEmpty ? [
                  SizedBox(height: MediaQuery.of(context).size.height - 100,child: const Center(child: Text("Sorry no record available,"))),
                ] : [
                  const SizedBox(height: 25,),
                  for(int i = 0; i < projectList.length; i++)
                    ProjectCard(
                      project: projectList[i],
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailScreen(projectData: projectList[i], businessUserList: businessUserList,)));
                      },
                      onSelected: (option) async {
                        switch (option) {
                          case 'Update':
                            projectNameController.text = projectList[i]["name"].toString();
                            projectDescriptionController.text = projectList[i]["description"].toString();
                            selectedUserIndex = null;List<dynamic> teamList = projectList[i]["team"].toList();
                            editCreateProjectModal(
                              manager: projectList[i]["manager"],
                              teamList: teamList,
                              isUpdate: true,
                              projectId: projectList[i]["id"].toString(),
                              time: double.parse(projectList[i]["estimate_time"].toString()),
                            );
                            break;
                            case 'Delete':
                              CommonFunctions().showConfirmationDialog(
                                confirmationMessage: "Are you sure to delete this project.",
                                confirmButtonText: "Delete",
                                cancelButtonText: "Cancel",
                                context: context,
                                onConfirm: ()async{
                                  showProgress = true;
                                  setState(() {});
                                  Navigator.pop(context);
                                  var response = await ServiceApis().deleteProject(projectId: projectList[i]["id"].toString());
                                  var data = jsonDecode(response.body);
                                  if(!mounted) return;
                                  if(response.statusCode == 204){
                                    await getProjectList();
                                    if(!mounted) return;
                                    CommonFunctions().showAlertDialog(alertMessage: "Project deleted successfully", context: context);
                                  }else{
                                    showProgress = true;
                                    setState(() {});
                                    CommonFunctions().showError(data: data, context: context);
                                  }
                                },
                              );
                              break;
                              default:
                                break;
                        }
                        printMessage("-- $option --");
                      },
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25,),
                    //   decoration: BoxDecoration(
                    //     color: kPrimaryColor,
                    //     borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(
                    //       color: projectList[i]["status"] == "active" ?
                    //       Colors.green.withOpacity(0.7) : projectList[i]["status"] == "in-progress" ?
                    //       Colors.amber.withOpacity(0.7) : projectList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.7) : Colors.white,
                    //       width: 1.5,
                    //     ),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: projectList[i]["status"] == "active" ?
                    //         Colors.green.withOpacity(0.3) : projectList[i]["status"] == "in-progress" ?
                    //         Colors.amber.withOpacity(0.3) : projectList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.3),
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
                    //         Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectDetailScreen(projectData: projectList[i], businessUserList: businessUserList,)));
                    //       },
                    //       minVerticalPadding: 0,
                    //       contentPadding: const EdgeInsets.only(left:16, right: 16, top: 0, bottom: 10),
                    //       splashColor: projectList[i]["status"] == "active" ?
                    //       Colors.green.withOpacity(0.1) : projectList[i]["status"] == "in-progress" ?
                    //       Colors.amber.withOpacity(0.1) : projectList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                    //       hoverColor: projectList[i]["status"] == "active" ?
                    //       Colors.green.withOpacity(0.1) : projectList[i]["status"] == "in-progress" ?
                    //       Colors.amber.withOpacity(0.1) : projectList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                    //       title: Column(
                    //         children: [
                    //           Container(
                    //             width: 160,
                    //             height: 8,
                    //             decoration: BoxDecoration(
                    //               color: projectList[i]["status"] == "active" ?
                    //               Colors.green : projectList[i]["status"] == "in-progress" ?
                    //               Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                    //               borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    //             ),
                    //           ),
                    //           const SizedBox(height: 10,),
                    //           Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.end,
                    //                 children: [
                    //                   if(projectList[i]["name"].isNotEmpty)
                    //                     Expanded(
                    //                       child: Text(
                    //                         projectList[i]["name"],
                    //                         style: TextStyle(
                    //                           fontSize: 20,
                    //                           fontWeight: FontWeight.bold,
                    //                           color: projectList[i]["status"] == "active" ?
                    //                           Colors.green : projectList[i]["status"] == "in-progress" ?
                    //                           Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   if(SharedPreference.isLogin())
                    //                     if(SharedPreference.getUser()!.type == "merchant")
                    //                       PopupMenuButton<String>(
                    //                         surfaceTintColor: projectList[i]["status"] == "active" ?
                    //                         Colors.green[200] : projectList[i]["status"] == "in-progress" ?
                    //                         Colors.amber[200] : projectList[i]["status"] == "completed" ? Colors.blue[200] : Colors.white,
                    //                           shadowColor: projectList[i]["status"] == "active" ?
                    //                           Colors.green : projectList[i]["status"] == "in-progress" ?
                    //                           Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                    //                           elevation: 1,
                    //                           shape: RoundedRectangleBorder(
                    //                             borderRadius: BorderRadius.circular(10),
                    //                             side: BorderSide(
                    //                               color: projectList[i]["status"] == "active" ?
                    //                               Colors.green : projectList[i]["status"] == "in-progress" ?
                    //                               Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                    //                             ),
                    //                           ),
                    //                           onSelected: (option) async {
                    //                             switch (option) {
                    //                               case 'Update':
                    //                                 projectNameController.text = projectList[i]["name"].toString();
                    //                                 projectDescriptionController.text = projectList[i]["description"].toString();
                    //                                 selectedUserIndex = null;
                    //                                 List<dynamic> teamList = projectList[i]["team"].toList();
                    //                                 editCreateProjectModal(
                    //                                   manager: projectList[i]["manager"],
                    //                                   teamList: teamList,
                    //                                   isUpdate: true,
                    //                                   projectId: projectList[i]["id"].toString(),
                    //                                   time: double.parse(projectList[i]["estimate_time"].toString()),
                    //                                 );
                    //                                 break;
                    //                               case 'Delete':
                    //                                 CommonFunctions().showConfirmationDialog(
                    //                                   confirmationMessage: "Are you sure to delete this project.",
                    //                                   confirmButtonText: "Delete",
                    //                                   cancelButtonText: "Cancel",
                    //                                   context: context,
                    //                                   onConfirm: ()async{
                    //                                     showProgress = true;
                    //                                     setState(() {});
                    //                                     Navigator.pop(context);
                    //                                     var response = await ServiceApis().deleteProject(projectId: projectList[i]["id"].toString());
                    //                                     var data = jsonDecode(response.body);
                    //                                     if(!mounted) return;
                    //                                     if(response.statusCode == 204){
                    //                                       await getProjectList();
                    //                                       if(!mounted) return;
                    //                                       CommonFunctions().showAlertDialog(alertMessage: "Project deleted successfully", context: context);
                    //                                     }else{
                    //                                       showProgress = true;
                    //                                       setState(() {});
                    //                                       CommonFunctions().showError(data: data, context: context);
                    //                                     }
                    //                                   },
                    //                                 );
                    //                                 break;
                    //                               default:
                    //                                 break;
                    //                             }
                    //                             printMessage("-- $option --");
                    //                           },
                    //                           icon: Icon(
                    //                             Icons.more_horiz,
                    //                             color: projectList[i]["status"] == "active" ?
                    //                             Colors.green : projectList[i]["status"] == "in-progress" ?
                    //                             Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                    //                             size: 30,
                    //                           ),
                    //                           splashRadius: 1,
                    //                           tooltip: "Options",
                    //                           padding: const EdgeInsets.all(0),
                    //                           itemBuilder: (BuildContext context) {
                    //                             return ["Update", "Delete"].map((String choice) {
                    //                               return PopupMenuItem<String>(
                    //                                 value: choice,
                    //                                 child: Text(
                    //                                   choice,
                    //                                   style: TextStyle(
                    //                                     color: projectList[i]["status"] == "active" ?
                    //                                     Colors.green : projectList[i]["status"] == "in-progress" ?
                    //                                     Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                    //                                     fontSize: 18,
                    //                                   ),
                    //                                 ),
                    //                               );
                    //                             }).toList();
                    //                           }),
                    //                 ],
                    //               ),
                    //               if(projectList[i]["description"].isNotEmpty)
                    //                 Text(
                    //                   projectList[i]["description"],
                    //                   maxLines: 2,
                    //                   overflow: TextOverflow.ellipsis,
                    //                   style: const TextStyle(
                    //                     fontSize: 18,
                    //                     // fontWeight: FontWeight.w400,
                    //                   ),
                    //                 ),
                    //               const SizedBox(height: 10,),
                    //               const Text(
                    //                 "Manager",
                    //                 style: TextStyle(
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 15,
                    //                 ),
                    //               ),
                    //               const SizedBox(height: 5,),
                    //               Row(
                    //                 children: [
                    //                   Container(
                    //                     width: 40,
                    //                     height: 40,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.circular(20),
                    //                       border: Border.all(color: Colors.grey),
                    //                       color: kPrimaryColor,
                    //                     ),
                    //                     child: ClipRRect(
                    //                       borderRadius: BorderRadius.circular(20),
                    //                       child: projectList[i]["manager"]["photo"] == null ? Widgets().noProfileContainer(
                    //                         name: projectList[i]["manager"]["first_name"][0]+
                    //                             projectList[i]["manager"]["last_name"][0],
                    //                       ) : projectList[i]["manager"]["photo"].isNotEmpty ?
                    //                       Image.network(
                    //                         projectList[i]["manager"]["photo"],
                    //                         width: 40,
                    //                         height: 40,
                    //                         fit: BoxFit.cover,
                    //                         loadingBuilder: (context, child, loadingProgress){
                    //                           if(loadingProgress != null){
                    //                             return const Center(
                    //                               child: CircularProgressIndicator(
                    //                                 color: kThemeColor,
                    //                                 strokeWidth: 3,
                    //                               ),
                    //                             );
                    //                           }else{
                    //                             return child;
                    //                           }
                    //                         },
                    //                         errorBuilder: (context, obj, st){
                    //                           return Widgets().noProfileContainer(
                    //                             name: projectList[i]["manager"]["first_name"][0]+
                    //                                 projectList[i]["manager"]["last_name"][0],
                    //                           );
                    //                         },
                    //                       ) : Widgets().noProfileContainer(
                    //                         name: projectList[i]["manager"]["first_name"][0]+
                    //                             projectList[i]["manager"]["last_name"][0],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   const SizedBox(width: 10,),
                    //                   Expanded(
                    //                     child: Column(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         Text(
                    //                           "${projectList[i]["manager"]["first_name"]} ${projectList[i]["manager"]["last_name"]}",
                    //                           style: const TextStyle(
                    //                             fontSize: 16,
                    //                             height: 1.2,
                    //                             fontWeight: FontWeight.bold,
                    //                           ),
                    //                         ),
                    //                         Text(
                    //                           "${projectList[i]["manager"]["email"]}",
                    //                           style: const TextStyle(
                    //                             fontSize: 14,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               const SizedBox(height: 10,),
                    //               Text(
                    //                 DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(projectList[i]["created_at"])),
                    //                 style: const TextStyle(
                    //                   fontWeight: FontWeight.w500,
                    //                   fontSize: 16,
                    //                   fontStyle: FontStyle.italic,
                    //                 ),
                    //               ),
                    //               const Divider(
                    //                 color: Colors.grey,
                    //               ),
                    //               Row(
                    //                 crossAxisAlignment: CrossAxisAlignment.center,
                    //                 children: [
                    //                   Expanded(
                    //                     child: SizedBox(
                    //                       height: 68,
                    //                       child: Column(
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         mainAxisAlignment: MainAxisAlignment.center,
                    //                         children: [
                    //                           const Text(
                    //                             "Team",
                    //                             style: TextStyle(
                    //                               fontWeight: FontWeight.w500,
                    //                               fontSize: 15,
                    //                             ),
                    //                           ),
                    //                           if(projectList[i]["team"].isNotEmpty)
                    //                             Padding(
                    //                               padding: const EdgeInsets.only(top: 5.0),
                    //                               child: Row(
                    //                                 children: [
                    //                                   Expanded(
                    //                                     child: SingleChildScrollView(
                    //                                       scrollDirection: Axis.horizontal,
                    //                                       child: Stack(
                    //                                         children: [
                    //                                           SizedBox(
                    //                                             height: 40,
                    //                                             width: (projectList[i]["team"].length * 27)+ 8.0,
                    //                                           ),
                    //                                           for(int j = 0; j < projectList[i]["team"].length; j++)
                    //                                             Positioned(
                    //                                               left: j * 27,
                    //                                               child: Container(
                    //                                                 width: 35,
                    //                                                 height: 35,
                    //                                                 decoration: BoxDecoration(
                    //                                                   borderRadius: BorderRadius.circular(20),
                    //                                                   border: Border.all(color: Colors.grey),
                    //                                                   color: kPrimaryColor,
                    //                                                 ),
                    //                                                 child: ClipRRect(
                    //                                                   borderRadius: BorderRadius.circular(20),
                    //                                                   child: projectList[i]["team"][j]["photo"] == null ? Widgets().noProfileContainer(
                    //                                                     name: projectList[i]["team"][j]["first_name"][0]+
                    //                                                         projectList[i]["team"][j]["last_name"][0],
                    //                                                   ) : projectList[i]["team"][j]["photo"].isNotEmpty ?
                    //                                                   Image.network(
                    //                                                     projectList[i]["team"][j]["photo"],
                    //                                                     width: 40,
                    //                                                     height: 40,
                    //                                                     fit: BoxFit.cover,
                    //                                                     loadingBuilder: (context, child, loadingProgress){
                    //                                                       if(loadingProgress != null){
                    //                                                         return const Center(
                    //                                                           child: CircularProgressIndicator(
                    //                                                             color: kThemeColor,
                    //                                                             strokeWidth: 3,
                    //                                                           ),
                    //                                                         );
                    //                                                       }else{
                    //                                                         return child;
                    //                                                       }
                    //                                                     },
                    //                                                     errorBuilder: (context, obj, st){
                    //                                                       return Widgets().noProfileContainer(
                    //                                                         name: projectList[i]["team"][j]["first_name"][0]+
                    //                                                             projectList[i]["team"][j]["last_name"][0],
                    //                                                       );
                    //                                                     },
                    //                                                   ) : Widgets().noProfileContainer(
                    //                                                     name: projectList[i]["team"][j]["first_name"][0]+
                    //                                                         projectList[i]["team"][j]["last_name"][0],
                    //                                                   ),
                    //                                                 ),
                    //                                               ),
                    //                                             ),
                    //                                         ],
                    //                                       ),
                    //                                     ),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             )
                    //                           else
                    //                             const Text("No team added."),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   SizedBox(
                    //                     height: 68,
                    //                     child: Column(
                    //                       mainAxisAlignment: MainAxisAlignment.center,
                    //                       crossAxisAlignment: CrossAxisAlignment.end,
                    //                       children: [
                    //                         const Text(
                    //                           "Status",
                    //                           style: TextStyle(
                    //                             fontWeight: FontWeight.w500,
                    //                             fontSize: 15,
                    //                           ),
                    //                         ),
                    //                         Text(
                    //                           projectList[i]["status"] == "active" ?
                    //                           "Active" : projectList[i]["status"] == "in-progress" ?
                    //                           "In-progress" : projectList[i]["status"] == "completed" ? "Completed" : "",
                    //                           style: TextStyle(
                    //                             fontSize: 20,
                    //                             height: 1,
                    //                             fontWeight: FontWeight.bold,
                    //                             color: projectList[i]["status"] == "active" ?
                    //                             Colors.green : projectList[i]["status"] == "in-progress" ?
                    //                             Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.black,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               const SizedBox(height: 10,),
                    //               Row(
                    //                 children: [
                    //                   Expanded(
                    //                     child: Column(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         const Text(
                    //                           "Total time",
                    //                           style: TextStyle(
                    //                             // fontSize: 16,
                    //                             fontWeight: FontWeight.w500,
                    //                           ),
                    //                         ),
                    //                         Text(
                    //                           "${(double.parse(projectList[i]["total_time_hr"].toString())).abs().floor()} hour ${((double.parse(projectList[i]["total_time_hr"].toString())*60.0)%60.0).abs().round()} min",
                    //                           style: const TextStyle(
                    //                             fontSize: 16,
                    //                             fontWeight: FontWeight.w500,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   const SizedBox(width: 10,),
                    //                   Expanded(
                    //                     child: Column(
                    //                       crossAxisAlignment: CrossAxisAlignment.start,
                    //                       children: [
                    //                         const Text(
                    //                           "Estimated time",
                    //                           style: TextStyle(
                    //                             // fontSize: 16,
                    //                             fontWeight: FontWeight.w500,
                    //                           ),
                    //                         ),
                    //                         Text(
                    //                           "${(double.parse(projectList[i]["estimate_time"].toString())).abs().floor()} hour ${((double.parse(projectList[i]["estimate_time"].toString())*60.0)%60.0).abs().round()} min",
                    //                           style: const TextStyle(
                    //                             fontSize: 16,
                    //                             fontWeight: FontWeight.w500,
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               Container(
                    //                 margin: const EdgeInsets.only(top: 20, bottom: 5),
                    //                 height: 8,
                    //                 decoration: const BoxDecoration(
                    //                   borderRadius: BorderRadius.all(Radius.circular(10)),
                    //                   color: Colors.white,
                    //                 ),
                    //                 child: ClipRRect(
                    //                   borderRadius: const BorderRadius.all(Radius.circular(10)),
                    //                   child: LinearProgressIndicator(
                    //                     value: double.parse(projectList[i]["total_time_hr"].toString())/double.parse(projectList[i]["estimate_time"].toString()),
                    //                     minHeight: 8,
                    //                     valueColor: AlwaysStoppedAnimation<Color>(
                    //                       projectList[i]["status"] == "active" ?
                    //                       Colors.green : projectList[i]["status"] == "in-progress" ?
                    //                       Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : kThemeColor,
                    //                     ),
                    //                     backgroundColor: projectList[i]["status"] == "active" ?
                    //                     Colors.green.withOpacity(0.3) : projectList[i]["status"] == "in-progress" ?
                    //                     Colors.amber.withOpacity(0.3) : projectList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.3) : kThemeColor.withOpacity(0.3),
                    //                   ),
                    //                 ),
                    //               ),
                    //               Row(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   const Text(
                    //                     "Completed",
                    //                   ),
                    //                   Text(
                    //                     "${double.parse((double.parse(projectList[i]["total_time_hr"].toString())/
                    //                         double.parse(projectList[i]["estimate_time"].
                    //                         toString())
                    //                         * 100).toString()).toStringAsFixed(2)
                    //                     } %",
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //       tileColor: projectList[i]["status"] == "active" ?
                    //       Colors.green.withOpacity(0.06) : projectList[i]["status"] == "in-progress" ?
                    //       Colors.yellow.withOpacity(0.06) : projectList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.06) : Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       dense: true,
                    //     ),
                    //   ),
                    // ),
                  const SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SharedPreference.isLogin() ? SharedPreference.getUser()!.type == "merchant" ? FloatingActionButton(
        onPressed: (){
          projectNameController.text = "";
          projectDescriptionController.text = "";
          selectedUserIndex = null;
          editCreateProjectModal();
        },
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ) : const Center() : const Center(),
    );
  }

  void editCreateProjectModal({dynamic manager, List<dynamic>? teamList, bool isUpdate = false, String? projectId, double? time}){
    List<dynamic> selectedUserList = teamList ?? [];
    dynamic selectedManager = manager;
    double estimatedTime = time ?? 0.0;
    if(time != null) {
      hourController.text = time.abs().floor().toString();
      minuteController.text = ((time*60.0)%60.0).abs().round().toString();
    }else{
      hourController.text = "0";
      minuteController.text = "0";
    }
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      context: context, builder: (_) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Stack(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                constraints: const BoxConstraints(
                  maxHeight: 450,
                  maxWidth: 450,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                    )
                  ]
                ),
                child: StatefulBuilder(
                    builder: (_, addProjectState) {
                      return Column(
                          children: [
                            const SizedBox(height: 15,),
                            const Text(
                              "Add Project",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Widgets().textFormField(
                                        maxWidth: 450,
                                        controller: projectNameController,
                                        labelText: "Enter project name",

                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                                      child: Widgets().textFormField(
                                        maxLines: 3,
                                        maxWidth: 450,
                                        controller: projectDescriptionController,
                                        labelText: "Enter project description",
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  " Hours",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                                Widgets().textFormField(
                                                  controller: hourController,
                                                  labelText: "hours",
                                                  keyboardType: TextInputType.number,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  " Minutes",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10,),
                                                Widgets().textFormField(
                                                  controller: minuteController,
                                                  labelText: "minutes",
                                                  keyboardType: TextInputType.number,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                                      child: Text(
                                        "Manager",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                                      child: Container(
                                        padding: EdgeInsets.all(selectedManager != null ? 0 : 15),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.4),
                                                blurRadius: 6,
                                              ),
                                            ]
                                        ),
                                        child: PopupMenuButton<String>(
                                          // padding: EdgeInsets.only(right: 50),
                                          constraints: const BoxConstraints(
                                            maxHeight: 350,
                                          ),
                                          onSelected: (newValue){
                                            if(newValue == "No manager"){
                                              printMessage("no manager found in organization.");
                                              CommonFunctions().showAlertDialog(alertMessage: "No manager found in organization please try give someone manager role first.", context: context);
                                            }else {
                                              selectedManager =
                                              managerList[int.parse(newValue)];
                                              setState(() {});
                                              addProjectState(() {});
                                            }
                                          },
                                          splashRadius: 1,
                                          tooltip: "select manager",
                                          itemBuilder: (BuildContext context) {
                                            List<PopupMenuEntry<String>> l = [];
                                            if(managerList.isNotEmpty) {
                                              for (int i = 0; i <
                                                  managerList.length; i++) {
                                                l.add(PopupMenuItem<String>(
                                                  value: i.toString(),
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    padding: const EdgeInsets
                                                        .all(10),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(10),
                                                      border: Border.all(
                                                        color: Colors.black,),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 55,
                                                          height: 55,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(40),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            color: kPrimaryColor,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius
                                                                .circular(40),
                                                            child: managerList[i]["photo"] ==
                                                                null
                                                                ? Image.asset(
                                                              "assets/images/profile.png",
                                                              width: 80,
                                                              height: 80,)
                                                                : managerList[i]["photo"]
                                                                .isNotEmpty
                                                                ? Image.network(
                                                              managerList[i]["photo"],
                                                              width: 80,
                                                              height: 80,
                                                              fit: BoxFit.cover,
                                                              loadingBuilder: (
                                                                  context,
                                                                  child,
                                                                  loadingProgress) {
                                                                if (loadingProgress !=
                                                                    null) {
                                                                  return const Center(
                                                                    child: CircularProgressIndicator(
                                                                      color: kThemeColor,
                                                                      strokeWidth: 3,
                                                                    ),
                                                                  );
                                                                } else {
                                                                  return child;
                                                                }
                                                              },
                                                              errorBuilder: (
                                                                  context, obj,
                                                                  st) {
                                                                return Image
                                                                    .asset(
                                                                  "assets/images/profile.png",
                                                                  width: 100,
                                                                  height: 100,);
                                                              },
                                                            )
                                                                : Image.asset(
                                                              "assets/images/profile.png",
                                                              width: 80,
                                                              height: 80,),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text(
                                                                managerList[i]["type"],
                                                                style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "${managerList[i]["first_name"]} ",
                                                                  style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight: FontWeight
                                                                        .bold,
                                                                    fontSize: 18,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: managerList[i]["last_name"],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Text(
                                                                managerList[i]["email"],
                                                                maxLines: 1,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                              }
                                            }else{
                                              l.add(PopupMenuItem<String>(
                                                value: "No manager",
                                                child: Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  padding: const EdgeInsets
                                                      .all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(10),
                                                    border: Border.all(
                                                      color: Colors.black,),
                                                  ),
                                                  child: Row(
                                                    children: const [
                                                      Text(
                                                        "No manager found in organization.",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                            }
                                            return l;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              if(selectedManager != null)
                                                Expanded(
                                                  child: Container(
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Colors.black,),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 55,
                                                          height: 55,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(40),
                                                            border: Border.all(color: Colors.grey),
                                                            color: kPrimaryColor,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(40),
                                                            child: selectedManager["photo"] == null ? Image.asset("assets/images/profile.png", width: 80, height: 80,) : selectedManager["photo"].isNotEmpty ? Image.network(
                                                              selectedManager["photo"],
                                                              width: 80,
                                                              height: 80,
                                                              fit: BoxFit.cover,
                                                              loadingBuilder: (context, child, loadingProgress){
                                                                if(loadingProgress != null){
                                                                  return const Center(
                                                                    child: CircularProgressIndicator(
                                                                      color: kThemeColor,
                                                                      strokeWidth: 3,
                                                                    ),
                                                                  );
                                                                }else{
                                                                  return child;
                                                                }
                                                              },
                                                              errorBuilder: (context, obj, st){
                                                                return Image.asset("assets/images/profile.png", width: 100, height: 100,);
                                                              },
                                                            ) : Image.asset("assets/images/profile.png", width: 80, height: 80,),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 10,),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "${selectedManager["first_name"]} ",
                                                                  style: const TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 18,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: selectedManager["last_name"],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(height: 3,),
                                                              Text(
                                                                selectedManager["phone"],
                                                                style: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                              Text(
                                                                selectedManager["email"],
                                                                maxLines: 1,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              else const Expanded(
                                                child: Text(
                                                  "select manager",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                                      child: Text(
                                        "Team",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    if(selectedUserList.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Stack(
                                                  children: [
                                                    SizedBox(
                                                      height: 100,
                                                      width: selectedUserList.length * 45 + 10,
                                                    ),
                                                    for(int i = 0; i < selectedUserList.length; i++)
                                                      Positioned(
                                                        left: i * 45,
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(height: 15,),
                                                            Container(
                                                              width: 55,
                                                              height: 55,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(40),
                                                                border: Border.all(color: Colors.grey),
                                                                color: kPrimaryColor,
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(40),
                                                                child: selectedUserList[i]["photo"] == null ? Widgets().noProfileContainer(
                                                                  name: selectedUserList[i]["first_name"][0]+
                                                                      selectedUserList[i]["last_name"][0],
                                                                ) : selectedUserList[i]["photo"].isNotEmpty ? Image.network(
                                                                  selectedUserList[i]["photo"],
                                                                  width: 80,
                                                                  height: 80,
                                                                  fit: BoxFit.cover,
                                                                  loadingBuilder: (context, child, loadingProgress){
                                                                    if(loadingProgress != null){
                                                                      return const Center(
                                                                        child: CircularProgressIndicator(
                                                                          color: kThemeColor,
                                                                          strokeWidth: 3,
                                                                        ),
                                                                      );
                                                                    }else{
                                                                      return child;
                                                                    }
                                                                  },
                                                                  errorBuilder: (context, obj, st){
                                                                    return Widgets().noProfileContainer(
                                                                      name: selectedUserList[i]["first_name"][0]+
                                                                          selectedUserList[i]["last_name"][0],
                                                                    );
                                                                  },
                                                                ) : Widgets().noProfileContainer(
                                                                  name: selectedUserList[i]["first_name"][0]+
                                                                      selectedUserList[i]["last_name"][0],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 5,),
                                                            GestureDetector(
                                                              onTap: (){
                                                                selectedUserList.removeAt(i);
                                                                addProjectState((){});
                                                              },
                                                              child: const Icon(Icons.cancel_outlined,),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 14, top: 3, bottom: 3, right: 0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.4),
                                                blurRadius: 6,
                                              ),
                                            ]
                                        ),
                                        child: PopupMenuButton<String>(
                                          // padding: EdgeInsets.only(right: 50),
                                          constraints: const BoxConstraints(
                                            maxHeight: 350,
                                          ),
                                          onSelected: (newValue){
                                            selectedUserIndex = businessUserList.indexWhere((element) => element["id"].toString() == newValue);
                                            setState(() {});
                                            addProjectState((){});
                                          },
                                          splashRadius: 1,
                                          tooltip: "Add team",
                                          itemBuilder: (BuildContext context) {
                                            List<PopupMenuEntry<String>> l = [];
                                            for(int i = 0; i < businessUserList.length; i++){
                                              l.add(PopupMenuItem<String>(
                                                value: businessUserList[i]["id"].toString(),
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: Colors.black,),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 55,
                                                        height: 55,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(40),
                                                          border: Border.all(color: Colors.grey),
                                                          color: kPrimaryColor,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(40),
                                                          child: businessUserList[i]["photo"] == null ? Image.asset("assets/images/profile.png", width: 100, height: 100,) : businessUserList[i]["photo"].isNotEmpty ? Image.network(
                                                            businessUserList[i]["photo"],
                                                            width: 80,
                                                            height: 80,
                                                            fit: BoxFit.cover,
                                                            loadingBuilder: (context, child, loadingProgress){
                                                              if(loadingProgress != null){
                                                                return const Center(
                                                                  child: CircularProgressIndicator(
                                                                    color: kThemeColor,
                                                                    strokeWidth: 3,
                                                                  ),
                                                                );
                                                              }else{
                                                                return child;
                                                              }
                                                            },
                                                            errorBuilder: (context, obj, st){
                                                              return Image.asset("assets/images/profile.png", width: 100, height: 100,);
                                                            },
                                                          ) : Image.asset("assets/images/profile.png", width: 80, height: 80,),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              businessUserList[i]["type"],
                                                              style: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text: "${businessUserList[i]["first_name"]} ",
                                                                style: const TextStyle(
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 18,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: businessUserList[i]["last_name"],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // const SizedBox(height: 3,),
                                                            // Text(
                                                            //   businessUserList[i]["phone"],
                                                            //   style: const TextStyle(
                                                            //     color: Colors.black,
                                                            //     fontSize: 14,
                                                            //   ),
                                                            // ),
                                                            Text(
                                                              businessUserList[i]["email"],
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                            }
                                            return l;
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              if(selectedUserIndex != null)
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: "${businessUserList[selectedUserIndex!]["first_name"]} ",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: businessUserList[selectedUserIndex!]["last_name"],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              else const Expanded(
                                                child: Text(
                                                  "add team",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              Widgets().textButton(
                                                onPressed: (){
                                                  if(selectedUserIndex != null){
                                                    if(selectedUserList.where((element) => element["id"].toString() == businessUserList[selectedUserIndex!]["id"].toString()).toList().isEmpty) {
                                                      selectedUserList.add(
                                                          businessUserList[selectedUserIndex!]);
                                                      setState(() {});
                                                      addProjectState(() {});
                                                    }else{
                                                      CommonFunctions().showAlertDialog(alertMessage: "Developer already added to team.", context: context);
                                                    }
                                                  }
                                                },
                                                text: "Add",
                                                elevation: 0,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16
                                                ),
                                                backgroundColor: Colors.transparent,
                                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Widgets().textButton(
                                      onPressed: () async{
                                        if (projectNameController.text.isEmpty) {
                                          CommonFunctions().showAlertDialog(
                                            alertMessage: "Project name can not be empty.",
                                            context: context,
                                          );
                                        } else if(selectedManager == null){
                                          CommonFunctions().showAlertDialog(
                                            alertMessage: "Project must have assigned to manager.",
                                            context: context,
                                          );
                                        }else {
                                          if(hourController.text.isNotEmpty){
                                            estimatedTime = double.parse(hourController.text);
                                          }
                                          if(minuteController.text.isNotEmpty){
                                            estimatedTime = estimatedTime + (double.parse(minuteController.text)/60.0);
                                          }
                                          showProgress = true;
                                          setState(() {});
                                          Navigator.pop(context);
                                          dynamic response;
                                          if(isUpdate){
                                            response = await ServiceApis().updateProject(
                                              estimatedTime: estimatedTime,
                                              managerId: selectedManager["id"],
                                              projectId: projectId ?? "",
                                              projectName: projectNameController.text,
                                              projectDescription: projectDescriptionController.text,
                                              team: selectedUserList.map((e) => e["id"].toString()).toList(),
                                            );
                                            var data = jsonDecode(response.body);
                                            if(!mounted) return;
                                            if (response.statusCode == 200) {
                                              getProjectList();
                                            } else {
                                              showProgress = false;
                                              setState(() {});
                                              CommonFunctions().showError(data: data, context: context);
                                            }
                                          }else {
                                            response = await ServiceApis().createProject(
                                              estimatedTime: estimatedTime,
                                              projectName: projectNameController.text,
                                              projectDescription: projectDescriptionController.text,
                                              team: selectedUserList.map((e) => e["id"].toString()).toList(),
                                              managerId: selectedManager["id"],
                                            );
                                            var data = jsonDecode(response.body);
                                            if(!mounted) return;
                                            if (response.statusCode == 201) {
                                              getProjectList();
                                            } else {
                                              showProgress = false;
                                              setState(() {});
                                              CommonFunctions().showError(data: data, context: context);
                                            }
                                          }
                                        }
                                      },
                                      text: isUpdate ? "Update" : "Create project",
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      );
    },
    );
  }

}
