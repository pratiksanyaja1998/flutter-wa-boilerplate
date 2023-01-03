
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/payment_gateways/cashfree/cashfree.dart';
import 'package:whitelabelapp/payment_gateways/paytm/paytm.dart';
import 'package:whitelabelapp/payment_gateways/razor_pay/razor_pay.dart';
import 'package:whitelabelapp/payment_gateways/stripe/stripe.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:intl/intl.dart';

class AccommodationDetailScreen extends StatefulWidget {
  const AccommodationDetailScreen({
    Key? key,
    required this.accommodationList,
    required this.index,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  final List<dynamic> accommodationList;
  final int index;
  final DateTime startDate;
  final DateTime endDate;

  @override
  State<AccommodationDetailScreen> createState() => _AccommodationDetailScreenState();
}

class _AccommodationDetailScreenState extends State<AccommodationDetailScreen> {

  PageController pageController = PageController(
    viewportFraction: 0.85,
  );
  int currentIndex = 0;

  bool showProgress = false;

  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accommodation detail"),
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: 370,
              ),
              // padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 410,
                                  maxHeight: 270,
                                  minHeight: 270,
                                  maxWidth: 410,
                                ),
                                child: PageView.builder(
                                  controller: pageController,
                                  itemCount: widget.accommodationList[widget.index]["images"].length,
                                  onPageChanged: (value){
                                    currentIndex = value;
                                    setState(() {});
                                  },
                                  itemBuilder: (context, index){
                                    var scale = currentIndex == index ? 1.00 : 0.91;
                                    return TweenAnimationBuilder(
                                      duration: const Duration(milliseconds: 500),
                                      tween: Tween(begin: scale, end: scale),
                                      curve: Curves.ease,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                                        constraints: const BoxConstraints(
                                          minWidth: 370,
                                          maxHeight: 230,
                                          minHeight: 230,
                                          maxWidth: 370,
                                        ),
                                        decoration: BoxDecoration(
                                          color: kThemeColor,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              blurRadius: 8,
                                            )
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(widget.accommodationList[widget.index]["images"][index]["image"],fit: BoxFit.cover,),
                                        ),
                                      ),
                                      builder: (context, double value, child){
                                        return Transform.scale(
                                          scale: value,
                                          child: child,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                right: 35,
                                bottom: 30,
                                child: GestureDetector(
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
                                                                    pageController.previousPage(duration: const Duration(milliseconds: 600), curve: Curves.ease);
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
                                                                    pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.ease);
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: IntrinsicWidth(
                                      child: Row(
                                        children: [
                                          const Icon(CupertinoIcons.photo_on_rectangle, color: Colors.white, size: 20,),
                                          const SizedBox(width: 10,),
                                          Text(
                                            "${currentIndex+1}/${widget.accommodationList[widget.index]["images"].length}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                ReadMoreText(
                                  widget.accommodationList[widget.index]["description"],
                                  trimLines: 4,
                                  colorClickableText: Colors.blue,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  moreStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                  lessStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                RichText(
                                  text: TextSpan(
                                    text: "From : ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: DateFormat("dd MMM yyyy hh:mm a").format(widget.startDate),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                RichText(
                                  text: TextSpan(
                                    text: "To      : ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: DateFormat("dd MMM yyyy hh:mm a").format(widget.endDate),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                const Text(
                                  "Total price",
                                  style: TextStyle(
                                    fontSize: 16,
                                    // fontWeight: FontWeight.w500
                                  ),
                                ),
                                Text(
                                  "${SharedPreference.getBusinessConfig()!.currencySymbol} ${totalPrice()}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                const Text(
                                  "Price distribution",
                                  style: TextStyle(
                                    fontSize: 16,
                                    // fontWeight: FontWeight.w500
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      for(int i = 0; i < widget.accommodationList[widget.index]["price_per_night"]["data"].length; i++)
                                        Container(
                                          margin: const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: Colors.black),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.accommodationList[widget.index]["price_per_night"]["data"].keys.toList()[i])),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "${SharedPreference.getBusinessConfig()!.currencySymbol} ${widget.accommodationList[widget.index]["price_per_night"]["data"].values.toList()[i].toString()}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
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
                                builder: (_){
                                  return StatefulBuilder(
                                    builder: (_, setstate) {
                                      return Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                          color: kPrimaryColor,
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
                                            const Expanded(child: Center()),
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
                                                  if(!mounted) return;
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
                                                  if(!mounted) return;
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
                                            const Expanded(child: Center()),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Widgets().textButton(
                                                    onPressed: () async {
                                                      if(checkInDate != null && checkOutDate != null){
                                                        showProgress = true;
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                        var response = await ServiceApis().createBooking(
                                                          checkInDate: checkInDate!.toIso8601String(),
                                                          checkOutDate: checkOutDate!.toIso8601String(),
                                                          accommodationId: widget.accommodationList[widget.index]["id"],
                                                        );
                                                        if(response.statusCode == 201){
                                                          int id = jsonDecode(response.body)["id"];
                                                          var data = jsonDecode(response.body)["payment"];
                                                          if(!kIsWeb) {
                                                            if(!mounted) return;
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
                                                            if (SharedPreference
                                                                .getBusinessConfig()!
                                                                .paymentType ==
                                                                "razorpay") {
                                                              await RazorPay(
                                                                id: id,
                                                                context: context,
                                                                order: data,
                                                              ).init().then((value){
                                                                showProgress = false;
                                                                setState(() {});
                                                              });
                                                            }
                                                          }
                                                          if(!mounted) return;
                                                          if (SharedPreference
                                                              .getBusinessConfig()!
                                                              .paymentType ==
                                                              "cashfree") {
                                                            await CashFree(
                                                              id: id,
                                                              context: context,
                                                              orderId: data["payment_cashfree_order_id"]
                                                                  .toString(),
                                                              orderToken: data["payment_order_key"],
                                                            ).init().then((value){
                                                              showProgress = false;
                                                              setState(() {});
                                                            });
                                                          }else
                                                          if (SharedPreference
                                                              .getBusinessConfig()!
                                                              .paymentType ==
                                                              "stripe") {
                                                            await StripePg(
                                                              id: id,
                                                              context: context,
                                                              orderId: data["id"]
                                                                  .toString(),
                                                              clientSecret: data["payment_key"]
                                                                  .toString(),
                                                            ).init().then((value){
                                                              showProgress = false;
                                                              setState(() {});
                                                            });
                                                          }
                                                        }else{
                                                          showProgress = false;
                                                          setState(() {});
                                                          if(!mounted) return;
                                                          CommonFunctions().showAlertDialog(alertMessage: "Something went wrong.", context: context);
                                                        }
                                                      }
                                                    },
                                                    text: "Book",
                                                    fontSize: 24,
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
            if(showProgress)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: kThemeColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String totalPrice(){
    double total = 0.0;
    List<dynamic> prices = widget.accommodationList[widget.index]["price_per_night"]["data"].values.toList();
    for(int i = 0; i < prices.length; i++){
      total = total + prices[i];
    }
    return total.toString();
  }

}
