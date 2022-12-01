
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/service/api.dart';

class BookingDetailScreen extends StatefulWidget {
  const BookingDetailScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {

  var bookingDetail;
  bool showProgress = true;

  @override
  void initState() {
    // TODO: implement initState
    getBookingDetail();
    super.initState();
  }

  Future<void> getBookingDetail()async{
    var response = await ServiceApis().getBookingDetail(id: widget.id);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      bookingDetail = data;
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
            title: const Text("Booking Detail"),
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
                child: bookingDetail != null ? Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bookingDetail["status"] == "confirmed" ? const Icon(Icons.done_all, color: Colors.green, size: 40,) : Icon(Icons.close_rounded, color: Colors.red, size: 40,),
                    Text(
                      bookingDetail["status"],
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: bookingDetail["status"] == "confirmed" ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Check in : ${bookingDetail["check_in"]}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Check out : ${bookingDetail["check_out"]}",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ) : const Center(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
