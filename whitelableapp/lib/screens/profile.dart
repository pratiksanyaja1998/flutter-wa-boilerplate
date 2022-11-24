
import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/model/user_model.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: userModel == null ? Center(
          child: Text(
            "log in first",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40,),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.black),
                color: kPrimaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  userModel!.photo,
                  width: 80,
                  height: 80,
                  loadingBuilder: (context, child, loaddingProgress){
                    if(loaddingProgress != null){
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
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              "Hello ${userModel!.firstName} 👋",
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 30,),
            RichText(
              text: TextSpan(
                text: "Email : ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: userModel!.email,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                text: "Phone : ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: userModel!.phone,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                text: "Telegram user name : ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: userModel!.telegramUserName,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                text: "Coins : ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: userModel!.coin,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
