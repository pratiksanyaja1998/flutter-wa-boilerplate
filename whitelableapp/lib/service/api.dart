
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class ServiceApis {

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

  Future<http.Response> getCoinTransactions({String? searchText, String? date, String? type})async{
    Uri url = Uri.parse("$baseUrl/coin/transactions/list?${searchText != null ? "search=$searchText" : ""}${date != null ? "&created_at=$date" : ""}${type != null ? "&type=$type" :  ""}");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET COIN TRANSACTION LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET COIN TRANSACTION LIST RESPONSE = ${response.statusCode}");
      printMessage("GET COIN TRANSACTION LIST RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> redeemCoins({required double coin, required String upiId})async{
    Uri url = Uri.parse("$baseUrl/coin/redeem/create");

    final body = jsonEncode({
      "coin": coin,
      "upi_id": upiId,
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
      printMessage("REDEEM COINS RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("REDEEM COINS RESPONSE = ${response.statusCode}");
      printMessage("REDEEM COINS RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> createDonation({required double amount, String? description})async{
    Uri url = Uri.parse("$baseUrl/donation/create");

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
      printMessage("CREATE DONATION RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("CREATE DONATION RESPONSE = ${response.statusCode}");
      printMessage("CREATE DONATION RESPONSE = ${response.body}");
      return response;
    }
  }

  Future<http.Response> getDonationList()async{
    Uri url = Uri.parse("$baseUrl/donation/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET DONATION LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET DONATION LIST RESPONSE = ${response.statusCode}");
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

  Future<http.Response> getReferralList()async{
    Uri url = Uri.parse("$baseUrl/user/referral/list");

    http.Response response = await http.Client().get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Token ${SharedPreference.getUser()!.token}"
        }
    );

    if(response.statusCode == 200){
      printMessage("GET REFERRAL LIST RESPONSE = ${response.statusCode}");
      return response;
    }else{
      printMessage("GET REFERRAL LIST RESPONSE = ${response.statusCode}");
      printMessage("GET REFERRAL LIST RESPONSE = ${response.body}");
      return response;
    }
  }

}