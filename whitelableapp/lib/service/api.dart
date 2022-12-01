
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/firebase/firebase_messaging.dart';
import 'package:whitelableapp/model/business_app_config_model.dart';
import 'package:whitelableapp/model/user_model.dart';
import 'package:whitelableapp/service/shared_preference.dart';

class ServiceApis {

  // static const String _baseUrl = "https://api.whitelabelapp.in";
  // static const String _baseUrl = "http://192.168.1.10:8000";
  static const String _baseUrl = "http://192.168.1.15:8000";

  static String get getBaseUrl => _baseUrl;

  static BusinessAppConfigModel? _businessAppConfigModel;

  static Future<void> init()async{
    _businessAppConfigModel = SharedPreference.getBusinessConfig();
  }

  Future<http.Response> getAppConfig()async{

    Uri url = Uri.parse("$_baseUrl/business/app/config/$kDomain");
    print("_________ $url _______");

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
      print("GET APP CONFIG RESPONSE = ${response.body}");
      return response;
    }

  }

  Future<http.Response> registerUser({
    required String email,
    required String phone,
    required String password,
    required String firstName,
    required String lastName,
  })async{

    Uri url = Uri.parse("$_baseUrl/user/register");

    final body = jsonEncode({
      "email": email,
      "phone": phone,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "business": _businessAppConfigModel!.businessId,
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

  Future<http.Response> getAccommodationList()async{
    Uri url = Uri.parse("$_baseUrl/hospitality/accommodation/available/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("GET ACCOMMODATION LIST RESPONSE = ${response.body}");
      return response;
    }else{
      print("GET ACCOMMODATION LIST RESPONSE = ${response.statusCode}");
      print("GET ACCOMMODATION LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getUserAddressList()async{
    Uri url = Uri.parse("$_baseUrl/user/address/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("GET ADDRESS LIST RESPONSE = ${response.body}");
      return response;
    }else{
      print("GET ADDRESS LIST RESPONSE = ${response.statusCode}");
      print("GET ADDRESS LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> addAddress({
    required String street,
    required String area,
    required String pinCode,
    required String city,
    required String state,
    required String type,
    required String country,
    double? longitude,
    double? latitude,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/address/create");

    final body = jsonEncode({
      "street": street,
      "area": area,
      "pincode": pinCode,
      "city": city,
      "state": state,
      "type": type,
      "country": country,
      "longitude": longitude ?? 0.0,
      "latitude": latitude ?? 0.0,
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
      print("CREATE ADDRESS RESPONSE = ${response.body}");
      return response;
    }else{
      print("CREATE ADDRESS RESPONSE = ${response.statusCode}");
      print("CREATE ADDRESS RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> deleteAddress({
    required int addressId,
  })async{
    Uri url = Uri.parse("$_baseUrl/user/address/delete/$addressId");

    // final body = jsonEncode({
    //   "id": addressId,
    // });

    // print("_+_+_+_+_+_+_ $body");

    http.Response response = await http.Client().delete(
        url,
        // body: body,
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

  Future<http.Response> createBooking({
    required String checkInDate,
    required String checkOutDate,
    required int accommodationId,
  })async{
    Uri url = Uri.parse("$_baseUrl/hospitality/booking/create");

    final body = jsonEncode({
      "check_in": checkInDate,
      "check_out": checkOutDate,
      "accommodation": accommodationId,
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

    if(response.statusCode == 201){
      print("CREATE BOOKING RESPONSE = ${response.body}");
      return response;
    }else{
      print("CREATE BOOKING RESPONSE = ${response.statusCode}");
      print("CREATE BOOKING RESPONSE = ${response.body}");
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
        // headers: {
        //   "Accept": "application/json",
        //   // "Content-Type": "application/json",
        //   // "Authorization": "Token ${SharedPreference.getUser()!.token}"
        // }
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
        // "Content-Type": "application/json",
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

  Future<http.Response> getBookingsList()async{
    Uri url = Uri.parse("$_baseUrl/hospitality/booking/user/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("GET BOOKING LIST RESPONSE = ${response.body}");
      return response;
    }else{
      print("GET BOOKING LIST RESPONSE = ${response.statusCode}");
      print("GET BOOKING LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getBookingDetail({required int id})async{
    print("-+-+-+-+-+-+-+-+-+-+-+-+-+- $id");
    Uri url = Uri.parse("$_baseUrl/hospitality/get/booking/details/$id");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      print("GET BOOKING DETAIL RESPONSE = ${response.body}");
      return response;
    }else{
      print("GET BOOKING DETAIL RESPONSE = ${response.statusCode}");
      print("GET BOOKING DETAIL RESPONSE = ${response.body}");
      return response;
    }
  }

}