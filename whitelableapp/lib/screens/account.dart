
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/components/drawer.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/screens/profile_settings.dart';
import 'package:whitelabelapp/screens/user_address.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  UserModel? userModel;

  @override
  void initState() {
    userModel = SharedPreference.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(getTranslated(context, ["menu","profile"])),
      ),
      drawer: DrawerItem().drawer(context, setState),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 450,
            minHeight: MediaQuery.of(context).size.height,
          ),
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
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSettingsScreen())).then((value) {
                          setState(() {});
                        });
                      },
                      title: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                child: SharedPreference.getUser()!.photo.isNotEmpty ? Image.network(
                                  SharedPreference.getUser()!.photo,
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
                                  errorBuilder: (context, obj, st){
                                    return Image.asset("assets/images/profile.png", width: 100, height: 100,);
                                  },
                                ) : Image.asset("assets/images/profile.png", width: 80, height: 80,),
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
                                    userModel!.email,
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
                      tileColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      dense: true,
                    ),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserAddress()));
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
    );
  }
}
