
import 'package:flutter/material.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/model/business_app_config_model.dart';
import 'package:whitelabelapp/screens/dashboard.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String displayText = "";

  @override
  void initState() {

    getBusinessAppConfig();
    
    super.initState();
  }

  Future<void> getBusinessAppConfig()async{
    await Future.delayed(const Duration(seconds: 0));
    BusinessAppConfigModel? businessAppConfigModel = SharedPreference.getBusinessConfig();
    if(businessAppConfigModel != null){
      displayText = "";
      var response = await ServiceApis().getAppConfig();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardScreen()));
    }else{
      displayText = "We are setting up your app...";
      setState(() {});
      var response = await ServiceApis().getAppConfig();
      displayText = "";
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardScreen()));
    }
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage("assets/images/logo.png"), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: kPrimaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset("assets/images/logo.png", width: 80, height: 80,),
                ),
              ),
              const SizedBox(height: 10,),
              if(displayText.isNotEmpty)
                Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
