
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/payment_gateways/cashfree/cashfree.dart';
import 'package:whitelableapp/payment_gateways/paytm/paytm.dart';
import 'package:whitelableapp/payment_gateways/razor_pay/razor_pay.dart';
import 'package:whitelableapp/payment_gateways/stripe/stripe.dart';
import 'package:whitelableapp/service/api.dart';
import 'package:whitelableapp/service/shared_preference.dart';
import 'package:whitelableapp/widgets/widgets.dart';
import 'package:intl/intl.dart';

class AccommodationDetailScreen extends StatefulWidget {
  const AccommodationDetailScreen({
    Key? key,
    required this.accommodationList,
    required this.index,
  }) : super(key: key);

  final List<dynamic> accommodationList;
  final int index;

  @override
  State<AccommodationDetailScreen> createState() => _AccommodationDetailScreenState();
}

class _AccommodationDetailScreenState extends State<AccommodationDetailScreen> {

  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accommodation detail"),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 370,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          minWidth: 370,
                          maxHeight: 230,
                          minHeight: 230,
                          maxWidth: 370,
                        ),
                        decoration: BoxDecoration(
                          color: kThemeColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(widget.accommodationList[widget.index]["images"][0]["image"],fit: BoxFit.cover,),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.accommodationList[widget.index]["name"],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      height: 1
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(
                                    "${widget.accommodationList[widget.index]["price_per_night"]} / night",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "${widget.accommodationList[widget.index]["qty_per_day"]} / day",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(widget.accommodationList[widget.index]["images"].length > 1)
                              GestureDetector(
                                onTap: ()async{
                                  await showDialog(
                                    context: context,
                                    barrierColor: Colors.black.withOpacity(0.7),
                                    builder: (context){

                                      PageController pageController = PageController();

                                      return StatefulBuilder(
                                        builder: (context, setstate) {
                                          return Stack(
                                            children: [
                                              PageView(
                                                controller: pageController,
                                                children: [
                                                  for(int i = 0; i < widget.accommodationList[widget.index]["images"].length; i++)
                                                    Image.network(
                                                      widget.accommodationList[widget.index]["images"][i]["image"], fit: MediaQuery.of(context).size.width > 700 ? BoxFit.none : BoxFit.fitWidth,
                                                      loadingBuilder: (context, child, loadingProgress){
                                                        if(loadingProgress != null){
                                                          return const Center(
                                                            child: CircularProgressIndicator(
                                                              color: kThemeColor,
                                                              strokeWidth: 3,
                                                            ),
                                                          );
                                                        }else{
                                                          return child;
                                                        }
                                                      },
                                                    ),
                                                ],
                                              ),
                                              Positioned(
                                                bottom: 40,
                                                left: 0,
                                                right: 0,
                                                child: Center(
                                                  child: Container(
                                                    constraints: const BoxConstraints(
                                                      maxWidth: 370,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Center(
                                                          child: Container(
                                                            margin: const EdgeInsets.all(10),
                                                            width: 35,
                                                            height: 35,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(15),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.black.withOpacity(0.4),
                                                                    blurRadius: 8
                                                                )
                                                              ],
                                                            ),
                                                            child: Widgets().textButton(
                                                              onPressed: (){
                                                                pageController.previousPage(duration: Duration(milliseconds: 600), curve: Curves.ease);
                                                              },
                                                              text: "Go back",
                                                              backgroundColor: Colors.white,
                                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                                              child: const Icon(Icons.arrow_back_ios_rounded, color: kThemeColor, size: 18,),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            margin: const EdgeInsets.all(20),
                                                            child: Widgets().textButton(
                                                              onPressed: (){
                                                                Navigator.of(context).pop();
                                                              },
                                                              text: "CLOSE",
                                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 15 : 10),
                                                            ),
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Container(
                                                            margin: const EdgeInsets.all(10),
                                                            height: 35,
                                                            width: 35,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(15),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.black.withOpacity(0.4),
                                                                    blurRadius: 8
                                                                )
                                                              ],
                                                            ),
                                                            child: Widgets().textButton(
                                                              onPressed: (){
                                                                pageController.nextPage(duration: Duration(milliseconds: 600), curve: Curves.ease);
                                                              },
                                                              text: "Go forward",
                                                              backgroundColor: Colors.white,
                                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                                              child: const Icon(Icons.arrow_forward_ios_rounded, color: kThemeColor, size: 18,),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    },
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 6
                                          )
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          widget.accommodationList[widget.index]["images"][1]["image"],
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),),
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        child: Text(
                                          "${widget.accommodationList[widget.index]["images"].length - 1}+",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          widget.accommodationList[widget.index]["description"],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 370,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Widgets().textButton(
                        onPressed: (){
                          checkInDate = null;
                          checkOutDate = null;
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context){
                              return StatefulBuilder(
                                builder: (context, setstate) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                      color: kPrimaryColor,
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.topCenter,
                                      //   end: Alignment.bottomCenter,
                                      //   colors: [
                                      //     kThemeColor,
                                      //     Colors.white,
                                      //   ],
                                      // )
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Book now",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Expanded(child: Center()),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 6,
                                              )
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {
                                              DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2100),
                                              );
                                              TimeOfDay? pickedTime = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if(pickedDate != null && pickedTime != null){
                                                var utcTime = DateTime.utc(
                                                  pickedDate.year,
                                                  pickedDate.month,
                                                  pickedDate.day,
                                                  pickedTime.hour,
                                                  pickedTime.minute,
                                                );
                                                checkInDate = utcTime;
                                                setState((){});
                                                setstate((){});
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    checkInDate != null ? DateFormat.yMMMEd().format(checkInDate!) : "Check in",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.calendar_today_rounded,
                                                  color: kThemeColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20,),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 6,
                                              )
                                            ],
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {
                                              DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime(2100),
                                              );
                                              TimeOfDay? pickedTime = await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                              );
                                              if(pickedDate != null && pickedTime != null){
                                                var utcTime = DateTime.utc(
                                                  pickedDate.year,
                                                  pickedDate.month,
                                                  pickedDate.day,
                                                  pickedTime.hour,
                                                  pickedTime.minute,
                                                );
                                                checkOutDate = utcTime;
                                                setState((){});
                                                setstate((){});
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    checkOutDate != null ? DateFormat.yMMMEd().format(checkOutDate!) : "Check out",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                const Icon(Icons.calendar_today_rounded, color: kThemeColor,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Center()),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Widgets().textButton(
                                                onPressed: () async {
                                                  if(checkInDate != null && checkOutDate != null){
                                                    var response = await ServiceApis().createBooking(
                                                      checkInDate: checkInDate!.toIso8601String(),
                                                      checkOutDate: checkOutDate!.toIso8601String(),
                                                      accommodationId: widget.accommodationList[widget.index]["id"],
                                                    );
                                                    if(response.statusCode == 201){
                                                      int id = jsonDecode(response.body)["id"];
                                                      var data = jsonDecode(response.body)["payment"];
                                                      if(!kIsWeb) {
                                                        if (SharedPreference
                                                            .getBusinessConfig()!
                                                            .paymentType ==
                                                            "paytm") {
                                                          await Paytm()
                                                              .doPayment(
                                                            id: id,
                                                            context: context,
                                                            orderId: data["id"]
                                                                .toString(),
                                                            amount: data["paid_amount"]
                                                                .toString(),
                                                            txnToken: data["payment_order_key"]
                                                                .toString(),
                                                          );
                                                        } else
                                                        if (SharedPreference
                                                            .getBusinessConfig()!
                                                            .paymentType ==
                                                            "razorpay") {
                                                          RazorPay(
                                                            id: id,
                                                            context: context,
                                                            order: data,
                                                          ).init();
                                                        }
                                                      }
                                                      if (SharedPreference
                                                          .getBusinessConfig()!
                                                          .paymentType ==
                                                          "cashfree") {
                                                        CashFree(
                                                          id: id,
                                                          context: context,
                                                          orderId: data["payment_cashfree_order_id"]
                                                              .toString(),
                                                          orderToken: data["payment_order_key"],
                                                        ).init();
                                                      }else
                                                      if (SharedPreference
                                                          .getBusinessConfig()!
                                                          .paymentType ==
                                                          "stripe") {
                                                        StripePg(
                                                          id: id,
                                                          context: context,
                                                          orderId: data["id"]
                                                              .toString(),
                                                          clientSecret: data["payment_key"]
                                                              .toString(),
                                                        ).init();
                                                      }
                                                    }
                                                  }
                                                },
                                                text: "Book",
                                                fontSize: 20,
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              );
                            },
                          );
                        },
                        text: "Book Now",
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
