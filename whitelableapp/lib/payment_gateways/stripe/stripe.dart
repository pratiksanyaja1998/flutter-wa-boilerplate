

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:whitelableapp/screens/booking_detail.dart';
import 'package:whitelableapp/screens/bookings.dart';
import 'package:whitelableapp/service/api.dart';
import 'package:whitelableapp/service/shared_preference.dart';

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

  void init(){
    print("_____ STRIPE INIT _____");
    Stripe.publishableKey = SharedPreference.getBusinessConfig()!.paymentKey;
    openGateway();
  }
  
  Future<void> openGateway()async{

    print("_____ STRIPE GATEWAY OPEN _____");

    // final paymentMethod = await Stripe.instance.createPaymentMethod(
    //   params: const PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),
    // );
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // customFlow: true,
          // customerId: "",
          // customerEphemeralKeySecret: "",
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
          // allowsDelayedPaymentMethods: false,
          // appearance: PaymentSheetAppearance(),
          // billingDetails: BillingDetails(
          //   email: SharedPreference.getUser()!.email,
          //   phone: SharedPreference.getUser()!.phone,
          //   name: SharedPreference.getUser()!.firstName,
          // ),
          // returnURL: "https://192.168.1.15:8000/payment/stripe/callback/$orderId",
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