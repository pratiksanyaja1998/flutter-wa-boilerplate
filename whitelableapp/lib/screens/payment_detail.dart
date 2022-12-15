
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/payment_gateways/cashfree/cashfree.dart';
import 'package:whitelabelapp/payment_gateways/paytm/paytm.dart';
import 'package:whitelabelapp/payment_gateways/razor_pay/razor_pay.dart';
import 'package:whitelabelapp/payment_gateways/stripe/stripe.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class PaymentDetailScreen extends StatefulWidget {
  const PaymentDetailScreen({Key? key, required this.donationData}) : super(key: key);

  final Map<dynamic, dynamic> donationData;

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {

  bool showProgress = true;
  Map<dynamic, dynamic>? paymentDetail;

  @override
  void initState() {
    // TODO: implement initState
    getPaymentDetail();
    super.initState();
  }

  Future<void> getPaymentDetail()async{
    var response = await ServiceApis().getPaymentDetail(paymentId: widget.donationData["payment"].toString());
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      paymentDetail = data;
      showProgress = false;
      setState(() {});
    }else{
      showProgress = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kThemeColor,
            Colors.white,
          ],
        )
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Donation detail"),
        ),
        body: Center(
          child: showProgress ? const CircularProgressIndicator(
            color: kThemeColor,
          ) : paymentDetail != null ? Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                constraints: const BoxConstraints(
                  maxWidth: 370,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 6
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    detailField(
                      labelText: "Payment No. ",
                      detail: "ORD${paymentDetail!["data"]["id"].toString().padLeft(6, "0")}",
                    ),
                    detailField(
                      labelText: "Payment Date : ",
                      detail: DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(paymentDetail!["data"]["created_at"])),
                    ),
                    detailField(
                      labelText: "Payment Status : ",
                      detail: paymentDetail!["data"]["status"].toString().toUpperCase(),
                    ),
                    detailField(
                      labelText: "Payment Method : ",
                      detail: paymentDetail!["data"]["payment_method"]["type"],
                    ),
                  ],
                ),
              ),
              if(paymentDetail!["data"]["status"] == "unpaid")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Widgets().textButton(
                          onPressed: ()async{
                            showProgress = true;
                            setState(() {});
                            int id = widget.donationData["id"];
                            if(!kIsWeb) {
                              if (paymentDetail!["data"]["payment_method"]["type"] == "paytm") {
                                await Paytm().doPayment(
                                  id: id,
                                  context: context,
                                  orderId: paymentDetail!["data"]["id"].toString(),
                                  amount: paymentDetail!["data"]["paid_amount"].toString(),
                                  txnToken: paymentDetail!["data"]["payment_order_key"].toString(),
                                ).then((value) {
                                  if(value == true){
                                    showProgress = false;
                                    setState(() {});
                                  }else{
                                    showProgress = false;
                                    setState(() {});
                                    Widgets().showAlertDialog(alertMessage: "Something went wrong.", context: context);
                                  }
                                });
                              } else
                              if (paymentDetail!["data"]["payment_method"]["type"] == "razorpay") {
                                await RazorPay(
                                    id: id,
                                    context: context,
                                    order: paymentDetail!["data"],
                                ).init().then((value){
                                  showProgress = false;
                                  setState(() {});
                                });
                              }
                            }
                            if (paymentDetail!["data"]["payment_method"]["type"] == "cashfree") {
                              await CashFree(
                                id: id,
                                context: context,
                                orderId: paymentDetail!["data"]["payment_cashfree_order_id"].toString(),
                                orderToken: paymentDetail!["data"]["payment_order_key"],
                              ).init().then((value){
                                showProgress = false;
                                setState(() {});
                              });
                            }else if (paymentDetail!["data"]["payment_method"]["type"] == "stripe") {
                              await StripePg(
                                id: id,
                                context: context,
                                orderId: paymentDetail!["data"]["id"].toString(),
                                clientSecret: paymentDetail!["data"]["payment_key"].toString(),).init().then((value){
                                  showProgress = false;
                                  setState(() {});
                                });
                            }
                            getPaymentDetail();
                          },
                          text: "Pay",
                          fontSize: 22,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ) : Text("Sorry something went wrong"),
        ),
      ),
    );
  }

  Widget detailField({required String labelText, required String detail}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
