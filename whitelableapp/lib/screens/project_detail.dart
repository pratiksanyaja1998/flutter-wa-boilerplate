
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/components/project_card.dart';
import 'package:whitelabelapp/components/task_card.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/model/assign_task_modal.dart';
import 'package:whitelabelapp/screens/task_detail.dart';
import 'package:whitelabelapp/service/api.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({Key? key, required this.projectData, required this.businessUserList}) : super(key: key);

  final dynamic projectData;
  final dynamic businessUserList;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {

  List<dynamic> taskList = [];
  bool showProgress = true;
  bool isExpanded = false;

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController assignTaskDescriptionController = TextEditingController();
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();

  @override
  void initState() {
    getTaskList();
    super.initState();
  }

  Future<void> getTaskList()async{
    await Future.delayed(const Duration(seconds: 0));
    var response = await ServiceApis().getTaskList(projectId: widget.projectData["id"].toString());
    var data = jsonDecode(response.body);
    printMessage("$data");
    if(!mounted) return;
    if (response.statusCode == 200) {
      taskList = data;
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
        title: Text(
          widget.projectData["name"],
          style: const TextStyle(
            // fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        shadowColor: Colors.black,
        centerTitle: true,
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
              getTaskList();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25,),
                  ProjectCard(
                    project: widget.projectData,
                  ),
                  // AnimatedContainer(
                  //   curve: Curves.easeInOut,
                  //   duration: const Duration(milliseconds: 600),
                  //   margin: const EdgeInsets.all(20),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     border: Border.all(
                  //       color: widget.projectData["status"] == "active" ?
                  //       Colors.green.withOpacity(0.7) : widget.projectData["status"] == "in-progress" ?
                  //       Colors.amber.withOpacity(0.7) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.7) : Colors.white,
                  //     ),
                  //     borderRadius: BorderRadius.circular(10),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: widget.projectData["status"] == "active" ?
                  //         Colors.green.withOpacity(0.3) : widget.projectData["status"] == "in-progress" ?
                  //         Colors.amber.withOpacity(0.3) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.3),
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
                  //         isExpanded = !isExpanded;
                  //         setState(() {});
                  //       },
                  //       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10,),
                  //       splashColor: widget.projectData["status"] == "active" ?
                  //       Colors.green.withOpacity(0.1) : widget.projectData["status"] == "in-progress" ?
                  //       Colors.amber.withOpacity(0.1) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                  //       hoverColor: widget.projectData["status"] == "active" ?
                  //       Colors.green.withOpacity(0.1) : widget.projectData["status"] == "in-progress" ?
                  //       Colors.amber.withOpacity(0.1) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                  //       title: IntrinsicHeight(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             if(widget.projectData["name"].isNotEmpty)
                  //               Text(
                  //                 widget.projectData["name"],
                  //                 style: TextStyle(
                  //                   fontSize: 24,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: widget.projectData["status"] == "active" ?
                  //                   Colors.green : widget.projectData["status"] == "in-progress" ?
                  //                   Colors.amber : widget.projectData["status"] == "completed" ? Colors.blue : Colors.white,
                  //                 ),
                  //               ),
                  //             const SizedBox(height: 5,),
                  //             Text(
                  //               widget.projectData["description"],
                  //               style: const TextStyle(
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //             const Divider(
                  //               height: 25,
                  //               color: Colors.grey,
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Expanded(
                  //                   child: Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       const Text(
                  //                         "Team",
                  //                         style: TextStyle(
                  //                           fontWeight: FontWeight.w500,
                  //                           fontSize: 16,
                  //                         ),
                  //                       ),
                  //                       const SizedBox(height: 6,),
                  //                       if(widget.projectData["team"].isNotEmpty)
                  //                         Row(
                  //                           children: [
                  //                             Expanded(
                  //                               child: SingleChildScrollView(
                  //                                 scrollDirection: Axis.horizontal,
                  //                                 child: Stack(
                  //                                   children: [
                  //                                     SizedBox(
                  //                                       height: 40,
                  //                                       width: (widget.projectData["team"].length * 26)+ 14.0,
                  //                                     ),
                  //                                     for(int j = 0; j < (widget.projectData["team"].length > 4 ? 5 : widget.projectData["team"].length); j++)
                  //                                       if(j > 3)
                  //                                         Positioned(
                  //                                           left: j * 26 + 2,
                  //                                           top: 2,
                  //                                           child: Container(
                  //                                             width: 36,
                  //                                             height: 36,
                  //                                             decoration: BoxDecoration(
                  //                                               borderRadius: BorderRadius.circular(18),
                  //                                               // border: Border.all(color: Colors.grey),
                  //                                               color: Colors.indigo,
                  //                                               boxShadow: [
                  //                                                 BoxShadow(
                  //                                                   color: Colors.black.withOpacity(0.3),
                  //                                                   blurRadius: 4,
                  //                                                 )
                  //                                               ],
                  //                                             ),
                  //                                             child: Center(
                  //                                               child: Text(
                  //                                                 "${widget.projectData["team"].length - 4}+",
                  //                                                 style: const TextStyle(
                  //                                                   color: Colors.white,
                  //                                                   fontWeight: FontWeight.bold,
                  //                                                   fontSize: 18,
                  //                                                 ),
                  //                                               ),
                  //                                             ),
                  //                                           ),
                  //                                         )
                  //                                       else
                  //                                         Positioned(
                  //                                           left: j * 26 + 2,
                  //                                           top: 2,
                  //                                           child: Container(
                  //                                             margin: const EdgeInsets.only(right: 5),
                  //                                             width: 36,
                  //                                             height: 36,
                  //                                             decoration: BoxDecoration(
                  //                                               borderRadius: BorderRadius.circular(18),
                  //                                               // border: Border.all(color: Colors.grey),
                  //                                               color: kPrimaryColor,
                  //                                               boxShadow: [
                  //                                                 BoxShadow(
                  //                                                   color: Colors.black.withOpacity(0.3),
                  //                                                   blurRadius: 4,
                  //                                                 )
                  //                                               ],
                  //                                             ),
                  //                                             child: ClipRRect(
                  //                                               borderRadius: BorderRadius.circular(20),
                  //                                               child: widget.projectData["team"][j]["photo"] == null ? Widgets().noProfileContainer(
                  //                                                 name: widget.projectData["team"][j]["first_name"][0]+
                  //                                                     widget.projectData["team"][j]["last_name"][0],
                  //                                               ) : widget.projectData["team"][j]["photo"].isNotEmpty ?
                  //                                               Image.network(
                  //                                                 widget.projectData["team"][j]["photo"],
                  //                                                 width: 40,
                  //                                                 height: 40,
                  //                                                 fit: BoxFit.cover,
                  //                                                 loadingBuilder: (context, child, loadingProgress){
                  //                                                   if(loadingProgress != null){
                  //                                                     return const Center(
                  //                                                       child: CircularProgressIndicator(
                  //                                                         color: kThemeColor,
                  //                                                         strokeWidth: 3,
                  //                                                       ),
                  //                                                     );
                  //                                                   }else{
                  //                                                     return child;
                  //                                                   }
                  //                                                 },
                  //                                                 errorBuilder: (context, obj, st){
                  //                                                   return Widgets().noProfileContainer(
                  //                                                     name: widget.projectData["team"][j]["first_name"][0]+
                  //                                                         widget.projectData["team"][j]["last_name"][0],
                  //                                                   );
                  //                                                 },
                  //                                               ) : Widgets().noProfileContainer(
                  //                                                 name: widget.projectData["team"][j]["first_name"][0]+
                  //                                                     widget.projectData["team"][j]["last_name"][0],
                  //                                               ),
                  //                                             ),
                  //                                           ),
                  //                                         ),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         )
                  //                       else
                  //                         const Text(
                  //                           "No team member is added.",
                  //                           style: TextStyle(
                  //                             fontSize: 14,
                  //                           ),
                  //                         ),
                  //                       const SizedBox(height: 8,),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Column(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   crossAxisAlignment: CrossAxisAlignment.end,
                  //                   children: [
                  //                     const Text(
                  //                       "Status",
                  //                       style: TextStyle(
                  //                         fontWeight: FontWeight.w500,
                  //                         fontSize: 15,
                  //                       ),
                  //                     ),
                  //                     Text(
                  //                       widget.projectData["status"] == "active" ?
                  //                       "Active" : widget.projectData["status"] == "in-progress" ?
                  //                       "In-progress" : widget.projectData["status"] == "completed" ? "Completed" : "",
                  //                       style: TextStyle(
                  //                         fontSize: 20,
                  //                         height: 1,
                  //                         fontWeight: FontWeight.bold,
                  //                         color: widget.projectData["status"] == "active" ?
                  //                         Colors.green : widget.projectData["status"] == "in-progress" ?
                  //                         Colors.amber : widget.projectData["status"] == "completed" ? Colors.blue : Colors.black,
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //             AnimatedContainer(
                  //               constraints: BoxConstraints(
                  //                 maxHeight: isExpanded ? 320 : 0,
                  //               ),
                  //               curve: Curves.easeInOut,
                  //               duration: const Duration(milliseconds: 800),
                  //               child: SingleChildScrollView(
                  //                 child: Column(
                  //                   children: [
                  //                     if(widget.projectData["team"].isNotEmpty)
                  //                       const SizedBox(height: 15,),
                  //                     for(int j = 0; j < widget.projectData["team"].length; j++)
                  //                       Container(
                  //                         margin: const EdgeInsets.only(bottom: 8,),
                  //                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  //                         decoration: BoxDecoration(
                  //                           color: widget.projectData["status"] == "active" ?
                  //                           Colors.green.withOpacity(0.05) : widget.projectData["status"] == "in-progress" ?
                  //                           Colors.amber.withOpacity(0.05) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.05) : Colors.black.withOpacity(0.3),
                  //                           border: Border.all(
                  //                             color: widget.projectData["status"] == "active" ?
                  //                             Colors.green.withOpacity(0.7) : widget.projectData["status"] == "in-progress" ?
                  //                             Colors.amber.withOpacity(0.7) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.7) : Colors.white,
                  //                           ),
                  //                           borderRadius: BorderRadius.circular(10),
                  //                         ),
                  //                         child: Row(
                  //                           children: [
                  //                             Container(
                  //                               margin: const EdgeInsets.only(right: 5),
                  //                               width: 36,
                  //                               height: 36,
                  //                               decoration: BoxDecoration(
                  //                                 borderRadius: BorderRadius.circular(18),
                  //                                 // border: Border.all(color: Colors.grey),
                  //                                 color: kPrimaryColor,
                  //                                 boxShadow: [
                  //                                   BoxShadow(
                  //                                     color: Colors.black.withOpacity(0.3),
                  //                                     blurRadius: 4,
                  //                                   )
                  //                                 ],
                  //                               ),
                  //                               child: ClipRRect(
                  //                                 borderRadius: BorderRadius.circular(20),
                  //                                 child: widget.projectData["team"][j]["photo"] == null ? Widgets().noProfileContainer(
                  //                                   name: widget.projectData["team"][j]["first_name"][0]+
                  //                                       widget.projectData["team"][j]["last_name"][0],
                  //                                 ) : widget.projectData["team"][j]["photo"].isNotEmpty ?
                  //                                 Image.network(
                  //                                   widget.projectData["team"][j]["photo"],
                  //                                   width: 40,
                  //                                   height: 40,
                  //                                   fit: BoxFit.cover,
                  //                                   loadingBuilder: (context, child, loadingProgress){
                  //                                     if(loadingProgress != null){
                  //                                       return const Center(
                  //                                         child: CircularProgressIndicator(
                  //                                           color: kThemeColor,
                  //                                           strokeWidth: 3,
                  //                                         ),
                  //                                       );
                  //                                     }else{
                  //                                       return child;
                  //                                     }
                  //                                   },
                  //                                   errorBuilder: (context, obj, st){
                  //                                     return Widgets().noProfileContainer(
                  //                                       name: widget.projectData["team"][j]["first_name"][0]+
                  //                                           widget.projectData["team"][j]["last_name"][0],
                  //                                     );
                  //                                   },
                  //                                 ) : Widgets().noProfileContainer(
                  //                                   name: widget.projectData["team"][j]["first_name"][0]+
                  //                                       widget.projectData["team"][j]["last_name"][0],
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             const SizedBox(width: 5,),
                  //                             Expanded(
                  //                               child: Column(
                  //                                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   Text(
                  //                                     "${widget.projectData["team"][j]["first_name"]} ${widget.projectData["team"][j]["last_name"]}",
                  //                                     style: const TextStyle(
                  //                                       fontWeight: FontWeight.w500,
                  //                                       fontSize: 15,
                  //                                     ),
                  //                                   ),
                  //                                   Text(
                  //                                     widget.projectData["team"][j]["email"],
                  //                                     style: const TextStyle(
                  //                                       fontSize: 14,
                  //                                     ),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),
                  //             const SizedBox(height: 10,),
                  //             Row(
                  //               children: [
                  //                 Expanded(
                  //                   child: Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       const Text(
                  //                         "Total time",
                  //                         style: TextStyle(
                  //                           // fontSize: 16,
                  //                           fontWeight: FontWeight.w500,
                  //                         ),
                  //                       ),
                  //                       Text(
                  //                         "${(double.parse(widget.projectData["estimate_time"].toString())).abs().floor()} hour ${((double.parse(widget.projectData["estimate_time"].toString())*60.0)%60.0).abs().round()} min",
                  //                         style: const TextStyle(
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w500,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 const SizedBox(width: 10,),
                  //                 Expanded(
                  //                   child: Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       const Text(
                  //                         "Estimated time",
                  //                         style: TextStyle(
                  //                           // fontSize: 16,
                  //                           fontWeight: FontWeight.w500,
                  //                         ),
                  //                       ),
                  //                       Text(
                  //                         "${(double.parse(widget.projectData["estimate_time"].toString())).abs().floor()} hour ${((double.parse(widget.projectData["estimate_time"].toString())*60.0)%60.0).abs().round()} min",
                  //                         style: const TextStyle(
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.w500,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             Container(
                  //               margin: const EdgeInsets.only(top: 20, bottom: 5),
                  //               height: 8,
                  //               decoration: const BoxDecoration(
                  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
                  //                 color: Colors.white,
                  //               ),
                  //               child: ClipRRect(
                  //                 borderRadius: const BorderRadius.all(Radius.circular(10)),
                  //                 child: LinearProgressIndicator(
                  //                   value: double.parse(widget.projectData["total_time_hr"].toString())/double.parse(widget.projectData["estimate_time"].toString()),
                  //                   minHeight: 8,
                  //                   valueColor: AlwaysStoppedAnimation<Color>(
                  //                     widget.projectData["status"] == "active" ?
                  //                     Colors.green : widget.projectData["status"] == "in-progress" ?
                  //                     Colors.amber : widget.projectData["status"] == "completed" ? Colors.blue : kThemeColor,
                  //                   ),
                  //                   backgroundColor: widget.projectData["status"] == "active" ?
                  //                   Colors.green.withOpacity(0.3) : widget.projectData["status"] == "in-progress" ?
                  //                   Colors.amber.withOpacity(0.3) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.3) : kThemeColor.withOpacity(0.3),
                  //                 ),
                  //               ),
                  //             ),
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 const Text(
                  //                   "Completed",
                  //                 ),
                  //                 Text(
                  //                   "${double.parse((double.parse(widget.projectData["total_time_hr"].toString())/
                  //                       double.parse(widget.projectData["estimate_time"].
                  //                       toString())
                  //                       * 100).toString()).toStringAsFixed(2)
                  //                   } %",
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       tileColor: widget.projectData["status"] == "active" ?
                  //       Colors.green.withOpacity(0.06) : widget.projectData["status"] == "in-progress" ?
                  //       Colors.yellow.withOpacity(0.06) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.06) : Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       dense: true,
                  //     ),
                  //   ),
                  // ),
                  const Padding(
                    padding: EdgeInsets.only(left: 22.0, right: 22, bottom: 5),
                    child: Text(
                      "Tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  for(int i = 0; i < taskList.length; i++)
                    TaskCard(
                      task: taskList[i],
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetail(taskId: taskList[i]["id"], projectData: widget.projectData))).then((value){
                          showProgress = true;
                          setState(() {});
                          getTaskList();
                        });
                      },
                      onSelected: (option) async {
                        switch (option) {
                          case 'Assign':
                            AssignTaskModal().assignUserModal(
                              context: context,
                              assignTaskDescriptionController: assignTaskDescriptionController,
                              assignedTaskList: taskList[i]["assigned_task"],
                              projectTeam: widget.projectData["team"],
                              onAssign: (selectedTeamMember) async {
                                if(selectedTeamMember != null){
                                  showProgress = true;
                                  setState(() {});
                                  Navigator.pop(context);
                                  var response = await ServiceApis().assignTask(
                                    developerId: selectedTeamMember["id"],
                                    taskId: taskList[i]["id"],
                                    note: assignTaskDescriptionController.text,
                                  );
                                  var data = jsonDecode(response.body);
                                  if(response.statusCode == 201){
                                    await getTaskList();
                                    if(!mounted) return;
                                    CommonFunctions().showAlertDialog(alertMessage: "Task assigned successfuly.", context: context);
                                  }else{
                                    showProgress = false;
                                    setState(() {});
                                    if(!mounted) return;
                                    CommonFunctions().showError(data: data, context: context);
                                  }
                                }else{
                                  CommonFunctions().showAlertDialog(alertMessage: "Developer must be selected to assign task.", context: context);
                                }
                              },
                            );
                            break;
                          case 'Update':
                            taskNameController.text = taskList[i]["name"];
                            taskDescriptionController.text = taskList[i]["description"];
                            editCreateTaskModal(projectId: widget.projectData["id"], isUpdate: true, taskId: taskList[i]["id"].toString());
                            break;
                          case 'Update status':
                            break;
                          case 'Delete':
                            CommonFunctions().showConfirmationDialog(
                              confirmationMessage: "Are you sure to delete this task.",
                              confirmButtonText: "Delete",
                              cancelButtonText: "Cancel",
                              context: context,
                              onConfirm: ()async{
                                showProgress = true;
                                setState(() {});
                                Navigator.pop(context);
                                var response = await ServiceApis().deleteTask(taskId: taskList[i]["id"].toString());
                                var data = jsonDecode(response.body);
                                if(response.statusCode == 204){
                                  await getTaskList();
                                  if(!mounted) return;
                                  CommonFunctions().showAlertDialog(alertMessage: "Task deleted successfully", context: context);
                                }else{
                                  showProgress = true;
                                  if(!mounted) return;
                                  setState(() {});
                                  CommonFunctions().showError(data: data, context: context);
                                }
                              },
                            );
                            break;
                          default:
                            break;
                        }
                        printMessage("-- $option --");
                      },
                      onSelectProjectUpdateStatus: (status) async {
                        if(["active", "in-progress", "completed"].contains(status)){
                          Navigator.pop(context);
                          showProgress = true;
                          setState(() {});
                          var response = await ServiceApis().updateTaskStatus(taskId: taskList[i]["id"].toString(), status: status);
                          var data = jsonDecode(response.body);
                          if(response.statusCode == 200){
                            getTaskList();
                          } else {
                            showProgress = false;
                            if(!mounted) return;
                            setState(() {});
                            CommonFunctions().showError(data: data, context: context);
                          }
                        }
                      },
                    ),
                  const SizedBox(height: 80,),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SharedPreference.getUser()!.type == "merchant" || SharedPreference.getUser()!.id == widget.projectData["manager"][  "id"] ? FloatingActionButton.extended(
        onPressed: (){
          taskNameController.text = "";
          taskDescriptionController.text = "";
          editCreateTaskModal(projectId: widget.projectData["id"]);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        extendedTextStyle: const TextStyle(
          fontSize: 18,
          height: 0,
          fontWeight: FontWeight.bold,
        ),
        label: const Text(
          "Add task",
        ),
      ) : const Center(),
    );
  }

  void editCreateTaskModal({bool isUpdate = false, String? taskId, required int projectId, double? time}){

    double estimatedTime = time ?? 0.0;
    if(time != null) {
      hourController.text = time.abs().floor().toString();
      minuteController.text = ((time*60.0)%60.0).abs().round().toString();
    }else{
      hourController.text = "0";
      minuteController.text = "0";
    }

    CommonFunctions().showBottomSheet(
      context: context,
      child: StatefulBuilder(builder: (context, addProjectState) {
        return Container(
          margin: const EdgeInsets.all(15),
          constraints: const BoxConstraints(
            maxHeight: 400,
            maxWidth: 350,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
              children: [
                const SizedBox(height: 15,),
                Text(
                  isUpdate ? "Update Task" : "Add Task",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 15,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Widgets().textFormField(
                            controller: taskNameController,
                            labelText: "Enter task name",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                          child: Widgets().textFormField(
                            maxLines: 3,
                            controller: taskDescriptionController,
                            labelText: "Enter task description",
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      " Hours",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Widgets().textFormField(
                                      controller: hourController,
                                      labelText: "hours",
                                      keyboardType: TextInputType.number,
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
                                      " Minutes",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Widgets().textFormField(
                                      controller: minuteController,
                                      labelText: "minutes",
                                      keyboardType: TextInputType.number,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Widgets().textButton(
                          onPressed: () async{
                            if (taskNameController.text.isEmpty) {
                              CommonFunctions().showAlertDialog(
                                alertMessage: "Task name can not be empty.",
                                context: context,
                              );
                            } else {
                              if(hourController.text.isNotEmpty){
                                estimatedTime = double.parse(hourController.text);
                              }
                              if(minuteController.text.isNotEmpty){
                                estimatedTime = estimatedTime + (double.parse(minuteController.text)/60.0);
                              }
                              showProgress = true;
                              setState(() {});
                              Navigator.pop(context);
                              dynamic response;
                              if(isUpdate){
                                response = await ServiceApis().updateTask(
                                  estimatedTime: estimatedTime,
                                  taskId: taskId ?? "",
                                  taskName: taskNameController.text,
                                  taskDescription: taskDescriptionController.text,
                                  projectId: projectId,
                                );
                                var data = jsonDecode(response.body);
                                if (response.statusCode == 200) {
                                  getTaskList();
                                } else {
                                  showProgress = false;
                                  if(!mounted) return;
                                  setState(() {});
                                  CommonFunctions().showError(data: data, context: context);
                                }
                              }else {
                                response = await ServiceApis().createTask(
                                  estimatedTime: estimatedTime,
                                  taskName: taskNameController.text,
                                  taskDescription: taskDescriptionController.text,
                                  projectId: projectId,
                                );
                                var data = jsonDecode(response.body);
                                if (response.statusCode == 201) {
                                  getTaskList();
                                } else {
                                  showProgress = false;
                                  if(!mounted) return;
                                  setState(() {});
                                  CommonFunctions().showError(data: data, context: context);
                                }
                              }
                            }
                          },
                          text: isUpdate ? "Update task" : "Create task",
                        ),
                      ),
                    ],
                  ),
                )
              ]
          ),
        );
      }),
    );
  }

}
