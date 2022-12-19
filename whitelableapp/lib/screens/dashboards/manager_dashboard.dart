
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/screens/contact_us.dart';
import 'package:whitelabelapp/screens/login.dart';
import 'package:whitelabelapp/screens/settings.dart';
import 'package:whitelabelapp/screens/terms_and_condition.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';
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
  int? selectedUserIndex;

  TextEditingController projectNameController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
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
      if (response.statusCode == 200) {
        projectList = data;
        showProgress = false;
        setState(() {});
      } else {
        showProgress = false;
        setState(() {});
        Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context);
      }
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  Future<void> getBusinessUserList()async{
    await Future.delayed(const Duration(seconds: 0));
    if(SharedPreference.isLogin()) {
      var response = await ServiceApis().getBusinessStaffList();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        businessUserList = data;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [
        //     kThemeColor,
        //     Colors.white,
        //   ],
        // ),
      ),
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(SharedPreference.getBusinessConfig()!.appName),
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
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.black,),
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
                  },
                  title: Text(
                    getTranslated(context, ["menu", "settings"]),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.my_library_books_rounded, color: Colors.black,),
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsAndConditionScreen()));
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUsScreen()));
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
                              Widgets().showConfirmationDialog(
                                confirmationMessage: getTranslated(context, ["settingScreen", "logoutMessage"]),
                                confirmButtonText: getTranslated(context, ["settingScreen", "confirm"]),
                                cancelButtonText: getTranslated(context, ["settingScreen", "cancel"]),
                                context: context,
                                onConfirm: ()async{
                                  showProgress = true;
                                  setState(() {});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  await ServiceApis().userLogOut();
                                  showProgress = false;
                                  setState(() {});
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                                },
                              );
                            }else{
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                text: "Login",
              ),
            ) : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15,),
                  for(int i = 0; i < projectList.length; i++)
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15,),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Material(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: ListTile(
                          onTap: (){

                          },
                          contentPadding: const EdgeInsets.only(left:0, right: 16, top: 10, bottom: 10),
                          splashColor: projectList[i]["status"] == "active" ?
                          Colors.green.withOpacity(0.1) : projectList[i]["status"] == "in-progress" ?
                          Colors.amber.withOpacity(0.1) : projectList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                          hoverColor: projectList[i]["status"] == "active" ?
                          Colors.green.withOpacity(0.1) : projectList[i]["status"] == "in-progress" ?
                          Colors.amber.withOpacity(0.1) : projectList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                          title: Row(
                            children: [
                              Container(
                                width: 7,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: projectList[i]["status"] == "active" ?
                                  Colors.green : projectList[i]["status"] == "in-progress" ?
                                  Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                              ),
                              const SizedBox(width: 16,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(projectList[i]["name"].isNotEmpty)
                                      Text(
                                        projectList[i]["name"],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    if(projectList[i]["description"].isNotEmpty)
                                      Text(
                                        projectList[i]["description"],
                                        style: const TextStyle(
                                          fontSize: 17,
                                          // fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    Text(
                                      DateFormat("dd MM yyyy hh:mm a").format(DateTime.parse(projectList[i]["created_at"])),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        height: 2,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Team",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const SizedBox(height: 5,),
                                              if(projectList[i]["team"].isNotEmpty)
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: SingleChildScrollView(
                                                        scrollDirection: Axis.horizontal,
                                                        child: Stack(
                                                          children: [
                                                            SizedBox(
                                                              height: 40,
                                                              width: (projectList[i]["team"].length * 27)+ 8.0,
                                                            ),
                                                            for(int j = 0; j < projectList[i]["team"].length; j++)
                                                              Positioned(
                                                                left: j * 27,
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: 35,
                                                                      height: 35,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(20),
                                                                        border: Border.all(color: Colors.grey),
                                                                        color: kPrimaryColor,
                                                                      ),
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(20),
                                                                        child: businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList().isNotEmpty ?
                                                                        (businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList()[0]["photo"].isNotEmpty ?
                                                                        Image.network(
                                                                          businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList()[0]["photo"],
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
                                                                            return Image.asset("assets/images/profile.png", width: 40, height: 40,);
                                                                          },
                                                                        ) : Image.asset("assets/images/profile.png", width: 40, height: 40,)) : Image.asset("assets/images/profile.png", width: 40, height: 40,),
                                                                      ),
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
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 68,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                "Status",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                projectList[i]["status"] == "active" ?
                                                "Active" : projectList[i]["status"] == "in-progress" ?
                                                "In-progress" : projectList[i]["status"] == "completed" ? "Completed" : "",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  height: 1,
                                                  fontWeight: FontWeight.bold,
                                                  color: projectList[i]["status"] == "active" ?
                                                  Colors.green : projectList[i]["status"] == "in-progress" ?
                                                  Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          tileColor: projectList[i]["status"] == "active" ?
                          Colors.green.withOpacity(0.06) : projectList[i]["status"] == "in-progress" ?
                          Colors.yellow.withOpacity(0.06) : projectList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.06) : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            projectNameController.text = "";
            projectDescriptionController.text = "";
            selectedUserIndex = null;
            List<dynamic> selectedUserList = [];
            showModalBottomSheet(
              context: context, builder: (_) {
                return StatefulBuilder(
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
                                    controller: projectNameController,
                                    labelText: "Enter project name",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                                  child: Widgets().textFormField(
                                    controller: projectDescriptionController,
                                    labelText: "Enter project description",
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
                                                            child: selectedUserList[i]["photo"].isNotEmpty ? Image.network(
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
                                                                return Image.asset("assets/images/profile.png", width: 100, height: 100,);
                                                              },
                                                            ) : Image.asset("assets/images/profile.png", width: 80, height: 80,),
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
                                                      child: businessUserList[i]["photo"].isNotEmpty ? Image.network(
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
                                                        const SizedBox(height: 3,),
                                                        Text(
                                                          businessUserList[i]["phone"],
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
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
                                          // Text(
                                          //   "Add",
                                          //   style: TextStyle(
                                          //     fontSize: 16,
                                          //   ),
                                          // ),
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
                                    print("-----------${selectedUserList.map((e) => e["id"].toString()).toList()}------------");
                                    if(projectNameController.text.isEmpty){
                                      Widgets().showAlertDialog(
                                        alertMessage: "Project name can not be empty.",
                                        context: context,
                                      );
                                    }else{
                                      showProgress = true;
                                      setState(() {});
                                      Navigator.pop(context);
                                      var response = await ServiceApis().createProject(
                                        projectName: projectNameController.text,
                                        projectDescription: projectDescriptionController.text,
                                        team: selectedUserList.map((e) => e["id"].toString()).toList(),
                                      );
                                      if(response.statusCode == 201) {
                                        getProjectList();
                                      }else{
                                        showProgress = false;
                                        setState(() {});
                                        Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context);
                                      }
                                    }
                                  },
                                  text: "Create project",
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                    );
                  }
                );
              },
            );
          },
          child: const Icon(
            Icons.add,
            size: 28,
          ),
        ),
      ),
    );
  }
}
