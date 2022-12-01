
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/localization/language_constants.dart';
import 'package:whitelableapp/model/user_model.dart';
import 'package:whitelableapp/screens/user_address.dart';
import 'package:whitelableapp/service/shared_preference.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    userModel = SharedPreference.getUser();
    super.initState();
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
            title: Text(
              getTranslated(context, ["walletScreen", "wallet"]),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: userModel == null ? const Center(
              child: Text(
                "log in first",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ) : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    constraints: const BoxConstraints(
                      minWidth: 370,
                    ),
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
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(color: Colors.grey),
                            color: kPrimaryColor,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.5),
                            //     blurRadius: 2,
                            //   ),
                            // ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: userModel!.photo.isNotEmpty ? Image.network(
                              userModel!.photo,
                              width: 80,
                              height: 80,
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
                            ) : Image.asset("assets/images/logo.png", width: 80, height: 80,),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: "${userModel!.firstName} ",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: userModel!.lastName,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3,),
                              Text(
                                userModel!.phone,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                userModel!.email + userModel!.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15,),
                        const Icon(CupertinoIcons.qrcode, color: Colors.black, size: 30,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    padding: const EdgeInsets.all(15),
                    constraints: const BoxConstraints(
                      minWidth: 370,
                    ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Coins",),
                        Text(
                          userModel!.coin,
                          style: const TextStyle(
                            color: Colors.black,fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Container(
                    // padding: const EdgeInsets.symmetric(vertical: 5),
                    constraints: const BoxConstraints(
                      minWidth: 370,
                    ),
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
                    child: Column(
                      children: [
                        Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: ListTile(
                            leading: Text(
                              getTranslated(context, ["walletScreen", "savedAddress"]),
                            ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserAddress()));
                            },
                            dense: true,
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,),
                          ),
                        ),
                        Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: ListTile(
                            leading: Text(
                              getTranslated(context, ["walletScreen", "orderHistory"]),
                            ),
                            onTap: (){

                            },
                            dense: true,
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,),
                          ),
                        ),
                        Material(
                          elevation: 0,
                          color: Colors.transparent,
                          child: ListTile(
                            leading: Text(
                              getTranslated(context, ["subscriptionHistory", "title"]),
                            ),
                            onTap: (){

                            },
                            dense: true,
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
