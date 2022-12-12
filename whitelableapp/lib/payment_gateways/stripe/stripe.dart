
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:whitelabelapp/screens/accommodation/booking_detail.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';

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
    print("_____ STRIPE INIT _____");
    Stripe.publishableKey = SharedPreference.getBusinessConfig()!.paymentKey;
    await openGateway();
  }
  
  Future<void> openGateway()async{

    print("_____ STRIPE GATEWAY OPEN _____");

    // final paymentMethod = await Stripe.instance.createPaymentMethod(
    //   params: const PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),
    // );
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          setupIntentClientSecret: "",
          merchantDisplayName: SharedPreference.getBusinessConfig()!.appName,
          // applePay: const PaymentSheetApplePay(
          //   merchantCountryCode: "+91",
          // ),
          style: ThemeMode.light,
          // googlePay: const PaymentSheetGooglePay(
          //   testEnv: true,
          //   merchantCountryCode: "+91",
          // ),
        ),
      );
      await Stripe.instance.presentPaymentSheet().then((value) async {
        var response = await ServiceApis().stripeCallback(id: orderId);
        if(response.statusCode == 200){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailScreen(id: id,)));
        }
      });
    }catch(e){
      print("__ STRIPE ERROR $e");
    }
  }

}