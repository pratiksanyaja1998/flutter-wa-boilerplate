
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  bool showProgress = false;

  DateTime? startDate;
  DateTime? endDate;

  List<dynamic>? reportList;

  Future<void> getReport({required String startDate, required String endDate})async{
    showProgress = true;
    setState(() {});
    var response = await ServiceApis().getDeveloperReport(startDate: startDate, endDate: endDate);
    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      reportList = data;
      showProgress = false;
      setState(() {});
    }else{
      showProgress = false;
      setState(() {});
      try {
        Widgets().showError(data: data, context: context);
      }catch(e){
        Widgets().showAlertDialog(alertMessage: "No record available,", context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report"),
      ),
      body: Center(
        child: showProgress ? const CircularProgressIndicator(
          color: kThemeColor,
        ) : Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
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
                    lastDate: DateTime.now(),
                  );
                  if(pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if(pickedTime != null){
                      var utcTime = DateTime.utc(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      startDate = utcTime;
                      setState((){});
                    }
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        startDate != null ? DateFormat("dd MMM yyyy hh:mm a").format(startDate!) : "Start Date",
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    firstDate: startDate ?? DateTime.now(),
                    lastDate: DateTime.now(),
                  );
                  if(pickedDate != null){
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if(pickedTime != null){
                      var utcTime = DateTime.utc(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      endDate = utcTime;
                      setState((){});
                    }
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        endDate != null ? DateFormat("dd MMM yyyy hh:mm a").format(endDate!) : "End time",
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
            Expanded(
              child: reportList == null ? const Center() : reportList!.isEmpty ? const Center(child: Text("No data available,")) : SingleChildScrollView(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      for(int i = 0; i < reportList!.length; i++)
                        Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: reportList![i]["status"] == "active" ?
                              Colors.green.withOpacity(0.7) : reportList![i]["status"] == "in-progress" ?
                              Colors.amber.withOpacity(0.7) : reportList![i]["status"] == "completed" ? Colors.blue.withOpacity(0.7) : Colors.white,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: reportList![i]["status"] == "active" ?
                                Colors.green.withOpacity(0.3) : reportList![i]["status"] == "in-progress" ?
                                Colors.amber.withOpacity(0.3) : reportList![i]["status"] == "completed" ? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Material(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: ListTile(
                              onTap: (){

                              },
                              contentPadding: const EdgeInsets.only(left:0, right: 16, top: 10, bottom: 10),
                              splashColor: reportList![i]["status"] == "active" ?
                              Colors.green.withOpacity(0.1) : reportList![i]["status"] == "in-progress" ?
                              Colors.amber.withOpacity(0.1) : reportList![i]["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                              hoverColor: reportList![i]["status"] == "active" ?
                              Colors.green.withOpacity(0.1) : reportList![i]["status"] == "in-progress" ?
                              Colors.amber.withOpacity(0.1) : reportList![i]["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                              title: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: reportList![i]["status"] == "active" ?
                                      Colors.green : reportList![i]["status"] == "in-progress" ?
                                      Colors.amber : reportList![i]["status"] == "completed" ? Colors.blue : Colors.white,
                                      borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                                    ),
                                  ),
                                  const SizedBox(width: 16,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if(reportList![i]["name"].isNotEmpty)
                                          Text(
                                            reportList![i]["name"],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: reportList![i]["status"] == "active" ?
                                              Colors.green : reportList![i]["status"] == "in-progress" ?
                                              Colors.amber : reportList![i]["status"] == "completed" ? Colors.blue : Colors.white,
                                            ),
                                          ),
                                        if(reportList![i]["description"].isNotEmpty)
                                          Text(
                                            reportList![i]["description"],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              // fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        const SizedBox(height: 3,),
                                        Text(
                                          DateFormat("dd MM yyyy hh:mm a").format(DateTime.parse(reportList![i]["created_at"])),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  if(reportList![i].containsKey("assigned_task"))
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: reportList![i]["assigned_task"].isEmpty ? const Text(
                                                            "Not assigned to anyone.",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            ),
                                                          ) : SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Stack(
                                                              children: [
                                                                SizedBox(
                                                                  height: 30,
                                                                  width: (reportList![i]["assigned_task"].length * 20)+ 10.0,
                                                                ),
                                                                for(int j = 0; j < (reportList![i]["assigned_task"].length > 4 ? 5 : reportList![i]["assigned_task"].length); j++)
                                                                  if(j > 3)
                                                                    Positioned(
                                                                      left: j * 20,
                                                                      child: Container(
                                                                        width: 30,
                                                                        height: 30,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(15),
                                                                          // border: Border.all(color: Colors.grey),
                                                                          color: Colors.indigo,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              blurRadius: 3,
                                                                            )
                                                                          ],
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            "${reportList![i]["assigned_task"].length - 4}+",
                                                                            style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 14,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  else
                                                                    Positioned(
                                                                      left: j * 20,
                                                                      child: Container(
                                                                        margin: const EdgeInsets.only(right: 5),
                                                                        width: 30,
                                                                        height: 30,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(15),
                                                                          // border: Border.all(color: Colors.grey),
                                                                          color: kPrimaryColor,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              blurRadius: 3,
                                                                            )
                                                                          ],
                                                                        ),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(15),
                                                                          child: reportList![i]["assigned_task"][j]["developer"]["photo"] == null ? Widgets().noProfileContainer(
                                                                            name: reportList![i]["assigned_task"][j]["developer"]["first_name"][0]+
                                                                                reportList![i]["assigned_task"][j]["developer"]["last_name"][0],
                                                                          ) : reportList![i]["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                                                                          Image.network(
                                                                            reportList![i]["assigned_task"][j]["developer"]["photo"],
                                                                            width: 30,
                                                                            height: 30,
                                                                            fit: BoxFit.cover,
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
                                                                            errorBuilder: (context, obj, st){
                                                                              return Widgets().noProfileContainer(
                                                                                name: reportList![i]["assigned_task"][j]["developer"]["first_name"][0]+
                                                                                    reportList![i]["assigned_task"][j]["developer"]["last_name"][0],
                                                                              );
                                                                            },
                                                                          ) : Widgets().noProfileContainer(
                                                                            name: reportList![i]["assigned_task"][j]["developer"]["first_name"][0]+
                                                                                reportList![i]["assigned_task"][j]["developer"]["last_name"][0],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  // const SizedBox(height: 2,),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10,),
                                            Text(
                                              reportList![i]["status"] == "active" ?
                                              "Active" : reportList![i]["status"] == "in-progress" ?
                                              "In-progress" : reportList![i]["status"] == "completed" ? "Completed" : "",
                                              style: TextStyle(
                                                fontSize: 18,
                                                height: 1,
                                                fontWeight: FontWeight.bold,
                                                color: reportList![i]["status"] == "active" ?
                                                Colors.green : reportList![i]["status"] == "in-progress" ?
                                                Colors.amber : reportList![i]["status"] == "completed" ? Colors.blue : Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Total time",
                                                    style: TextStyle(
                                                      // fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${(double.parse(reportList![i]["total_time_hr"].toString())).abs().floor()} hour ${((double.parse(reportList![i]["total_time_hr"].toString())*60.0)%60.0).abs().round()} min",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Estimated time",
                                                    style: TextStyle(
                                                      // fontSize: 16,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${(double.parse(reportList![i]["estimate_time"].toString())).abs().floor()} hour ${((double.parse(reportList![i]["estimate_time"].toString())*60.0)%60.0).abs().round()} min",
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              tileColor: reportList![i]["status"] == "active" ?
                              Colors.green.withOpacity(0.06) : reportList![i]["status"] == "in-progress" ?
                              Colors.yellow.withOpacity(0.06) : reportList![i]["status"] == "completed" ? Colors.blue.withOpacity(0.06) : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              dense: true,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Widgets().textButton(
                      onPressed: (){
                        if(startDate != null && endDate != null){
                          getReport(startDate: startDate!.toIso8601String(), endDate: endDate!.toIso8601String());
                        }else{
                          Widgets().showAlertDialog(alertMessage: "Please select start date and end date to get report.", context: context);
                        }
                      },
                      text: "Get report",
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
