
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:whitelableapp/screens/booking_detail.dart';
import 'package:whitelableapp/screens/bookings.dart';
import 'package:whitelableapp/service/shared_preference.dart';

class Paytm{

  Future<void> doPayment({
    required int id,
    required BuildContext context,
    required String orderId,
    required String amount,
    required String txnToken,
  })async{
    print(":::::::::::::::::::::::::: ${SharedPreference.getBusinessConfig()!.paymentKey} :::::::::::::::::::::::::::::");
    var response = AllInOneSdk.startTransaction(
      SharedPreference.getBusinessConfig()!.paymentKey,
      orderId,
      amount,
      txnToken,
      "",
      true,
      false,
    );
    response.then((value) {
      var result = value.toString();
      Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailScreen(id: id,)));
      print("PAYTM PAYMENT SUCCESS : $result");
    }).catchError((onError) {
      if (onError is PlatformException) {
        var result = "${onError.message!} \n  ${onError.details}";
        print("PAYTM PAYMENT ERROR : $result");
      } else {
        var result = onError.toString();
        print("PAYTM PAYMENT ERROR : $result");
      }
    });

  }

}