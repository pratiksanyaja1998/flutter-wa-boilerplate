
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/screens/booking_detail.dart';
import 'package:whitelableapp/screens/bookings.dart';

class CashFree{

  CashFree({
    required this.context,
    required this.id,
    required this.orderId,
    required this.orderToken,
  });

  final BuildContext context;
  final int id;
  final String orderId;
  final String orderToken;

  var cfPaymentGatewayService = CFPaymentGatewayService();

  void init(){
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
    openGateway();
  }

  CFEnvironment environment = CFEnvironment.SANDBOX;

  void verifyPayment(String orderId) {
    print("Verify Payment");
    // if(response != null && response == "success") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => BookingDetailScreen(id: id,)));
    // }
  }

  void onError(CFErrorResponse errorResponse, String orderid) {
    print("Error while making payment");
    print("orderId ${orderid}");
    print("orderId ${orderId}");
    print("Error while making payment : ${errorResponse}");
    print("Error while making payment : ${errorResponse.getCode()}");
    print("Error while making payment : ${errorResponse.getMessage()}");
    print("Error while making payment : ${errorResponse.getStatus()}");
  }

  CFSession? createSession() {
    try {
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(orderId).setOrderToken(orderToken).build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }

  Future<void> openGateway()async{

    print("CREATING CASHFREE GATEWAY");

    try {
      var session = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.UPI);
      components.add(CFPaymentModes.CARD);
      components.add(CFPaymentModes.WALLET);
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#${kThemeColor.toString().substring(10).replaceAll(")", "")}").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();

      var response = await cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);

      // Navigator.push(context, MaterialPageRoute(builder: (context) => BookingsScreen()));

    } on CFException catch (e) {
      print(e.message);
    }catch (e){
      print("ERROR DOING CASHFREE PAYMENT : $e");
    }
  }

}