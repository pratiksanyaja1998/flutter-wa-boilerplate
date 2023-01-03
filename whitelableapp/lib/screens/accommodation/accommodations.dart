import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/components/drawer.dart';
import 'package:whitelabelapp/components/home_screen/accommodation_card.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/model/home_screen_models/accommodation_filter_model.dart';
import 'package:whitelabelapp/screens/accommodation/accommodation_detail.dart';
import 'package:whitelabelapp/screens/profile_settings.dart';
import 'package:whitelabelapp/service/api.dart';

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

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  bool lowToHigh = false;
  bool highToLow = false;
  double minPrice = 0.0;
  double maxPrice = 100.0;

  @override
  void initState() {
    getAccommodations();
    super.initState();
  }

  Future<void> getAccommodations()async{
    if(SharedPreference.getUser() != null) {
      var response = await ServiceApis().getAccommodationList(
        startDate: DateFormat("yyyy-MM-dd").format(startDate),
        endDate: DateFormat("yyyy-MM-dd").format(endDate),
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        accommodationList = data;
        showProgress = false;
        setState(() {});
      } else {
        showProgress = false;
        setState(() {});
        if(!mounted) return;
        CommonFunctions().showError(data: data, context: context);
      }
    }else{
      showProgress = false;
      setState(() {});
    }
  }

  Future<dynamic> selectDate({required bool isStartDate, required DateTime start, required DateTime end,})async{
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? start : end.isBefore(start) ? start : end,
      firstDate: isStartDate ? DateTime.now() : start,
      lastDate: DateTime(2100),
    );
    if(pickedDate != null){
      if(!mounted) return;
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if(pickedTime != null) {
        var date = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        return date;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(getTranslated(context, ["Accommodations"])),
        actions: [
          if(SharedPreference.isLogin())
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileSettingsScreen())).then((value) {
                  setState(() {});
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Widgets().networkImageContainer(imageUrl: SharedPreference.getUser()!.photo, width: 40, height: 40),
                ),
              ),
            ),
        ],
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
                                  startDate: startDate,
                                  endDate: endDate  ,
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
              DateTime start = startDate;
              DateTime end = endDate;
              return StatefulBuilder(
                builder: (context, setstate) {
                  return AccommodationFilterModel(
                    apply: () async {
                      startDate = start;
                      endDate = end;
                      showProgress = true;
                      filterApplied = true;
                      setState(() {});
                      Navigator.pop(context);
                      await getAccommodations();
                    },
                    cancel: () async{
                      if(filterApplied){
                        showProgress = true;
                        startDate = DateTime.now();
                        endDate = DateTime.now().add(const Duration(days: 5));
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
                      var date = await selectDate(isStartDate: true, start: start, end: end);
                      start = date;
                      if(end.isBefore(start)){
                        end = date;
                      }
                      printMessage("-------------------------- START DATE $start ---------------------------");
                      setstate((){});
                      setState(() {});
                    },
                    selectEndDate: () async{
                      var date = await selectDate(isStartDate: false, start: start, end: end);
                      end = date;
                      printMessage("-------------------------- END DATE $startDate ---------------------------");
                      setstate((){});
                    },
                    selectPriceRange: (value) {
                      minPrice = double.parse(value.start.toStringAsFixed(2));
                      maxPrice = double.parse(value.end.toStringAsFixed(2));
                      setState(() {});
                      setstate(() {});
                    },
                    startDate: start,
                    endDate: end,
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
            },
          );
        },
        child: const Icon(Icons.filter_alt_rounded),
      ),
    );
  }
}