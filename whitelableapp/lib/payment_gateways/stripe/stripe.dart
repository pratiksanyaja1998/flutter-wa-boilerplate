
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/service/api.dart';

class StripePg{

  StripePg({
    required this.context,
    required this.id,
    required this.orderId,
    required this.clientSecret,
  });

  BuildContext context;
  int id;
  String orderId;
  String clientSecret;

  Future<void> init()async{
    printMessage("_____ STRIPE INIT _____");
    Stripe.publishableKey = SharedPreference.getBusinessConfig()!.paymentKey;
    await openGateway();
  }

  Future<void> openGateway()async{

    printMessage("_____ STRIPE GATEWAY OPEN _____");
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          setupIntentClientSecret: "",
          merchantDisplayName: SharedPreference.getBusinessConfig()!.appName,
          style: ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet().then((value) async {
        var response = await ServiceApis().stripeCallback(id: orderId);
        if(response.statusCode == 200){
          CommonFunctions().showSuccessModal(context: context);
        }else{
          CommonFunctions().showSuccessModal(context: context, success: false);
        }
      });
    }catch(e){
      printMessage("__ STRIPE ERROR $e");
    }
  }

}