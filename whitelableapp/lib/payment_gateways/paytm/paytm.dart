
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

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
      CommonFunctions().showSuccessModal(context: context);
      printMessage("PAYTM PAYMENT SUCCESS : $result");
      return true;
    }).catchError((onError) {
      printMessage("PAYTM PAYMENT ERROR ----: $onError");
      if (onError is PlatformException) {
        var result = "${onError.message!} \n  ${onError.details} \n ${onError.code} \n ${onError.stacktrace}";
        printMessage("PAYTM PAYMENT ERROR --: $result");
      } else {
        var result = onError.toString();
        printMessage("PAYTM PAYMENT ERROR : $result");
      }
      CommonFunctions().showSuccessModal(context: context, success: false);
      return false;
    });
    return true;
  }

}