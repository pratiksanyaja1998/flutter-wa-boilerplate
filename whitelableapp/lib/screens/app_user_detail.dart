
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class AppUserDetailScreen extends StatefulWidget {
  const AppUserDetailScreen({Key? key, required this.userId}) : super(key: key);

  final int userId;

  @override
  State<AppUserDetailScreen> createState() => _AppUserDetailScreenState();
}

class _AppUserDetailScreenState extends State<AppUserDetailScreen> {

  bool showProgress = true;
  List<String> roles = ["client", "developer", "manager"];
  var userData;

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }

  Future<void> getUser()async{
    var response = await ServiceApis().getUserDetail(userId: widget.userId.toString());
    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      userData = data["data"];
      showProgress = false;
      setState(() {});
    }else{
      showProgress = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Detail"),
      ),
      body: showProgress ? const Center(
        child: CircularProgressIndicator(
          color: kThemeColor,
        ),
      ) : userData == null ? const Center() : Column(
        children: [
          const SizedBox(height: 20,),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20,),
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
                        child: userData["photo"] == null ? Image.asset("assets/images/profile.png", width: 80, height: 80,) : userData["photo"].isNotEmpty ? Image.network(
                          userData["photo"],
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
                              text: "${userData["first_name"]} ",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              children: [
                                TextSpan(
                                  text: userData["last_name"],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            userData["email"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            userData["phone"],
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
                        side: BorderSide(
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
                                                      showProgress = true;
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                      var response = await ServiceApis().changeUsrRole(
                                                        userId: userData["id"],
                                                        type: roles[j],
                                                      );
                                                      var data = jsonDecode(response.body);
                                                      if(response.statusCode == 200){
                                                        await getUser();
                                                        Widgets().showAlertDialog(alertMessage: "Role changed successfully", context: context);
                                                      }else{
                                                        Widgets().showError(data: data, context: context);
                                                        showProgress = false;
                                                        setState(() {});
                                                      }
                                                    },
                                                    // tileColor: kPrimaryColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    dense: true,
                                                    trailing: userData["type"] == roles[j] ? const Text(
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
                                        leading: Text(
                                          "Cancel",
                                          style: const TextStyle(
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
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20,),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${userData["type"].toString()[0].toUpperCase()}${userData["type"].toString().substring(1).toLowerCase()}",
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 25,
                          ),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      dense: true,
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: Container(),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
