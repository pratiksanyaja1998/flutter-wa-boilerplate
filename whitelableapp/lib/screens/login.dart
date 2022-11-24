
import 'package:flutter/material.dart';
import 'package:whitelableapp/service/api.dart';
import 'package:whitelableapp/service/shared_preference.dart';
import 'package:whitelableapp/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Widgets().textFormField(
                controller: userNameController,
                labelText: 'Enter user name',
                validator: (val) {
                  if(val!.isNotEmpty){
                    return "Must be enter user name";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Widgets().textFormField(
                controller: passwordController,
                labelText: 'Enter Password',
                validator: (val) {
                  if(val!.isNotEmpty){
                    return "Must be enter email address";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 10,),
            Widgets().textButton(
              onPressed: ()async{
                var response = await ServiceApis().userLogin(password: passwordController.text, userName: userNameController.text);
                if(response.statusCode == 200){
                  SharedPreference.setIsLogin(true);
                  Navigator.of(context).pop();
                }else{
                  print("Log in failed something went wrong");
                }
              },
              text: "Log in",
            ),
          ],
        ),
      ),
    );
  }
}
