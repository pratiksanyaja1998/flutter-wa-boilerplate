
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/screens/app_user_detail.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class AppUsersScreen extends StatefulWidget {
  const AppUsersScreen({Key? key}) : super(key: key);

  @override
  State<AppUsersScreen> createState() => _AppUsersScreenState();
}

class _AppUsersScreenState extends State<AppUsersScreen> {

  // List<dynamic> managerList = [];
  // List<dynamic> developerList = [];
  List<dynamic> staffList = [];
  List<dynamic> userList = [];
  List<String> roles = ["developer", "manager"];

  bool showManagerProgress = true;
  bool showDeveloperProgress = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getStaffList();
    getUserList();
    // getDeveloperList();
    super.initState();
  }

  Future<void> getStaffList()async{
    await Future.delayed(const Duration(seconds: 0));
    if(SharedPreference.isLogin()) {
      var response = await ServiceApis().getBusinessStaffList();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        staffList = data;
        // managerList = data.where((element) => element["type"] == "manager").toList();
        // developerList = data.where((element) => element["type"] == "developer").toList();
        showManagerProgress = false;
        // showDeveloperProgress = false;
        setState(() {});
      }
    }
  }

  Future<void> getUserList()async{
    await Future.delayed(const Duration(seconds: 0));
    if(SharedPreference.isLogin()) {
      var response = await ServiceApis().getAppUserList();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showDeveloperProgress = false;
        setState(() {});
        userList = data;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App users"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
            child: Widgets().textFormField(
              maxWidth: 450,
              controller: searchController,
              labelText: "Search",
              suffixIcon: Icons.search,
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                    decoration: BoxDecoration(
                      color: kThemeColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: TabBar(
                        labelStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          // decoration: TextDecoration.underline,
                          decorationThickness: 2,
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.white,
                        indicator: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        tabs: const [
                          Tab(
                            text: "Staff",
                          ),
                          Tab(
                            text: "Users",
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Expanded(
                    child: TabBarView(
                      children: [
                        RefreshIndicator(
                          onRefresh: ()async{
                            showManagerProgress = true;
                            setState(() {});
                            getStaffList();
                          },
                          child: showManagerProgress ? const Center(
                            child: CircularProgressIndicator(
                              color: kThemeColor,
                            ),
                          ) : SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                for(int i = 0; i < staffList.length; i++)
                                  Container(
                                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15,),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: kThemeColor.withOpacity(0.7),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: kThemeColor.withOpacity(0.3),
                                          blurRadius: 4,
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
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AppUserDetailScreen(userId: managerList[i]["id"])));
                                        },
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        splashColor: kThemeColor.withOpacity(0.1),
                                        hoverColor: kThemeColor.withOpacity(0.1),
                                        title: Row(
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
                                                child: staffList[i]["photo"] == null ? Image.asset("assets/images/profile.png", width: 80, height: 80,) : staffList[i]["photo"].isNotEmpty ? Image.network(
                                                  staffList[i]["photo"],
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
                                                    staffList[i]["type"],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: "${staffList[i]["first_name"]} ",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: staffList[i]["last_name"],
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
                                                    staffList[i]["email"],
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
                                            PopupMenuButton<String>(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                side: const BorderSide(
                                                  color: kThemeColor,
                                                ),
                                              ),
                                              onSelected: (option) async {
                                                showDialog(context: context, builder: (_){
                                                  return AlertDialog(
                                                    backgroundColor: Colors.transparent,
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    content: IntrinsicHeight(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: IntrinsicHeight(
                                                              child: Column(
                                                                children: [
                                                                  for(int j = 0; j < roles.length; j++)
                                                                    Column(
                                                                      children: [
                                                                        Material(
                                                                          elevation: 0,
                                                                          color: Colors.transparent,
                                                                          child: ListTile(
                                                                            leading: Text(
                                                                              "${roles[j][0].toUpperCase()}${roles[j].substring(1).toLowerCase()}",
                                                                              style: const TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            onTap: ()async{
                                                                              showManagerProgress = true;
                                                                              setState(() {});
                                                                              Navigator.pop(context);
                                                                              var response = await ServiceApis().changeUsrRole(
                                                                                userId: staffList[i]["id"],
                                                                                type: roles[j],
                                                                              );
                                                                              var data = jsonDecode(response.body);
                                                                              if(response.statusCode == 200){
                                                                                await getStaffList();
                                                                                Widgets().showAlertDialog(alertMessage: "Role changed successfully", context: context);
                                                                              }else{
                                                                                Widgets().showError(data: data, context: context);
                                                                                showManagerProgress = false;
                                                                                setState(() {});
                                                                              }
                                                                            },
                                                                            // tileColor: kPrimaryColor,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            dense: true,
                                                                            trailing: staffList[i]["type"] == roles[j] ? const Text(
                                                                              "✔",
                                                                              style: TextStyle(
                                                                                // fontWeight: FontWeight.bold,
                                                                                  fontSize: 18,
                                                                                  color: Colors.green
                                                                              ),
                                                                            ) : const SizedBox(),
                                                                          ),
                                                                        ),
                                                                        if(j < roles.length - 1)
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
                                                          const SizedBox(height: 15,),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: Material(
                                                              elevation: 0,
                                                              color: Colors.transparent,
                                                              child: ListTile(
                                                                leading: const Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onTap: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                // tileColor: kPrimaryColor,
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
                                                  );
                                                });
                                              },
                                              splashRadius: 1,
                                              tooltip: "Options",
                                              padding: const EdgeInsets.all(0),
                                              itemBuilder: (BuildContext context) {
                                                return ["Change Role"].map((String choice) {
                                                  return PopupMenuItem<String>(
                                                    value: choice,
                                                    child: Text(
                                                      choice,
                                                      style: const TextStyle(
                                                        // color: kThemeColor,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                              child: const SizedBox(
                                                width: 20,
                                                child: Icon(
                                                  Icons.more_vert,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        tileColor: kThemeColor.withOpacity(0.06),
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
                        RefreshIndicator(
                          onRefresh: ()async{
                            showDeveloperProgress = true;
                            setState(() {});
                            getUserList();
                          },
                          child: showDeveloperProgress ? const Center(
                            child: CircularProgressIndicator(
                              color: kThemeColor,
                            ),
                          ) : SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                for(int i = 0; i < userList.length; i++)
                                  Container(
                                    margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15,),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: kThemeColor.withOpacity(0.7),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: kThemeColor.withOpacity(0.3),
                                          blurRadius: 4,
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
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AppUserDetailScreen(userId: developerList[i]["id"])));
                                        },
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        splashColor: kThemeColor.withOpacity(0.1),
                                        hoverColor: kThemeColor.withOpacity(0.1),
                                        title: Row(
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
                                                child: userList[i]["photo"] == null ? Image.asset("assets/images/profile.png", width: 80, height: 80,) : userList[i]["photo"].isNotEmpty ? Image.network(
                                                  userList[i]["photo"],
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
                                                    userList[i]["type"],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: "${userList[i]["first_name"]} ",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: userList[i]["last_name"],
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
                                                    userList[i]["email"],
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
                                            PopupMenuButton<String>(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                side: const BorderSide(
                                                  color: kThemeColor,
                                                ),
                                              ),
                                              onSelected: (option) async {
                                                showDialog(context: context, builder: (_){
                                                  return AlertDialog(
                                                    backgroundColor: Colors.transparent,
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    content: IntrinsicHeight(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: IntrinsicHeight(
                                                              child: Column(
                                                                children: [
                                                                  for(int j = 0; j < roles.length; j++)
                                                                    Column(
                                                                      children: [
                                                                        Material(
                                                                          elevation: 0,
                                                                          color: Colors.transparent,
                                                                          child: ListTile(
                                                                            leading: Text(
                                                                              "${roles[j][0].toUpperCase()}${roles[j].substring(1).toLowerCase()}",
                                                                              style: const TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            onTap: ()async{
                                                                              showDeveloperProgress = true;
                                                                              setState(() {});
                                                                              Navigator.pop(context);
                                                                              var response = await ServiceApis().changeUsrRole(
                                                                                userId: userList[i]["id"],
                                                                                type: roles[j],
                                                                              );
                                                                              var data = jsonDecode(response.body);
                                                                              if(response.statusCode == 200){
                                                                                await getUserList();
                                                                                Widgets().showAlertDialog(alertMessage: "Role changed successfully", context: context);
                                                                              }else{
                                                                                Widgets().showError(data: data, context: context);
                                                                                showDeveloperProgress = false;
                                                                                setState(() {});
                                                                              }
                                                                            },
                                                                            // tileColor: kPrimaryColor,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            dense: true,
                                                                            trailing: userList[i]["type"] == roles[j] ? const Text(
                                                                              "✔",
                                                                              style: TextStyle(
                                                                                // fontWeight: FontWeight.bold,
                                                                                  fontSize: 18,
                                                                                  color: Colors.green
                                                                              ),
                                                                            ) : const SizedBox(),
                                                                          ),
                                                                        ),
                                                                        if(j < roles.length - 1)
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
                                                          const SizedBox(height: 15,),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            child: Material(
                                                              elevation: 0,
                                                              color: Colors.transparent,
                                                              child: ListTile(
                                                                leading: const Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                onTap: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                // tileColor: kPrimaryColor,
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
                                                  );
                                                });
                                              },
                                              splashRadius: 1,
                                              tooltip: "Options",
                                              padding: const EdgeInsets.all(0),
                                              itemBuilder: (BuildContext context) {
                                                return ["Change Role"].map((String choice) {
                                                  return PopupMenuItem<String>(
                                                    value: choice,
                                                    child: Text(
                                                      choice,
                                                      style: const TextStyle(
                                                        // color: kThemeColor,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                              child: const SizedBox(
                                                width: 20,
                                                child: Icon(
                                                  Icons.more_vert,
                                                  size: 25,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        tileColor: kThemeColor.withOpacity(0.06),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
