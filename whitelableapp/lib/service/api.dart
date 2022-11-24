
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/firebase/firebase_messaging.dart';
import 'package:whitelableapp/model/business_app_config_model.dart';
import 'package:whitelableapp/model/user_model.dart';
import 'package:whitelableapp/service/shared_preference.dart';

class ServiceApis {

  static const String _baseUrl = "https://api.whitelabelapp.in";

  static BusinessAppConfigModel? _businessAppConfigModel;

  static Future<void> init()async{
    _businessAppConfigModel = SharedPreference.getBusinessConfig();
  }

  Future<http.Response> getAppConfig()async{

    Uri url = Uri.parse("$_baseUrl/business/app/config/$kDomain");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
        }
    );

    if(response.statusCode == 200){
      print("RESPONSE = ${response.body}");
      _businessAppConfigModel = BusinessAppConfigModel.fromJson(jsonDecode(response.body)["data"]);
      SharedPreference.setBusinessConfig(_businessAppConfigModel!);
      return response;
    }else{
      print("RESPONSE = ${response.statusCode}");
      print("RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> userLogin({
    required String password,
    required String userName,
  })async{

    Uri url = Uri.parse("$_baseUrl/user/login");

    final body = jsonEncode({
      "password": password,
      "username": "+91$userName",
      "business": _businessAppConfigModel!.businessId,
    });

    print(body);

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        }
    );

    if(response.statusCode == 200){
      print("RESPONSE = ${response.body}");
      UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
      SharedPreference.setUser(userModel: userModel);
      return response;
    }else{
      print("RESPONSE = ${response.statusCode}");
      print("RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> userLogOut()async{

    Uri url = Uri.parse("$_baseUrl/user/logout");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("RESPONSE = ${response.body}");
      SharedPreference.setIsLogin(false);
      SharedPreference.setUser();
      return response;
    }else{
      print("RESPONSE = ${response.statusCode}");
      print("RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> crateFcmToken()async{

    Uri url = Uri.parse("$_baseUrl/user/fcm/token/create");

    final body = jsonEncode({
      "token": FirebaseMessagingProject.fcmToken,
      "type": "fcm",
      "token_from": "client",
    });

    print(body);

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("RESPONSE = ${response.body}");
      return response;
    }else{
      print("RESPONSE = ${response.statusCode}");
      print("RESPONSE = ${response.body}");
      return response;
    }

  }

}