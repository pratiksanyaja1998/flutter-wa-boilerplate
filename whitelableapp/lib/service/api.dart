
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class ServiceApis {

  static String get getBaseUrl => baseUrl;

  Future<http.Response> getAccommodationList({String? startDate, String? endDate})async{
    Uri url = Uri.parse("$baseUrl/hospitality/accommodation/available/list?start_date=${startDate ?? ""}&end_date=${endDate ?? ""}");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET ACCOMMODATION LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET ACCOMMODATION LIST RESPONSE = ${response.statusCode}");
      printMessage("GET ACCOMMODATION LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getUserAddressList()async{
    Uri url = Uri.parse("$baseUrl/user/address/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET ADDRESS LIST RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("GET ADDRESS LIST RESPONSE = ${response.statusCode}");
      printMessage("GET ADDRESS LIST RESPONSE = ${response.body}");
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
    Uri url = Uri.parse("$baseUrl/user/address/create");

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
      printMessage("CREATE ADDRESS RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("CREATE ADDRESS RESPONSE = ${response.statusCode}");
      printMessage("CREATE ADDRESS RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> deleteAddress({
    required int addressId,
  })async{
    Uri url = Uri.parse("$baseUrl/user/address/delete/$addressId");

    http.Response response = await http.Client().delete(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 204){
      printMessage("DELETE ADDRESS RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("DELETE ADDRESS RESPONSE = ${response.statusCode}");
      printMessage("DELETE ADDRESS RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> createBooking({
    required String checkInDate,
    required String checkOutDate,
    required int accommodationId,
  })async{
    Uri url = Uri.parse("$baseUrl/hospitality/booking/create");

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
      printMessage("CREATE BOOKING RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("CREATE BOOKING RESPONSE = ${response.statusCode}");
      printMessage("CREATE BOOKING RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getPaymentDetail({required String paymentId})async{
    Uri url = Uri.parse("$baseUrl/payment/details/$paymentId");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET PAYMENT DETAIL RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET PAYMENT DETAIL RESPONSE = ${response.statusCode}");
      printMessage("GET PAYMENT DETAIL RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> razorpayCallback({
    required String id,
    required String paymentId,
    required String orderId,
    required String signature,
  })async{
    Uri url = Uri.parse("$baseUrl/payment/razorpay/callback/$id");

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
      printMessage("RAZORPAY CALLBACK RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("RAZORPAY CALLBACK RESPONSE = ${response.statusCode}");
      printMessage("RAZORPAY CALLBACK RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> stripeCallback({
    required String id,
  })async{
    Uri url = Uri.parse("$baseUrl/payment/stripe/callback/$id");

    http.Response response = await http.Client().get(
      url,
      headers: {
        "Accept": "application/json",
        "Authorization": "Token ${SharedPreference.getUser()!.token}"
      }
    );

    printMessage("STRIPE CALLBACK RESPONSE STATUS= ${response.statusCode}");
    if(response.statusCode == 200){
      printMessage("STRIPE CALLBACK RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("STRIPE CALLBACK RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getBookingsList()async{
    Uri url = Uri.parse("$baseUrl/hospitality/booking/user/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET BOOKING LIST RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("GET BOOKING LIST RESPONSE = ${response.statusCode}");
      printMessage("GET BOOKING LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getBookingDetail({required int id})async{
    Uri url = Uri.parse("$baseUrl/hospitality/get/booking/details/$id");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET BOOKING DETAIL RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("GET BOOKING DETAIL RESPONSE = ${response.statusCode}");
      printMessage("GET BOOKING DETAIL RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> cancelBooking({
    required String status,
    required String message,
    required int user,
    required int bookingId,
  })async{
    Uri url = Uri.parse("$baseUrl/hospitality/cancel/booking/request");

    final body = jsonEncode({
      "statue": status,
      "message": message,
      "user": user,
      "booking": bookingId,
    });

    printMessage(body);

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
      printMessage("CANCEL BOOKING RESPONSE = ${response.body}");
      return response;
    }else{
      printMessage("CANCEL BOOKING RESPONSE = ${response.statusCode}");
      printMessage("CANCEL BOOKING RESPONSE = ${response.body}");
      return response;
    }
  }

}