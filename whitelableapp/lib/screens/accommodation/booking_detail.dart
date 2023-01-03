
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/payment_gateways/cashfree/cashfree.dart';
import 'package:whitelabelapp/payment_gateways/paytm/paytm.dart';
import 'package:whitelabelapp/payment_gateways/razor_pay/razor_pay.dart';
import 'package:whitelabelapp/payment_gateways/stripe/stripe.dart';
import 'package:whitelabelapp/service/api.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({Key? key, required this.id,}) : super(key: key);

  final int id;

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {

  dynamic bookingDetail;
  dynamic paymentDetail;
  bool showProgress = true;

  @override
  void initState() {
    getBookingDetail();
    super.initState();
  }

  Future<void> getBookingDetail()async{
    var response = await ServiceApis().getBookingDetail(id: widget.id);
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      bookingDetail = data;
      await getPaymentDetail();
      showProgress = false;
      if(!mounted) return;
      setState(() {});
    } else {
      showProgress = false;
      if(!mounted) return;
      setState(() {});
      CommonFunctions().showError(data: data, context: context);
    }
  }

  Future<void> getPaymentDetail()async{
    var response = await ServiceApis().getPaymentDetail(paymentId: bookingDetail["payment"].toString());
    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      paymentDetail = data;
    }else{
      if(!mounted) return;
      CommonFunctions().showError(data: data, context: context);
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
              ]
          )
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Booking Detail"),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: showProgress ? const Center(
            child: CircularProgressIndicator(
              color: kThemeColor,
            ),
          ) : Container(
            constraints: const BoxConstraints(
              maxWidth: 370,
            ),
            child: SingleChildScrollView(
              child: bookingDetail != null ? Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    constraints: const BoxConstraints(
                      maxWidth: 450,
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
                          "Booking Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        detailField(
                          labelText: "Booking Status : ",
                          detail: "${bookingDetail["status"].toString()[0].toUpperCase()}${bookingDetail["status"].toString().substring(1).toLowerCase()}",
                        ),
                        detailField(
                          labelText: "Booking No : ",
                          detail: bookingDetail!["id"].toString(),
                        ),
                        detailField(
                          labelText: "Check in : ",
                          detail: DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(bookingDetail["check_in"])),
                        ),
                        detailField(
                          labelText: "Check out : ",
                          detail: DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(bookingDetail["check_out"])),
                        ),
                        detailField(
                          labelText: "Accommodation id : ",
                          detail: bookingDetail!["accommodation"].toString(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    constraints: const BoxConstraints(
                      maxWidth: 450,
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
                          "Payment Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        detailField(
                          labelText: "Payment Amount : ",
                          detail: "${SharedPreference.getBusinessConfig()!.currencySymbol} ${paymentDetail!["data"]["paid_amount"].toString()}",
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
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 450,
                      ),
                      margin: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Widgets().textButton(
                              onPressed: ()async{
                                showProgress = true;
                                setState(() {});
                                int id = bookingDetail["id"];
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
                                        CommonFunctions().showAlertDialog(alertMessage: "Something went wrong.", context: context);
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
                                if(!mounted) return;
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
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Widgets().textButton(
                            onPressed: ()async{
                              printMessage("---------------- ${bookingDetail["id"]}");
                              await ServiceApis().cancelBooking(
                                status: "requested",
                                message: "Booking cancel request",
                                user: bookingDetail["user"],
                                bookingId: widget.id,
                              );
                            },
                            text: "Cancel booking",
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ) : const Center(),
            ),
          ),
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
