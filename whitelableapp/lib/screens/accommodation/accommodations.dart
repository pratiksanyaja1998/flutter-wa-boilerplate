import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whitelabelapp/components/drawer.dart';
import 'package:whitelabelapp/components/home_screen/accommodation_card.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/model/home_screen_models/accommodation_filter_model.dart';
import 'package:whitelabelapp/screens/accommodation/accommodation_detail.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';

class AccommodationScreen extends StatefulWidget {
  const AccommodationScreen({super.key});

  final String title = "Accommodations";

  @override
  State<AccommodationScreen> createState() => _AccommodationScreenState();
}

class _AccommodationScreenState extends State<AccommodationScreen> {

  List<dynamic> accommodationList = [];

  bool showProgress = true;
  int selectedItem = 0;

  bool filterApplied = false;

  DateTime? startDate;
  DateTime? endDate;
  bool lowToHigh = false;
  bool highToLow = false;
  double minPrice = 0.0;
  double maxPrice = 100.0;

  @override
  void initState() {
    // TODO: implement initState
    getAccommodations();
    super.initState();
  }

  Future<void> getAccommodations()async{
    if(SharedPreference.getUser() != null) {
      var response = await ServiceApis().getAccommodationList(
        startDate: startDate != null ? startDate.toString().split(" ")[0] : null,
        endDate: endDate != null ? endDate.toString().split(" ")[0] : null,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        accommodationList = data;
        showProgress = false;
        setState(() {});
      } else {
        showProgress = false;
        setState(() {});
      }
    }else{
      showProgress = false;
      setState(() {});
    }
  }

