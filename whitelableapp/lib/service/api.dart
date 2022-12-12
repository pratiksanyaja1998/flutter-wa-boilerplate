
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/firebase/firebase_messaging.dart';
import 'package:whitelabelapp/model/business_app_config_model.dart';
import 'package:whitelabelapp/model/user_model.dart';
import 'package:whitelabelapp/service/shared_preference.dart';

class ServiceApis {

  // static const String _baseUrl = "https://api.whitelabelapp.in";
  // static const String _baseUrl = "http://192.168.1.10:8000";
  static const String _baseUrl = "http://192.168.1.15:8000";
  // static const String _baseUrl = "http://192.168.1.11:9000";

  static String get getBaseUrl => _baseUrl;

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
      print("GET APP CONFIG RESPONSE = ${response.body}");
      _businessAppConfigModel = BusinessAppConfigModel.fromJson(jsonDecode(response.body)["data"]);
      SharedPreference.setBusinessConfig(_businessAppConfigModel!);
      return response;
    }else{
      print("GET APP CONFIG RESPONSE = ${response.statusCode}");
      return response;
    }

  }

  Future<http.Response> registerUser({
    required String email,
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
    String? referralCode,
  })async{

    Uri url = Uri.parse("$_baseUrl/user/register");

    final body = jsonEncode({
      "email": email,
      "phone": phone,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "business": _businessAppConfigModel!.businessId,
      "refer_by": referralCode ?? "",
    });

    print(body);

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          // "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("REGISTER USER RESPONSE = ${response.body}");
      return response;
    }else{
      print("REGISTER USER RESPONSE = ${response.statusCode}");
      print("REGISTER USER RESPONSE = ${response.body}");
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
      "username": userName,
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
      print("USEr LOGIN RESPONSE = ${response.body}");
      UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
      SharedPreference.setUser(userModel: userModel);
      return response;
    }else{
      print("USER LOGIN RESPONSE = ${response.statusCode}");
      print("USER LOGIN RESPONSE = ${response.body}");
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
      print("USER LOG OUT RESPONSE = ${response.body}");
      SharedPreference.setIsLogin(false);
      SharedPreference.setUser();
      return response;
    }else{
      print("USER LOG OUT RESPONSE = ${response.statusCode}");
      print("USER LOG OUT RESPONSE = ${response.body}");
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
      print("CREATE FCM TOKEN RESPONSE = ${response.body}");
      return response;
    }else{
      print("CREATE FCM TOKEN RESPONSE = ${response.statusCode}");
      print("CREATE FCM TOKEN RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> resendVerificationOtp({
    required String userName,
  })async{

    Uri url = Uri.parse("$_baseUrl/user/resend-verification-otp");

    final body = jsonEncode({
      "username": userName,
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
      print("RESEND VERIFICATION OTP RESPONSE = ${response.body}");
      return response;
    }else{
      print("RESEND VERIFICATION OTP RESPONSE = ${response.statusCode}");
      print("RESEND VERIFICATION OTP RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> verifyOtp({
    required String otp,
    required int userId,
  })async{

    Uri url = Uri.parse("$_baseUrl/user/verify-otp");

    final body = jsonEncode({
      "otp": otp,
      "user": userId,
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
      print("VERIFY OTP RESPONSE = ${response.body}");
      return response;
    }else{
      print("VERIFY OTP RESPONSE = ${response.statusCode}");
      print("VERIFY OTP RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> updateUserProfile({
    String? firstName,
    String? lastName,
    var photo,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/update/profile/${SharedPreference.getUser()!.id}");

    var request = http.MultipartRequest("PUT", url);
    request.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Token ${SharedPreference.getUser()!.token}"
    });
    if(photo!=null){
      request.files.add(await http.MultipartFile.fromPath("photo", photo.path));
    }else{
      request.fields["photo"] = "";
    }
    if(firstName != null){
      request.fields["first_name"] = firstName;
    }
    if(lastName != null){
      request.fields["last_name"] = lastName;
    }
    var response = await request.send();
    var streamResponse = await http.Response.fromStream(response);
    final responseData = json.decode(streamResponse.body);
    if (response.statusCode == 200) {
      print("UPDATE USER PROFILE RESPONSE = $responseData");
      return streamResponse;
    } else {
      print("UPDATE USER PROFILE RESPONSE = ${response.statusCode}");
      print("UPDATE USER PROFILE RESPONSE = $responseData");
      print("ERROR");
      return streamResponse;
    }
  }

  Future<http.Response> deleteAddress({
    required int addressId,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/address/delete/$addressId");

    http.Response response = await http.Client().delete(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 204){
      print("DELETE ADDRESS RESPONSE = ${response.body}");
      return response;
    }else{
      print("DELETE ADDRESS RESPONSE = ${response.statusCode}");
      print("DELETE ADDRESS RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> razorpayCallback({
    required String id,
    required String paymentId,
    required String orderId,
    required String signature,
  })async{
    Uri url = Uri.parse("$_baseUrl/payment/razorpay/callback/$id");

    var body = {
      "razorpay_payment_id": paymentId,
      "razorpay_order_id": orderId,
      "razorpay_signature": signature
    };

    http.Response response = await http.Client().post(
        url,
        body: body,
    );

    if(response.statusCode == 200){
      print("RAZORPAY CALLBACK RESPONSE = ${response.body}");
      return response;
    }else{
      print("RAZORPAY CALLBACK RESPONSE = ${response.statusCode}");
      print("RAZORPAY CALLBACK RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> stripeCallback({
    required String id,
  })async{
    Uri url = Uri.parse("$_baseUrl/payment/stripe/callback/$id");

    http.Response response = await http.Client().get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Token ${SharedPreference.getUser()!.token}"
      }
    );

    print("STRIPE CALLBACK RESPONSE STATUS= ${response.statusCode}");
    if(response.statusCode == 200){
      print("STRIPE CALLBACK RESPONSE = ${response.body}");
      return response;
    }else{
      print("STRIPE CALLBACK RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> userSettingUpdate({
    required int userId,
    required bool orderUpdateNotification,
    required bool promotionNotification,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/setting/update/$userId");

    final body = jsonEncode({
      "order_update_notification": orderUpdateNotification,
      "promotion_notification": promotionNotification,
    });

    http.Response response = await http.Client().put(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("UPDATE USER SETTING RESPONSE = ${response.body}");
      return response;
    }else{
      print("UPDATE USER SETTING RESPONSE = ${response.statusCode}");
      print("UPDATE USER SETTING RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/change-password");

    final body = jsonEncode({
      "old_password": oldPassword,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    });

    http.Response response = await http.Client().put(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("CHANGE PASSWORD RESPONSE = ${response.body}");
      return response;
    }else{
      print("CHANGE PASSWORD RESPONSE = ${response.statusCode}");
      print("CHANGE PASSWORD RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> deleteAccount()async{

    Uri url = Uri.parse("$_baseUrl/user/delete/account/request/${SharedPreference.getUser()!.id}");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("DELETE ACCOUNT RESPONSE = ${response.body}");
      return response;
    }else{
      print("DELETE ACCOUNT RESPONSE = ${response.statusCode}");
      print("DELETE ACCOUNT RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required String userName,
    required String otp,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/reset-password/");

    final body = jsonEncode({
      "new_password": newPassword,
      "confirm_password": confirmPassword,
      "otp": otp,
      "username": userName,
      "business": SharedPreference.getBusinessConfig()!.businessId,
    });

    http.Response response = await http.Client().post(
        url,
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        }
    );

    if(response.statusCode == 200){
      print("RESET PASSWORD RESPONSE = ${response.body}");
      return response;
    }else{
      print("RESET PASSWORD RESPONSE = ${response.statusCode}");
      print("RESET PASSWORD RESPONSE = ${response.body}");
      return response;
    }
  }

  // Future<http.Response> getNotificationList()async{
  //   Uri url = Uri.parse("$_baseUrl/notification/list/${SharedPreference.getBusinessConfig()!.businessId}");
  //
  //   http.Response response = await http.Client().get(
  //       url,
  //       headers: {
  //         "Accept": "application/json",
  //         // "Authorization": "Token ${SharedPreference.getUser()!.token}"
  //       }
  //   );
  //
  //   if(response.statusCode == 200){
  //     print("GET NOTIFICATION LIST RESPONSE = ${response.statusCode}");
  //     return response;
  //   }else{
  //     print("GET NOTIFICATION LIST RESPONSE = ${response.statusCode}");
  //     return response;
  //   }
  // }
  //
  // Future<http.Response> deleteNotification({required int notificationId})async{
  //   Uri url = Uri.parse("$_baseUrl/notification/delete/$notificationId}");
  //
  //   http.Response response = await http.Client().delete(
  //       url,
  //       headers: {
  //         "Accept": "application/json",
  //         "Authorization": "Token ${SharedPreference.getUser()!.token}"
  //       }
  //   );
  //
  //   if(response.statusCode == 200){
  //     print("DELETE NOTIFICATION RESPONSE = ${response.statusCode}");
  //     return response;
  //   }else{
  //     print("DELETE NOTIFICATION RESPONSE = ${response.statusCode}");
  //     return response;
  //   }
  // }
  //
  // Future<http.Response> deleteMultipleNotification({required String notificationId})async{
  //   Uri url = Uri.parse("$_baseUrl/notification/delete/multiple/$notificationId}");
  //
  //   http.Response response = await http.Client().delete(
  //       url,
  //       headers: {
  //         "Accept": "application/json",
  //         "Authorization": "Token ${SharedPreference.getUser()!.token}"
  //       }
  //   );
  //
  //   if(response.statusCode == 200){
  //     print("DELETE MULTIPLE NOTIFICATION RESPONSE = ${response.statusCode}");
  //     return response;
  //   }else{
  //     print("DELETE MULTIPLE NOTIFICATION RESPONSE = ${response.statusCode}");
  //     return response;
  //   }
  // }
  //
  //   Future<http.Response> getPromotionList()async{
  //   Uri url = Uri.parse("$_baseUrl/promotion/list/${SharedPreference.getBusinessConfig()!.businessId}");
  //
  //   http.Response response = await http.Client().get(
  //       url,
  //       headers: {
  //         "Accept": "application/json",
  //         // "Authorization": "Token ${SharedPreference.getUser()!.token}"
  //       }
  //   );
  //
  //   if(response.statusCode == 200){
  //     print("GET PROMOTION LIST RESPONSE = ${response.statusCode}");
  //     print("GET PROMOTION LIST RESPONSE = ${response.body}");
  //     return response;
  //   }else{
  //     print("GET PROMOTION LIST RESPONSE = ${response.statusCode}");
  //     return response;
  //   }
  // }

  Future<http.Response> createDonation({required double amount, String? description})async{
    Uri url = Uri.parse("$_baseUrl/donation/create");

    final body = jsonEncode({
      "amount": amount,
      "note": description ?? "",
    });

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
      print("CREATE DONATION RESPONSE = ${response.statusCode}");
      return response;
    }else{
      print("CREATE DONATION RESPONSE = ${response.statusCode}");
      print("CREATE DONATION RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getDonationList()async{
    Uri url = Uri.parse("$_baseUrl/donation/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("GET DONATION LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      print("GET DONATION LIST RESPONSE = ${response.statusCode}");
      return response;
    }
  }

  Future<http.Response> getReferralList()async{
    Uri url = Uri.parse("$_baseUrl/user/referral/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("GET REFERRAL LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      print("GET REFERRAL LIST RESPONSE = ${response.statusCode}");
      print("GET REFERRAL LIST RESPONSE = ${response.body}");
      return response;
    }
  }

}