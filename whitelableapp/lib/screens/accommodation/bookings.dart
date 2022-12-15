
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
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          constraints: BoxConstraints(
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
                              Text("Status : ${bookingList[i]["status"]}"),
                              const SizedBox(height: 10,),
                              Text("check in : ${bookingList[i]["check_in"]}"),
                              const SizedBox(height: 10,),
                              Text("check out : ${bookingList[i]["check_out"]}"),
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
