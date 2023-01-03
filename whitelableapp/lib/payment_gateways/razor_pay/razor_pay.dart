
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/service/api.dart';

class RazorPay{

  RazorPay({
    required this.context,
    required this.id,
    required this.order,
  });
  BuildContext context;
  int id;
  dynamic order;

  final Razorpay _razorpay = Razorpay();

  bool paymentEnd = false;

  Future<Razorpay?> init()  async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
    await openGateway(
      orderId: order["payment_order_key"],
      amount: order["paid_amount"],
      description: "Book Accommodation",
    );
    while (!paymentEnd) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (paymentEnd) break;
    }
    return null;
  }

  Razorpay get getInstance => _razorpay;

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    printMessage("::::::::::::::::::::::: ${response.orderId} ::::::::::::::::::::::");
    printMessage("::::::::::::::::::::::: ${response.paymentId} ::::::::::::::::::::::");
    printMessage("::::::::::::::::::::::: ${response.signature} ::::::::::::::::::::::");

    var res = await ServiceApis().razorpayCallback(
      id: order["id"].toString(),
      paymentId: response.paymentId ?? "",
      orderId: response.orderId ?? "",
      signature: response.signature ?? "",
    );

    _razorpay.clear();

    if(res.statusCode == 200){
      CommonFunctions().showSuccessModal(context: context,);
    }else{
      CommonFunctions().showSuccessModal(context: context, success: false);
    }

    paymentEnd = true;

    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentSuccessScreen()));

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    printMessage("###################### ${response.code} ##########################");
    printMessage("###################### ${response.message} ##########################");
    _razorpay.clear();
    paymentEnd = true;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    printMessage("@@@@@@@@@@@@@@@@@@@@ ${response.walletName} @@@@@@@@@@@@@@@@@@@@@@@@@@@");
    _razorpay.clear();
    paymentEnd = true;
  }

  Future<void> openGateway({required String orderId, required double amount, required String description})async{

    printMessage("CREATING GATEWAY");

    var options = {
      'key': SharedPreference.getBusinessConfig()!.paymentKey,
      'amount': amount * 100, //in the smallest currency sub-unit.
      'name': SharedPreference.getBusinessConfig()!.businessName,
      "description": description,
      // "callback_url": "${UserApi().baseUrl}/donation/razorpay/callback/$donationId",
      "redirect": true,
      "notes": {
        "address": "Razorpay Corporate Office"
      },
      'order_id': orderId,
      'timeout': 300,
      'prefill': {
        "name": "${SharedPreference.getUser()!.firstName} ${SharedPreference.getUser()!.lastName}",
        "email": SharedPreference.getUser()!.email,
        "contact": SharedPreference.getUser()!.phone,
      }
    };
    _razorpay.open(options);
  }

}