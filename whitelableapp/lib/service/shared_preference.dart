
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:whitelableapp/model/business_app_config_model.dart';
import 'package:whitelableapp/model/user_model.dart';

class SharedPreference {

  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init()  async {
    if(_prefsInstance==null){
      _prefsInstance = await SharedPreferences.getInstance();
      return _prefsInstance!;
    }else{
      return _prefsInstance!;
    }
  }

  static Future<bool> setBusinessConfig(BusinessAppConfigModel? businessAppConfigModel) async{
    if(businessAppConfigModel != null) {
      String businessConfig = json.encode(businessAppConfigModel);
      return await _prefsInstance?.setString("businessConfig", businessConfig) ?? true;
    }else{
      return await _prefsInstance?.remove("businessConfig") ?? true;
    }
  }

  static BusinessAppConfigModel? getBusinessConfig() {
    String? businessConfig = _prefsInstance?.getString("businessConfig");
    if(businessConfig != null){
      BusinessAppConfigModel businessAppConfigModel = BusinessAppConfigModel.fromJson(json.decode(businessConfig));
      return businessAppConfigModel;
    }else {
      return null;
    }
  }

  static Future<bool> setIsLogin(bool value) async{
    return await _prefsInstance?.setBool("isLogin", value) ?? false;
  }

  static bool isLogin() {
    return _prefsInstance?.getBool("isLogin") ?? false;
  }

  static Future<bool> setUser({UserModel? userModel}) async{
    if(userModel != null) {
      String user =  json.encode(userModel);
      return await _prefsInstance?.setString("user", user) ?? true;
    }else{
      return await _prefsInstance?.remove("user") ?? true;
    }
  }

  static UserModel? getUser() {
    String? user = _prefsInstance?.getString("user");
    if(user != null){
      UserModel userModel = UserModel.fromJson(json.decode(user));
      return userModel;
    }else {
      return null;
    }
  }

}