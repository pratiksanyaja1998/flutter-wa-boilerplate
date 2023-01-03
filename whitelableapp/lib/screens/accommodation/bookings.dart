
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/screens/accommodation/booking_detail.dart';
import 'package:whitelabelapp/service/api.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {

  List<dynamic> bookingList = [];
  bool showProgress = true;

  @override
  void initState() {
    // TODO: implement initState
    getBookings();
    super.initState();
  }

  Future<void> getBookings()async{
    var response = await ServiceApis().getBookingsList();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      bookingList = data;
      showProgress = false;
      if(mounted) {
        setState(() {});
      }
    } else {
      showProgress = false;
      if(mounted) {
        setState(() {});
      }
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
            title: const Text("Bookings"),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: showProgress ? const CircularProgressIndicator(
              color: kThemeColor,
            ) : Container(
              constraints: const BoxConstraints(
                maxWidth: 370,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for(int i = 0; i < bookingList.length; i++)
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailScreen(id: bookingList[i]["id"])));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          constraints: const BoxConstraints(
                            maxWidth: 370,
                            minWidth: 370,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Status ",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 25.5,),
                                  Text(
                                    ": ${bookingList[i]["status"].toString()[0].toUpperCase()}${bookingList[i]["status"].toString().substring(1)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  const Text(
                                    "Check in ",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                  Text(
                                    ": ${bookingList[i]["check_in"]}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                children: [
                                  const Text(
                                    "Check out ",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    ": ${bookingList[i]["check_out"]}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              //
                              // RichText(
                              //   text: TextSpan(
                              //     text: "Status ",
                              //       style: const TextStyle(
                              //         color: Colors.black,
                              //       ),
                              //     children: [
                              //       TextSpan(
                              //         text: ": ${bookingList[i]["status"]}",
                              //         style: const TextStyle(
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       )
                              //     ]
                              //   ),
                              // ),
                              // const SizedBox(height: 5,),
                              // RichText(
                              //   text: TextSpan(
                              //       text: "Check in ",
                              //       style: const TextStyle(
                              //         color: Colors.black,
                              //       ),
                              //       children: [
                              //         TextSpan(
                              //           text: ": ${bookingList[i]["check_in"]}",
                              //           style: const TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         )
                              //       ]
                              //   ),
                              // ),
                              // const SizedBox(height: 5,),
                              // RichText(
                              //   text: TextSpan(
                              //       text: "Check out ",
                              //       style: const TextStyle(
                              //         color: Colors.black,
                              //       ),
                              //       children: [
                              //         TextSpan(
                              //           text: ": ${bookingList[i]["check_out"]}",
                              //           style: const TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         )
                              //       ]
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
