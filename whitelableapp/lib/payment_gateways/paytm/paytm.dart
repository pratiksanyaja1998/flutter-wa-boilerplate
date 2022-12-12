
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

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
      Widgets().showSuccessModal(context: context);
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
      Widgets().showSuccessModal(context: context, success: false);
      return false;
    });
    return true;
  }

}