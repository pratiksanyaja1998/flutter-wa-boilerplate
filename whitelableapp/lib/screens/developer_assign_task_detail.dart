
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/components/assign_task_card.dart';
import 'package:whitelabelapp/components/task_card.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/service/api.dart';
import 'dart:io' show Platform;

class DeveloperAssignTaskDetailScreen extends StatefulWidget {
  const DeveloperAssignTaskDetailScreen({Key? key, required this.assignTaskData}) : super(key: key);

  final dynamic assignTaskData;

  @override
  State<DeveloperAssignTaskDetailScreen> createState() => _DeveloperAssignTaskDetailScreenState();
}

class _DeveloperAssignTaskDetailScreenState extends State<DeveloperAssignTaskDetailScreen> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceInOut,
    reverseCurve: Curves.bounceInOut,
  );

  bool showProgress = true;

  List<dynamic> assignTaskLogs = [];

  dynamic taskData;
  Color? taskStatusColor;
  bool showAllDescription = false;
  bool isExpanded = false;

  TextEditingController logDescriptionController = TextEditingController();

  @override
  void initState() {
    getTask();
    super.initState();
  }

  Future<void> getTask()async{
    await Future.delayed(const Duration(seconds: 0));
    var response = await ServiceApis().getTask(taskId: widget.assignTaskData["task"]);
    var data = jsonDecode(response.body);
    printMessage("$data");
    if(!mounted) return;
    if (response.statusCode == 200) {
      taskData = data;
      switch(taskData["status"]){
        case "active":
          taskStatusColor = Colors.green;
          break;
        case "in-progress":
          taskStatusColor = Colors.amber;
          break;
        case "completed":
          taskStatusColor = Colors.blue;
          break;
        default:
          taskStatusColor = Colors.white;
          break;
      }
      await getAssignTaskLogs();
    } else {
      showProgress = false;
      setState(() {});
      CommonFunctions().showError(data: data, context: context);
    }
  }

  Future<void> getAssignTaskLogs()async{
    await Future.delayed(const Duration(seconds: 0));
    var response = await ServiceApis().getTimeLogTaskList(assignTaskId: widget.assignTaskData["id"]);
    var data = jsonDecode(response.body);
    printMessage("$data");
    if(!mounted) return;
    if (response.statusCode == 200) {
      assignTaskLogs = data;
      showProgress = false;
      setState(() {});
    } else {
      showProgress = false;
      setState(() {});
      CommonFunctions().showError(data: data, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          taskData["name"],
        ),
      ),
      body: Center(
        child: showProgress ? const CircularProgressIndicator(
          color: kThemeColor,
        ) : Container(
          constraints: BoxConstraints(
            maxWidth: 450,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: RefreshIndicator(
            onRefresh: ()async{
              showProgress = true;
              setState(() {});
              getTask();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: taskData == null ? [] : [
                  TaskCard(
                    task: taskData,
                    controller: _controller,
                    animation: _animation,
                    onExpand: () {
                      if (_controller.isCompleted) {
                        _controller.reverse();
                      } else {
                        _controller.forward();
                      }
                      isExpanded = !isExpanded;
                      setState(() {});
                    },
                  ),
                  // AnimatedContainer(
                  //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(
                  //       color: taskStatusColor!.withOpacity(0.6),
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: taskStatusColor!.withOpacity(0.3),
                  //         blurRadius: 4,
                  //       ),
                  //     ],
                  //   ),
                  //   curve: Curves.easeInOut,
                  //   duration: const Duration(milliseconds: 600),
                  //   child: Material(
                  //     elevation: 0,
                  //     color: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10)
                  //     ),
                  //     child: ListTile(
                  //       onTap: (){
                  //         showAllDescription = !showAllDescription;
                  //         setState(() {});
                  //       },
                  //       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  //       splashColor: taskStatusColor!.withOpacity(0.1),
                  //       hoverColor: taskStatusColor!.withOpacity(0.1),
                  //       title: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "${taskData["status"][0].toUpperCase()}${taskData["status"].substring(1).toLowerCase()}",
                  //             style: TextStyle(
                  //               fontSize: 24,
                  //               fontWeight: FontWeight.bold,
                  //               color: taskStatusColor!,
                  //             ),
                  //           ),
                  //           const SizedBox(height: 5,),
                  //           if(taskData["name"].isNotEmpty)
                  //             Text(
                  //               taskData["name"],
                  //               style: const TextStyle(
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.bold,
                  //
                  //               ),
                  //             ),
                  //           const SizedBox(height: 5,),
                  //           AnimatedContainer(
                  //             constraints: BoxConstraints(
                  //               maxHeight: showAllDescription ? 100 : 48,
                  //             ),
                  //             curve: Curves.easeInOut,
                  //             duration: const Duration(milliseconds: 600),
                  //             child: SingleChildScrollView(
                  //               physics: showAllDescription ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
                  //               child: Text(
                  //                 taskData["description"],
                  //                 maxLines: 10,
                  //                 overflow: TextOverflow.ellipsis,
                  //                 style: const TextStyle(
                  //                   fontSize: 16,
                  //                   fontWeight: FontWeight.w500,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           const Divider(
                  //             height: 25,
                  //             color: Colors.grey,
                  //           ),
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     const Text(
                  //                       "Developers",
                  //                       style: TextStyle(
                  //                         fontWeight: FontWeight.w500,
                  //                         fontSize: 16,
                  //                       ),
                  //                     ),
                  //                     const SizedBox(height: 6,),
                  //                     if(taskData["assigned_task"].isNotEmpty)
                  //                       Row(
                  //                         children: [
                  //                           Expanded(
                  //                             child: SingleChildScrollView(
                  //                               scrollDirection: Axis.horizontal,
                  //                               child: Stack(
                  //                                 children: [
                  //                                   SizedBox(
                  //                                     height: 40,
                  //                                     width: (taskData["assigned_task"].length * 26)+ 14.0,
                  //                                   ),
                  //                                   for(int j = 0; j < (taskData["assigned_task"].length > 4 ? 5 : taskData["assigned_task"].length); j++)
                  //                                     if(j > 3)
                  //                                       Positioned(
                  //                                         left: j * 26 + 2,
                  //                                         top: 2,
                  //                                         child: Container(
                  //                                           width: 36,
                  //                                           height: 36,
                  //                                           decoration: BoxDecoration(
                  //                                             borderRadius: BorderRadius.circular(18),
                  //                                             // border: Border.all(color: Colors.grey),
                  //                                             color: Colors.indigo,
                  //                                             boxShadow: [
                  //                                               BoxShadow(
                  //                                                 color: Colors.black.withOpacity(0.3),
                  //                                                 blurRadius: 4,
                  //                                               )
                  //                                             ],
                  //                                           ),
                  //                                           child: Center(
                  //                                             child: Text(
                  //                                               "${taskData["assigned_task"].length - 4}+",
                  //                                               style: const TextStyle(
                  //                                                 color: Colors.white,
                  //                                                 fontWeight: FontWeight.bold,
                  //                                                 fontSize: 18,
                  //                                               ),
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                       )
                  //                                     else
                  //                                       Positioned(
                  //                                         left: j * 26 + 2,
                  //                                         top: 2,
                  //                                         child: Container(
                  //                                           margin: const EdgeInsets.only(right: 5),
                  //                                           width: 36,
                  //                                           height: 36,
                  //                                           decoration: BoxDecoration(
                  //                                             borderRadius: BorderRadius.circular(18),
                  //                                             // border: Border.all(color: Colors.grey),
                  //                                             color: kPrimaryColor,
                  //                                             boxShadow: [
                  //                                               BoxShadow(
                  //                                                 color: Colors.black.withOpacity(0.3),
                  //                                                 blurRadius: 4,
                  //                                               )
                  //                                             ],
                  //                                           ),
                  //                                           child: ClipRRect(
                  //                                             borderRadius: BorderRadius.circular(20),
                  //                                             child: taskData["assigned_task"][j]["developer"]["photo"] == null ? Widgets().noProfileContainer(
                  //                                               name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                  //                                                   taskData["assigned_task"][j]["developer"]["last_name"][0],
                  //                                             ) : taskData["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                  //                                             Image.network(
                  //                                               taskData["assigned_task"][j]["developer"]["photo"],
                  //                                               width: 40,
                  //                                               height: 40,
                  //                                               fit: BoxFit.cover,
                  //                                               loadingBuilder: (context, child, loadingProgress){
                  //                                                 if(loadingProgress != null){
                  //                                                   return const Center(
                  //                                                     child: CircularProgressIndicator(
                  //                                                       color: kThemeColor,
                  //                                                       strokeWidth: 3,
                  //                                                     ),
                  //                                                   );
                  //                                                 }else{
                  //                                                   return child;
                  //                                                 }
                  //                                               },
                  //                                               errorBuilder: (context, obj, st){
                  //                                                 return Widgets().noProfileContainer(
                  //                                                   name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                  //                                                       taskData["assigned_task"][j]["developer"]["last_name"][0],
                  //                                                 );
                  //                                               },
                  //                                             ) : Widgets().noProfileContainer(
                  //                                               name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                  //                                                   taskData["assigned_task"][j]["developer"]["last_name"][0],
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       )
                  //                     else
                  //                       const Text(
                  //                         "No developer assigned to this task.",
                  //                         style: TextStyle(
                  //                           fontSize: 14,
                  //                         ),
                  //                       ),
                  //                     const SizedBox(height: 5,),
                  //                   ],
                  //                 ),
                  //               ),
                  //               GestureDetector(
                  //                 onTap: (){
                  //                   if(_controller.isCompleted){
                  //                     _controller.reverse();
                  //                   }else {
                  //                     _controller.forward();
                  //                   }
                  //                   isExpanded = !isExpanded;
                  //                   setState(() {});
                  //                 },
                  //                 child: RotationTransition(
                  //                   turns: _animation,
                  //                   child: Icon(
                  //                     isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_rounded,
                  //                     color: taskStatusColor!,
                  //                     size: 30,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //           AnimatedContainer(
                  //             constraints: BoxConstraints(
                  //               maxHeight: isExpanded ? 320 : 0,
                  //             ),
                  //             curve: Curves.easeInOut,
                  //             duration: const Duration(milliseconds: 600),
                  //             child: SingleChildScrollView(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Column(
                  //                     children: [
                  //                       for(int j = 0; j < taskData["assigned_task"].length; j++)
                  //                         Container(
                  //                           margin: const EdgeInsets.only(top: 8,),
                  //                           decoration: BoxDecoration(
                  //                             color: Colors.white,
                  //                             border: Border.all(
                  //                               color: taskStatusColor!.withOpacity(0.6),
                  //                             ),
                  //                             borderRadius: BorderRadius.circular(10),
                  //                             boxShadow: [
                  //                               BoxShadow(
                  //                                 color: taskStatusColor!.withOpacity(0.3),
                  //                                 blurRadius: 4,
                  //                               ),
                  //                             ],
                  //                           ),
                  //                           child: Material(
                  //                             elevation: 0,
                  //                             color: Colors.white,
                  //                             shape: RoundedRectangleBorder(
                  //                                 borderRadius: BorderRadius.circular(10)
                  //                             ),
                  //                             child: ListTile(
                  //                               onTap: (){
                  //
                  //                               },
                  //                               contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  //                               splashColor: taskStatusColor!.withOpacity(0.1),
                  //                               hoverColor: taskStatusColor!.withOpacity(0.1),
                  //                               title: Row(
                  //                                 children: [
                  //                                   Container(
                  //                                     margin: const EdgeInsets.only(right: 5),
                  //                                     width: 36,
                  //                                     height: 36,
                  //                                     decoration: BoxDecoration(
                  //                                       borderRadius: BorderRadius.circular(18),
                  //                                       // border: Border.all(color: Colors.grey),
                  //                                       color: kPrimaryColor,
                  //                                       boxShadow: [
                  //                                         BoxShadow(
                  //                                           color: Colors.black.withOpacity(0.3),
                  //                                           blurRadius: 4,
                  //                                         )
                  //                                       ],
                  //                                     ),
                  //                                     child: ClipRRect(
                  //                                       borderRadius: BorderRadius.circular(20),
                  //                                       child: taskData["assigned_task"][j]["developer"]["photo"] == null ? Widgets().noProfileContainer(
                  //                                         name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                  //                                             taskData["assigned_task"][j]["developer"]["last_name"][0],
                  //                                       ) : taskData["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                  //                                       Image.network(
                  //                                         taskData["assigned_task"][j]["developer"]["photo"],
                  //                                         width: 40,
                  //                                         height: 40,
                  //                                         fit: BoxFit.cover,
                  //                                         loadingBuilder: (context, child, loadingProgress){
                  //                                           if(loadingProgress != null){
                  //                                             return const Center(
                  //                                               child: CircularProgressIndicator(
                  //                                                 color: kThemeColor,
                  //                                                 strokeWidth: 3,
                  //                                               ),
                  //                                             );
                  //                                           }else{
                  //                                             return child;
                  //                                           }
                  //                                         },
                  //                                         errorBuilder: (context, obj, st){
                  //                                           return Widgets().noProfileContainer(
                  //                                             name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                  //                                                 taskData["assigned_task"][j]["developer"]["last_name"][0],
                  //                                           );
                  //                                         },
                  //                                       ) : Widgets().noProfileContainer(
                  //                                         name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                  //                                             taskData["assigned_task"][j]["developer"]["last_name"][0],
                  //                                       ),
                  //                                     ),
                  //                                   ),
                  //                                   const SizedBox(width: 5,),
                  //                                   Expanded(
                  //                                     child: Column(
                  //                                       crossAxisAlignment: CrossAxisAlignment.start,
                  //                                       children: [
                  //                                         Text(
                  //                                           "${taskData["assigned_task"][j]["developer"]["first_name"]} ${taskData["assigned_task"][j]["developer"]["last_name"]}",
                  //                                           maxLines: 1,
                  //                                           overflow: TextOverflow.ellipsis,
                  //                                           style: const TextStyle(
                  //                                             fontWeight: FontWeight.w500,
                  //                                             fontSize: 15,
                  //                                           ),
                  //                                         ),
                  //                                         Text(
                  //                                           taskData["assigned_task"][j]["developer"]["email"],
                  //                                           maxLines: 1,
                  //                                           overflow: TextOverflow.ellipsis,
                  //                                           style: const TextStyle(
                  //                                             fontSize: 14,
                  //                                           ),
                  //                                         ),
                  //                                       ],
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                               tileColor: taskStatusColor!.withOpacity(0.1),
                  //                               shape: RoundedRectangleBorder(
                  //                                 borderRadius: BorderRadius.circular(10),
                  //                               ),
                  //                               dense: true,
                  //                             ),
                  //                           ),
                  //                         ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           const SizedBox(height: 10,),
                  //           Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     const Text(
                  //                       "Total time",
                  //                       style: TextStyle(
                  //                         // fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       ),
                  //                     ),
                  //                     Text(
                  //                       "${(((taskData["total_time_hr"])*60.0)/60.0).floor()} hour ${(((taskData["total_time_hr"])*60.0)%60.0).round()} min",
                  //                       style: const TextStyle(
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w500,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               const SizedBox(width: 10,),
                  //               Expanded(
                  //                 child: Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     const Text(
                  //                       "Estimated time",
                  //                       style: TextStyle(
                  //                         // fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       ),
                  //                     ),
                  //                     Text(
                  //                       "${(((taskData["estimate_time"])*60.0)/60.0).floor()} hour ${(((taskData["estimate_time"])*60.0)%60.0).round()} min",
                  //                       style: const TextStyle(
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.w500,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //       tileColor: taskStatusColor!.withOpacity(0.1),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       dense: true,
                  //     ),
                  //   ),
                  // ),
                  const Padding(
                    padding: EdgeInsets.only(left: 27.0, right: 27, bottom: 10),
                    child: Text(
                      "Assigned to you",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  AssignTaskCard(assignTaskData: widget.assignTaskData,),
                  // Container(
                  //   margin: const EdgeInsets.only(left: 25, right: 25, bottom: 15,),
                  //   decoration: BoxDecoration(
                  //     color: kPrimaryColor,
                  //     borderRadius: BorderRadius.circular(10),
                  //     border: Border.all(
                  //       color: kThemeColor,
                  //     ),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: kThemeColor.withOpacity(0.3),
                  //         blurRadius: 4,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Material(
                  //     elevation: 0,
                  //     color: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10)
                  //     ),
                  //     child: ListTile(
                  //       onTap: (){
                  //
                  //       },
                  //       contentPadding: const EdgeInsets.only(left: 0, right: 16, top: 10, bottom: 10),
                  //       splashColor: kThemeColor.withOpacity(0.1),
                  //       hoverColor: kThemeColor.withOpacity(0.1),
                  //       title: Row(
                  //         children: [
                  //           Container(
                  //             width: 7,
                  //             height: 100,
                  //             decoration: const BoxDecoration(
                  //               color: kThemeColor,
                  //               borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                  //             ),
                  //           ),
                  //           const SizedBox(width: 16,),
                  //           Expanded(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 if(widget.assignTaskData["note"].isNotEmpty)
                  //                   Text(
                  //                     widget.assignTaskData["note"],
                  //                     maxLines: 2,
                  //                     overflow: TextOverflow.ellipsis,
                  //                     style: const TextStyle(
                  //                       fontSize: 18,
                  //                       // fontWeight: FontWeight.w400,
                  //                     ),
                  //                   ),
                  //                 Text(
                  //                   DateFormat("dd MM yyyy hh:mm a").format(DateTime.parse(widget.assignTaskData["created_at"])),
                  //                   style: const TextStyle(
                  //                     fontWeight: FontWeight.w500,
                  //                     fontSize: 15,
                  //                     height: 2,
                  //                     fontStyle: FontStyle.italic,
                  //                   ),
                  //                 ),
                  //                 const Divider(
                  //                   color: Colors.grey,
                  //                 ),
                  //                 const SizedBox(height: 5,),
                  //                 Row(
                  //                   children: [
                  //                     SizedBox(
                  //                       width: 32,
                  //                       height: 32,
                  //                       child: Image.asset("assets/images/working_hours_person.png"),
                  //                     ),
                  //                     const SizedBox(width: 10,),
                  //                     Expanded(
                  //                       child: Column(
                  //                         mainAxisAlignment: MainAxisAlignment.center,
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: [
                  //                           const Text(
                  //                             "Total time",
                  //                             style: TextStyle(
                  //                               // fontSize: 16,
                  //                               fontWeight: FontWeight.w500,
                  //                             ),
                  //                           ),
                  //                           Text(
                  //                             "${(double.parse(widget.assignTaskData["total_time_hr"].toString())).abs().floor()} hour ${((double.parse(widget.assignTaskData["total_time_hr"].toString())*60.0)%60.0).abs().round()} min",
                  //                             style: const TextStyle(
                  //                               fontSize: 16,
                  //                               fontWeight: FontWeight.w500,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       tileColor: kThemeColor.withOpacity(0.06),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       dense: true,
                  //     ),
                  //   ),
                  // ),
                  const Padding(
                    padding: EdgeInsets.only(left: 27.0, right: 27, bottom: 12),
                    child: Text(
                      "Task logs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if(assignTaskLogs.isNotEmpty)
                    for(int i = 0; i < assignTaskLogs.length; i++)
                      Container(
                        margin: const EdgeInsets.only(left: 25, right: 25, bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: taskStatusColor!,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: taskStatusColor!.withOpacity(0.3),
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            splashColor: taskStatusColor!.withOpacity(0.1),
                            hoverColor: taskStatusColor!.withOpacity(0.1),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if(assignTaskLogs[i]["note"].isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      assignTaskLogs[i]["note"],
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                Row(
                                  children: [
                                    const SizedBox(width: 2,),
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: Image.asset("assets/images/start_time.png"),
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(
                                      DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(assignTaskLogs[i]["start_time"])),
                                      style: const TextStyle(
                                        // fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 21,
                                      height: 21,
                                      child: Image.asset(
                                        "assets/images/end_time.png",
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(
                                      DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(assignTaskLogs[i]["end_time"])),
                                      style: const TextStyle(
                                        // fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: Image.asset(
                                          "assets/images/total_task_time.png",
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Total time",
                                          style: TextStyle(
                                            // fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "${((double.parse(assignTaskLogs[i]["total_time_hr"].toString())*60.0)/60.0).floor()} hour ${((double.parse(assignTaskLogs[i]["total_time_hr"].toString())*60.0)%60.0).round()} min",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 1,),
                                      ],
                                    ),
                                  ],
                                ),

                              ],
                            ),
                            tileColor: taskStatusColor!.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            dense: true,
                          ),
                        ),
                      )
                  else
                    Container(
                      margin: const EdgeInsets.all(25),
                      height: 20,
                      child: const Center(
                        child: Text(
                          "No log available.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  const SizedBox(height: 90,),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          DateTime? startDate;
          DateTime? endDate;
          CommonFunctions().showBottomSheet(
            context: context,
            child: StatefulBuilder(builder: (context, setstate) {
              return Container(
                constraints: const BoxConstraints(
                  maxHeight: 400,
                  maxWidth: 450,
                ),
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kPrimaryColor,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Create Task Log",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
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
                                    if(!mounted) return;
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
                                      setstate((){});
                                    }
                                  }
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        startDate != null ? DateFormat("dd MMM yyyy hh:mm a").format(startDate!) : "Start time",
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
                                    if(!mounted) return;
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
                                      setstate((){});
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
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Widgets().textFormField(
                                maxLines: 3,
                                maxWidth: 450,
                                controller: logDescriptionController,
                                labelText: "Note",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Widgets().textButton(
                              onPressed: () async {
                                if(startDate != null && endDate != null){
                                  Navigator.pop(context);
                                  var response = await ServiceApis().createTimeLogTask(
                                    startTime: startDate!.toIso8601String(),
                                    endTime: endDate!.toIso8601String(),
                                    note: logDescriptionController.text,
                                    assignTaskId: widget.assignTaskData["id"],
                                  );
                                  if(response.statusCode == 201 ){
                                    showProgress = true;
                                    setState(() {});
                                    getTask();
                                  }
                                }else{
                                  CommonFunctions().showAlertDialog(alertMessage: "Please select start time and end time.", context: context);
                                }
                              },
                              text: "Create Log",
                              fontSize: 22,
                              padding: kIsWeb || Platform.isWindows ? const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 10) : const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
          // showModalBottomSheet(
          //   backgroundColor: Colors.transparent,
          //   context: context,
          //   isScrollControlled: true,
          //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          //   builder: (context){
          //     return StatefulBuilder(
          //         builder: (context, setstate) {
          //           return Padding(
          //             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 10, right: 10, top: 10),
          //             child: Stack(
          //               children: [
          //                 Center(
          //                   child: GestureDetector(
          //                     onTap: (){
          //                       Navigator.pop(context);
          //                     },
          //                   ),
          //                 ),
          //                 Center(
          //                   child: Container(
          //                     constraints: const BoxConstraints(
          //                       maxHeight: 400,
          //                       maxWidth: 450,
          //                     ),
          //                     margin: const EdgeInsets.all(15),
          //                     padding: const EdgeInsets.symmetric(vertical: 20),
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(20),
          //                       color: kPrimaryColor,
          //                     ),
          //                     child: Column(
          //                       children: [
          //                         const Text(
          //                           "Create Task Log",
          //                           style: TextStyle(
          //                             fontSize: 24,
          //                             fontWeight: FontWeight.bold,
          //                             color: Colors.black,
          //                           ),
          //                         ),
          //                         Expanded(
          //                           child: SingleChildScrollView(
          //                             child: Column(
          //                               children: [
          //                                 Container(
          //                                   margin: const EdgeInsets.all(20),
          //                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //                                   decoration: BoxDecoration(
          //                                     color: Colors.white,
          //                                     borderRadius: BorderRadius.circular(10),
          //                                     boxShadow: [
          //                                       BoxShadow(
          //                                         color: Colors.black.withOpacity(0.3),
          //                                         blurRadius: 6,
          //                                       )
          //                                     ],
          //                                   ),
          //                                   child: GestureDetector(
          //                                     onTap: () async {
          //                                       DateTime? pickedDate = await showDatePicker(
          //                                         context: context,
          //                                         initialDate: DateTime.now(),
          //                                         firstDate: DateTime(1950),
          //                                         lastDate: DateTime.now(),
          //                                       );
          //                                       if(pickedDate != null) {
          //                                         TimeOfDay? pickedTime = await showTimePicker(
          //                                           context: context,
          //                                           initialTime: TimeOfDay.now(),
          //                                         );
          //                                         if(pickedTime != null){
          //                                           var utcTime = DateTime.utc(
          //                                             pickedDate.year,
          //                                             pickedDate.month,
          //                                             pickedDate.day,
          //                                             pickedTime.hour,
          //                                             pickedTime.minute,
          //                                           );
          //                                           startDate = utcTime;
          //                                           setState((){});
          //                                           setstate((){});
          //                                         }
          //                                       }
          //                                     },
          //                                     child: Row(
          //                                       children: [
          //                                         Expanded(
          //                                           child: Text(
          //                                             startDate != null ? DateFormat("dd MMM yyyy hh:mm a").format(startDate!) : "Start time",
          //                                             style: const TextStyle(
          //                                               fontSize: 18,
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         const Icon(
          //                                           Icons.calendar_today_rounded,
          //                                           color: kThemeColor,
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                                 Container(
          //                                   margin: const EdgeInsets.symmetric(horizontal: 20),
          //                                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //                                   decoration: BoxDecoration(
          //                                     color: Colors.white,
          //                                     borderRadius: BorderRadius.circular(10),
          //                                     boxShadow: [
          //                                       BoxShadow(
          //                                         color: Colors.black.withOpacity(0.3),
          //                                         blurRadius: 6,
          //                                       )
          //                                     ],
          //                                   ),
          //                                   child: GestureDetector(
          //                                     onTap: () async {
          //                                       DateTime? pickedDate = await showDatePicker(
          //                                         context: context,
          //                                         initialDate: DateTime.now(),
          //                                         firstDate: startDate ?? DateTime.now(),
          //                                         lastDate: DateTime.now(),
          //                                       );
          //                                       if(pickedDate != null){
          //                                         TimeOfDay? pickedTime = await showTimePicker(
          //                                           context: context,
          //                                           initialTime: TimeOfDay.now(),
          //                                         );
          //                                         if(pickedTime != null){
          //                                           var utcTime = DateTime.utc(
          //                                             pickedDate.year,
          //                                             pickedDate.month,
          //                                             pickedDate.day,
          //                                             pickedTime.hour,
          //                                             pickedTime.minute,
          //                                           );
          //                                           endDate = utcTime;
          //                                           setState((){});
          //                                           setstate((){});
          //                                         }
          //                                       }
          //                                     },
          //                                     child: Row(
          //                                       children: [
          //                                         Expanded(
          //                                           child: Text(
          //                                             endDate != null ? DateFormat("dd MMM yyyy hh:mm a").format(endDate!) : "End time",
          //                                             style: const TextStyle(
          //                                               fontSize: 18,
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         const Icon(Icons.calendar_today_rounded, color: kThemeColor,),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                                 Padding(
          //                                   padding: const EdgeInsets.all(20),
          //                                   child: Widgets().textFormField(
          //                                     maxLines: 3,
          //                                     maxWidth: 450,
          //                                     controller: logDescriptionController,
          //                                     labelText: "Note",
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                         Padding(
          //                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
          //                           child: Row(
          //                             children: [
          //                               Expanded(
          //                                 child: Widgets().textButton(
          //                                   onPressed: () async {
          //                                     if(startDate != null && endDate != null){
          //                                       Navigator.pop(context);
          //                                       var response = await ServiceApis().createTimeLogTask(
          //                                         startTime: startDate!.toIso8601String(),
          //                                         endTime: endDate!.toIso8601String(),
          //                                         note: logDescriptionController.text,
          //                                         assignTaskId: widget.assignTaskData["id"],
          //                                       );
          //                                       if(response.statusCode == 201 ){
          //                                         showProgress = true;
          //                                         setState(() {});
          //                                         getTask();
          //                                       }
          //                                     }else{
          //                                       Widgets().showAlertDialog(alertMessage: "Please select start time and end time.", context: context);
          //                                     }
          //                                   },
          //                                   text: "Create Log",
          //                                   fontSize: 22,
          //                                   padding: kIsWeb || Platform.isWindows ? const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 10) : const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           );
          //         }
          //     );
          //   },
          // );
        },
        tooltip: "Create Log",
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
    );
  }
}
