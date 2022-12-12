
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:whitelabelapp/screens/accommodation/booking_detail.dart';
import 'package:whitelabelapp/service/shared_preference.dart';

class Paytm{

  Future<bool> doPayment({
    required int id,
    required BuildContext context,
    required String orderId,
    required String amount,
    required String txnToken,
  })async{
    await AllInOneSdk.startTransaction(
      SharedPreference.getBusinessConfig()!.paymentKey,
      orderId,
      amount,
      txnToken,
      "",
      true,
      true,
    ).then((value) {
      var result = value.toString();
      Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailScreen(id: id,)));
      print("PAYTM PAYMENT SUCCESS : $result");
      return true;
    }).catchError((onError) {
      print("PAYTM PAYMENT ERROR ----: $onError");
      if (onError is PlatformException) {
        var result = "${onError.message!} \n  ${onError.details} \n ${onError.code} \n ${onError.stacktrace}";
        print("PAYTM PAYMENT ERROR --: $result");
      } else {
        var result = onError.toString();
        print("PAYTM PAYMENT ERROR : $result");
      }
      Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDetailScreen(id: id,)));
      return false;
    });
    return true;
  }

}