  Future<void> selectDate({required bool isStartDate})async{
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if(pickedDate != null){
      var utcTime = DateTime.utc(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
      if(isStartDate) {
        startDate = utcTime;
        print("-------------------------- START DATE ${startDate} ---------------------------");
      }else{
        endDate = utcTime;
        print("-------------------------- END DATE ${startDate} ---------------------------");
      }
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(getTranslated(context, ["Accommodations"])),
      ),
      drawer: DrawerItem().drawer(context, setState),
      body: Container(
        child: showProgress ? const Center(
          child: CircularProgressIndicator(
            color: kThemeColor,
          ),
        ) : Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: RefreshIndicator(
              onRefresh: ()async{
                // Future.delayed(const Duration(seconds: 0), (){});
                showProgress = true;
                setState(() {});
                getAccommodations();
              },
              child: Scrollbar(
                thickness: accommodationList.length < 10 ? 0 : 8,
                interactive: true,
                radius: const Radius.circular(4),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: accommodationList.isEmpty ?
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: const Center(
                      child: Text(
                        "sorry no accommodation available.",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ) : SharedPreference.isLogin() ? Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15,),
                      for(int i = 0; i < accommodationList.length; i++)
                        Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccommodationDetailScreen(
                                  accommodationList: accommodationList,
                                  index: i,
                                )));
                              },
                              child: AccommodationCard(
                                name: accommodationList[i]["name"],
                                description: accommodationList[i]["description"],
                                images: accommodationList[i]["images"],
                                price: accommodationList[i]["price_per_night"],
                                rating: (i+1.5).toDouble(),
                              ),
                            ),
                            // if(i < accommodationList.length - 1)
                            //   Container(
                            //     constraints: const BoxConstraints(
                            //       maxWidth: 370,
                            //     ),
                            //     margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            //     child: const Divider(
                            //       thickness: 2,
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                          ],
                        ),
                      const SizedBox(height: 15,),
                    ],
                  ) : const Center(),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              minHeight: MediaQuery.of(context).size.height,
            ),
            context: context,
            builder: (context){
              return StatefulBuilder(
                builder: (context, setstate) {
                  return AccommodationFilterModel(
                    apply: () async {
                      showProgress = true;
                      filterApplied = true;
                      setState(() {});
                      Navigator.pop(context);
                      await getAccommodations();
                    },
                    cancel: () async{
                      if(filterApplied){
                        showProgress = true;
                        startDate = null;
                        endDate = null;
                        lowToHigh = false;
                        highToLow = false;
                        minPrice = 0.0;
                        maxPrice = 100.0;
                        filterApplied = false;
                        setState(() {});
                        setstate((){});
                        Navigator.pop(context);
                        await getAccommodations();
                      }else{
                        Navigator.pop(context);
                      }
                    },
                    cancelText: filterApplied ? "Clear" : "Cancel",
                    selectStartDate: () async{
                      await selectDate(isStartDate: true);
                      setstate((){});
                    },
                    selectEndDate: () async{
                      await selectDate(isStartDate: false);
                      setstate((){});
                    },
                    selectPriceRange: (value) {
                      minPrice = double.parse(value.start.toStringAsFixed(2));
                      maxPrice = double.parse(value.end.toStringAsFixed(2));
                      setState(() {});
                      setstate(() {});
                    },
                    startDate: startDate,
                    endDate: endDate,
                    lowToHigh: lowToHigh,
                    selectLowToHigh: () {
                      lowToHigh = !lowToHigh;
                      highToLow = false;
                      setState(() {});
                      setstate(() {});
                    },
                    highToLow: highToLow,
                    selectHighToLow: () {
                      highToLow = !highToLow;
                      lowToHigh = false;
                      setState(() {});
                      setstate(() {});
                    },
                    minPrice: minPrice,
                    maxPrice: maxPrice,
                  );
                }
              );
              // return StatefulBuilder(
              //     builder: (context, setstate) {
              //       return Container(
              //         // height: MediaQuery.of(context).size.height,
              //         decoration: const BoxDecoration(
              //           borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              //           color: kPrimaryColor,
              //         ),
              //         child: Column(
              //           children: [
              //             const SizedBox(height: 20,),
              //             const Text(
              //               "Filter Date",
              //               style: TextStyle(
              //                 fontSize: 24,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.black,
              //               ),
              //             ),
              //             const SizedBox(height: 10,),
              //             Expanded(
              //               child: SingleChildScrollView(
              //                 child: Padding(
              //                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       const SizedBox(height: 10,),
              //                       Container(
              //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //                       decoration: BoxDecoration(
              //                         color: Colors.white,
              //                         borderRadius: BorderRadius.circular(8),
              //                         boxShadow: [
              //                           BoxShadow(
              //                             color: Colors.black.withOpacity(0.25),
              //                             blurRadius: 6,
              //                           )
              //                         ],
              //                       ),
              //                       child: GestureDetector(
              //                         onTap: () async {
              //                           DateTime? pickedDate = await showDatePicker(
              //                             context: context,
              //                             initialDate: DateTime.now(),
              //                             firstDate: DateTime(1950),
              //                             lastDate: DateTime(2100),
              //                           );
              //                           if(pickedDate != null){
              //                             var utcTime = DateTime.utc(
              //                               pickedDate.year,
              //                               pickedDate.month,
              //                               pickedDate.day,
              //                             );
              //                             startDate = utcTime;
              //                             print("-------------------------- ${startDate} ---------------------------");
              //                             setState((){});
              //                             setstate((){});
              //                           }
              //                         },
              //                         child: Row(
              //                           children: [
              //                             Expanded(
              //                               child: Text(
              //                                 startDate != null ? startDate.toString().split(" ")[0] : "Start date",
              //                                 style: const TextStyle(
              //                                   fontSize: 18,
              //                                 ),
              //                               ),
              //                             ),
              //                             const Icon(
              //                               Icons.calendar_today_rounded,
              //                               color: kThemeColor,
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                       const SizedBox(height: 20,),
              //                       Container(
              //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //                       decoration: BoxDecoration(
              //                         color: Colors.white,
              //                         borderRadius: BorderRadius.circular(8),
              //                         boxShadow: [
              //                           BoxShadow(
              //                             color: Colors.black.withOpacity(0.25),
              //                             blurRadius: 6,
              //                           )
              //                         ],
              //                       ),
              //                       child: GestureDetector(
              //                         onTap: () async {
              //                           DateTime? pickedDate = await showDatePicker(
              //                             context: context,
              //                             initialDate: DateTime.now(),
              //                             firstDate: DateTime(1950),
              //                             lastDate: DateTime(2100),
              //                           );
              //                           if(pickedDate != null){
              //                             var utcTime = DateTime.utc(
              //                               pickedDate.year,
              //                               pickedDate.month,
              //                               pickedDate.day,
              //                             );
              //                             endDate = utcTime;
              //                             print("-------------------------- ${endDate} ---------------------------");
              //                             setState((){});
              //                             setstate((){});
              //                           }
              //                         },
              //                         child: Row(
              //                           children: [
              //                             Expanded(
              //                               child: Text(
              //                                 endDate != null ? endDate.toString().split(" ")[0] : "Start date",
              //                                 style: const TextStyle(
              //                                   fontSize: 18,
              //                                 ),
              //                               ),
              //                             ),
              //                             const Icon(Icons.calendar_today_rounded, color: kThemeColor,),
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                       const SizedBox(height: 30,),
              //                       const Padding(
              //                         padding: EdgeInsets.symmetric(horizontal: 8.0),
              //                         child: Text(
              //                           "Sort by price",
              //                           style: TextStyle(
              //                             fontSize: 18,
              //                             fontWeight: FontWeight.bold,
              //                             color: Colors.black,
              //                           ),
              //                         ),
              //                       ),
              //                       const SizedBox(height: 10,),
              //                       RangeSlider(
              //                         values: RangeValues(minPrice, maxPrice),
              //                         min: 0,
              //                         max: 200,
              //                         labels: RangeLabels(minPrice.toString(), maxPrice.toString()),
              //                         activeColor: kThemeColor,
              //                         onChanged: (val){
              //                           maxPrice = double.parse(val.end.toStringAsFixed(2));
              //                           minPrice = double.parse(val.start.toStringAsFixed(2));
              //                           setstate((){});
              //                         },
              //                       ),
              //                       Padding(
              //                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //                         child: Row(
              //                           children: [
              //                             Text("Min: $minPrice"),
              //                             Expanded(child: Center(),),
              //                             Text("Max: $maxPrice"),
              //                           ],
              //                         ),
              //                       ),
              //                       const SizedBox(height: 20,),
              //                       Container(
              //                         decoration: BoxDecoration(
              //                           color: Colors.white,
              //                           borderRadius: BorderRadius.circular(8),
              //                           boxShadow: [
              //                             BoxShadow(
              //                               color: Colors.black.withOpacity(0.25),
              //                               blurRadius: 6,
              //                             )
              //                           ],
              //                         ),
              //                         child: Material(
              //                           elevation: 0,
              //                           color: Colors.transparent,
              //                           child: ListTile(
              //                             leading: Checkbox(
              //                               value: highToLow,
              //                               onChanged: null,
              //                               fillColor: MaterialStateProperty.all(kThemeColor),
              //                             ),
              //                             onTap: (){
              //                               highToLow = !highToLow;
              //                               setstate((){});
              //                             },
              //                             title: const Text(
              //                               "high to low",
              //                               style: TextStyle(
              //                                 fontSize: 16,
              //                               ),
              //                             ),
              //                             shape: RoundedRectangleBorder(
              //                               borderRadius: BorderRadius.circular(8),
              //                             ),
              //                             dense: true,
              //                             tileColor: kPrimaryColor,
              //                           ),
              //                         ),
              //                       ),
              //                       const SizedBox(height: 20,),
              //                       Container(
              //                         decoration: BoxDecoration(
              //                           color: Colors.white,
              //                           borderRadius: BorderRadius.circular(8),
              //                           boxShadow: [
              //                             BoxShadow(
              //                               color: Colors.black.withOpacity(0.25),
              //                               blurRadius: 6,
              //                             ),
              //                           ],
              //                         ),
              //                         child: Material(
              //                           elevation: 0,
              //                           color: Colors.transparent,
              //                           child: ListTile(
              //                             leading: Checkbox(
              //                               value: lowToHigh,
              //                               onChanged: null,
              //                               fillColor: MaterialStateProperty.all(kThemeColor),
              //                             ),
              //                             onTap: (){
              //                               lowToHigh = !lowToHigh;
              //                               setstate((){});
              //                             },
              //                             title: const Text(
              //                               "low to high",
              //                               style: TextStyle(
              //                                 fontSize: 16,
              //                               ),
              //                             ),
              //                             shape: RoundedRectangleBorder(
              //                               borderRadius: BorderRadius.circular(8),
              //                             ),
              //                             dense: true,
              //                             tileColor: kPrimaryColor,
              //                           ),
              //                         ),
              //                       ),
              //                       const SizedBox(height: 20,),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             Padding(
              //               padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 20),
              //               child: Row(
              //                 children: [
              //                   Expanded(
              //                     child: Widgets().textButton(
              //                       onPressed: () async {
              //                         showProgress = true;
              //                         setState(() {});
              //                         Navigator.pop(context);
              //                         await getAccommodations(startDate: startDate.toString().split(" ")[0], endDate: endDate.toString().split(" ")[0]);
              //                       },
              //                       text: "Apply",
              //                       fontSize: 20,
              //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     }
              // );
            },
          );
        },
        child: const Icon(Icons.filter_alt_rounded),
      ),
    );
  }
}