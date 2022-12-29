
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/model/assign_task_modal.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({Key? key, required this.taskId, required this.projectData}) : super(key: key);

  final int taskId;
  final dynamic projectData;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceInOut,
    reverseCurve: Curves.bounceInOut,
  );

  dynamic taskData;
  Color? taskStatusColor;
  bool showProgress = true;
  bool isExpanded = false;
  bool showAllDescription = false;

  TextEditingController assignTaskDescriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getTask();
    super.initState();
  }

  Future<void> getTask()async{
    await Future.delayed(const Duration(seconds: 0));
    var response = await ServiceApis().getTask(taskId: widget.taskId);
    var data = jsonDecode(response.body);
    print(data);
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
      showProgress = false;
      setState(() {});
    } else {
      showProgress = false;
      setState(() {});
      Widgets().showError(data: data, context: context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          taskData == null ? "" : taskData["name"],
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        shadowColor: Colors.black,
      ),
      body: Center(
        child: showProgress ? const CircularProgressIndicator(
          color: kThemeColor,
        ) : Container(
          constraints: BoxConstraints(
            maxWidth: 450,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: taskData == null ? [] : [
                AnimatedContainer(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: taskStatusColor!.withOpacity(0.6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: taskStatusColor!.withOpacity(0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 600),
                  child: Material(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      onTap: (){
                        showAllDescription = !showAllDescription;
                        setState(() {});
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      splashColor: taskStatusColor!.withOpacity(0.1),
                      hoverColor: taskStatusColor!.withOpacity(0.1),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${taskData["status"][0].toUpperCase()}${taskData["status"].substring(1).toLowerCase()}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: taskStatusColor!,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          if(taskData["name"].isNotEmpty)
                            Text(
                              taskData["name"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,

                              ),
                            ),
                          const SizedBox(height: 5,),
                          AnimatedContainer(
                            constraints: BoxConstraints(
                              maxHeight: showAllDescription ? 100 : 48,
                            ),
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 600),
                            child: SingleChildScrollView(
                              physics: showAllDescription ? ScrollPhysics() : NeverScrollableScrollPhysics(),
                              child: Text(
                                taskData["description"],
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            height: 25,
                            color: Colors.grey,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Assigned task developers",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6,),
                                    if(taskData["assigned_task"].isNotEmpty)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                    width: (taskData["assigned_task"].length * 26)+ 14.0,
                                                  ),
                                                  for(int j = 0; j < (taskData["assigned_task"].length > 4 ? 5 : taskData["assigned_task"].length); j++)
                                                    if(j > 3)
                                                      Positioned(
                                                        left: j * 26 + 2,
                                                        top: 2,
                                                        child: Container(
                                                          width: 36,
                                                          height: 36,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(18),
                                                            // border: Border.all(color: Colors.grey),
                                                            color: Colors.indigo,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black.withOpacity(0.3),
                                                                blurRadius: 4,
                                                              )
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "${taskData["assigned_task"].length - 4}+",
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Positioned(
                                                        left: j * 26 + 2,
                                                        top: 2,
                                                        child: Container(
                                                          margin: const EdgeInsets.only(right: 5),
                                                          width: 36,
                                                          height: 36,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(18),
                                                            // border: Border.all(color: Colors.grey),
                                                            color: kPrimaryColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black.withOpacity(0.3),
                                                                blurRadius: 4,
                                                              )
                                                            ],
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(20),
                                                            child: taskData["assigned_task"][j]["developer"]["photo"] == null ? Widgets().noProfileContainer(
                                                              name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                                  taskData["assigned_task"][j]["developer"]["last_name"][0],
                                                            ) : taskData["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                                                            Image.network(
                                                              taskData["assigned_task"][j]["developer"]["photo"],
                                                              width: 40,
                                                              height: 40,
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
                                                                  name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                                      taskData["assigned_task"][j]["developer"]["last_name"][0],
                                                                );
                                                              },
                                                            ) : Widgets().noProfileContainer(
                                                              name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                                  taskData["assigned_task"][j]["developer"]["last_name"][0],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      const Text(
                                        "No developer assigned to this task.",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    const SizedBox(height: 5,),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if(_controller.isCompleted){
                                    _controller.reverse();
                                  }else {
                                    _controller.forward();
                                  }
                                  isExpanded = !isExpanded;
                                  setState(() {});
                                },
                                child: RotationTransition(
                                  turns: _animation,
                                  child: Icon(
                                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_rounded,
                                    color: taskStatusColor!,
                                    size: 30,
                                  ),
                                ),
                              )
                            ],
                          ),
                          AnimatedContainer(
                            constraints: BoxConstraints(
                              maxHeight: isExpanded ? 320 : 0,
                            ),
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 600),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      for(int j = 0; j < taskData["assigned_task"].length; j++)
                                        Container(
                                          margin: const EdgeInsets.only(top: 8,),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: taskStatusColor!.withOpacity(0.6),
                                            ),
                                            borderRadius: BorderRadius.circular(10),
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
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                              splashColor: taskStatusColor!.withOpacity(0.1),
                                              hoverColor: taskStatusColor!.withOpacity(0.1),
                                              title: Row(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(right: 5),
                                                    width: 36,
                                                    height: 36,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(18),
                                                      // border: Border.all(color: Colors.grey),
                                                      color: kPrimaryColor,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.3),
                                                          blurRadius: 4,
                                                        )
                                                      ],
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: taskData["assigned_task"][j]["developer"]["photo"] == null ? Widgets().noProfileContainer(
                                                        name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                            taskData["assigned_task"][j]["developer"]["last_name"][0],
                                                      ) : taskData["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                                                      Image.network(
                                                        taskData["assigned_task"][j]["developer"]["photo"],
                                                        width: 40,
                                                        height: 40,
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
                                                            name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                                taskData["assigned_task"][j]["developer"]["last_name"][0],
                                                          );
                                                        },
                                                      ) : Widgets().noProfileContainer(
                                                        name: taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                            taskData["assigned_task"][j]["developer"]["last_name"][0],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${taskData["assigned_task"][j]["developer"]["first_name"]} ${taskData["assigned_task"][j]["developer"]["last_name"]}",
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        Text(
                                                          taskData["assigned_task"][j]["developer"]["email"],
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
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
                                      "${taskData["total_time_hr"]} hour",
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
                                      "${taskData["estimate_time"]} hour",
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
                      tileColor: taskStatusColor!.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      dense: true,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 22.0, right: 22, bottom: 8),
                  child: Text(
                    "Assigned tasks",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if(taskData['assigned_task'].isNotEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: [
                              for(int i = 0; i < taskData['assigned_task'].length; i++)
                                Container(
                                  width: 200,
                                    height: 200,
                                  margin: const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: taskStatusColor!.withOpacity(0.6),
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
                                        if(SharedPreference.getUser()!.type == "merchant" || SharedPreference.getUser()!.id == widget.projectData["manager"][  "id"]) {
                                          assignTaskDescriptionController.text =
                                          taskData["assigned_task"][i]["note"];
                                          AssignTaskModal().assignUserModal(
                                              isEdit: true,
                                              selectedDeveloper: taskData["assigned_task"][i]["developer"],
                                              context: context,
                                              assignTaskDescriptionController: assignTaskDescriptionController,
                                              assignedTaskList: taskData["assigned_task"],
                                              projectTeam: widget
                                                  .projectData["team"],
                                              onAssign: (
                                                  selectedTeamMember) async {
                                                if (selectedTeamMember !=
                                                    null) {
                                                  showProgress = true;
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                  var response = await ServiceApis()
                                                      .changeAssignedTaskDeveloper(
                                                    taskId: taskData["assigned_task"][i]["id"],
                                                    developerId: selectedTeamMember["id"],
                                                    note: assignTaskDescriptionController
                                                        .text,
                                                  );
                                                  if (response.statusCode ==
                                                      200) {
                                                    await getTask();
                                                    Widgets().showAlertDialog(
                                                        alertMessage: "Task assigned successfuly.",
                                                        context: context);
                                                  } else {
                                                    showProgress = false;
                                                    setState(() {});
                                                    var data = jsonDecode(
                                                        response.body);
                                                    Widgets().showError(
                                                        data: data,
                                                        context: context);
                                                  }
                                                } else {
                                                  Widgets().showAlertDialog(
                                                      alertMessage: "Developer must be selected to assign task.",
                                                      context: context);
                                                }
                                              },
                                              onDelete: () async {
                                                showProgress = true;
                                                setState(() {});
                                                Navigator.pop(context);
                                                var response = await ServiceApis()
                                                    .deleteAssignedTask(
                                                  assignTaskId: taskData["assigned_task"][i]["id"],
                                                );
                                                if (response.statusCode ==
                                                    204) {
                                                  await getTask();
                                                  showProgress = false;
                                                  setState(() {});
                                                  Widgets().showAlertDialog(
                                                      alertMessage: "Assigned task deleted successfully.",
                                                      context: context);
                                                } else {
                                                  showProgress = false;
                                                  setState(() {});
                                                  var data = jsonDecode(
                                                      response.body);
                                                  Widgets().showError(
                                                      data: data,
                                                      context: context);
                                                }
                                              }
                                          );
                                        }
                                      },
                                      contentPadding: const EdgeInsets.all(10),
                                      splashColor: taskStatusColor!.withOpacity(0.1),
                                      hoverColor: taskStatusColor!.withOpacity(0.1),
                                      title: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.all(5),
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  // border: Border.all(color: Colors.grey),
                                                  color: kPrimaryColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.3),
                                                      blurRadius: 4,
                                                    )
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: taskData["assigned_task"][i]["developer"]["photo"] == null ? Widgets().noProfileContainer(
                                                    name: taskData["assigned_task"][i]["developer"]["first_name"][0]+
                                                        taskData["assigned_task"][i]["developer"]["last_name"][0],
                                                  ) : taskData["assigned_task"][i]["developer"]["photo"].isNotEmpty ?
                                                  Image.network(
                                                    taskData["assigned_task"][i]["developer"]["photo"],
                                                    width: 40,
                                                    height: 40,
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
                                                        name: taskData["assigned_task"][i]["developer"]["first_name"][0]+
                                                            taskData["assigned_task"][i]["developer"]["last_name"][0],
                                                      );
                                                    },
                                                  ) : Widgets().noProfileContainer(
                                                    name: taskData["assigned_task"][i]["developer"]["first_name"][0]+
                                                        taskData["assigned_task"][i]["developer"]["last_name"][0],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 6.0),
                                                      child: Text(
                                                        "${taskData["assigned_task"][i]["developer"]["type"][0].toUpperCase()}${taskData["assigned_task"][i]["developer"]["type"].substring(1).toLowerCase()}",
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 6.0),
                                                      child: Text(
                                                        "${taskData["assigned_task"][i]["developer"]["first_name"]}",
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // PopupMenuButton<String>(
                                              //     surfaceTintColor: widget.taskData["status"] == "active" ?
                                              //     Colors.green[200] : widget.taskData["status"] == "in-progress" ?
                                              //     Colors.amber[200] : widget.taskData["status"] == "completed" ? Colors.blue[200] : Colors.white,
                                              //     shadowColor: widget.taskData["status"] == "active" ?
                                              //     Colors.green : widget.taskData["status"] == "in-progress" ?
                                              //     Colors.amber : widget.taskData["status"] == "completed" ? Colors.blue : Colors.white,
                                              //     elevation: 10,
                                              //     shape: RoundedRectangleBorder(
                                              //       borderRadius: BorderRadius.circular(10),
                                              //       side: BorderSide(
                                              //         color: widget.taskData["status"] == "active" ?
                                              //         Colors.green : widget.taskData["status"] == "in-progress" ?
                                              //         Colors.amber : widget.taskData["status"] == "completed" ? Colors.blue : Colors.white,
                                              //       ),
                                              //     ),
                                              //     onSelected: (option) async {
                                              //       switch (option) {
                                              //         case 'Change Assignee':
                                              //           assignTaskDescriptionController.text = widget.taskData["assigned_task"][i]["note"];
                                              //           AssignTaskModal().assignUserModal(
                                              //             context: context,
                                              //             assignTaskDescriptionController: assignTaskDescriptionController,
                                              //             assignedTaskList: widget.taskData["assigned_task"],
                                              //             projectTeam: widget.projectData["team"],
                                              //             onAssign: (selectedTeamMember) async {
                                              //               if(selectedTeamMember != null){
                                              //                 // showProgress = true;
                                              //                 // setState(() {});
                                              //                 // Navigator.pop(context);
                                              //                 // var response = await ServiceApis().assignTask(
                                              //                 //   developerId: selectedTeamMember["id"],
                                              //                 //   taskId: taskList[i]["id"],
                                              //                 //   note: assignTaskDescriptionController.text,
                                              //                 // );
                                              //                 // if(response.statusCode == 201){
                                              //                 //   await getTaskList();
                                              //                 //   Widgets().showAlertDialog(alertMessage: "Task assigned successfuly.", context: context);
                                              //                 // }else{
                                              //                 //   showProgress = false;
                                              //                 //   setState(() {});
                                              //                 //   var data = jsonDecode(response.body);
                                              //                 //   Widgets().showError(data: data, context: context);
                                              //                 // }
                                              //               }else{
                                              //                 Widgets().showAlertDialog(alertMessage: "Developer must be selected to assign task.", context: context);
                                              //               }
                                              //             },
                                              //           );
                                              //           break;
                                              //         case 'Delete':
                                              //           break;
                                              //         default:
                                              //           break;
                                              //       }
                                              //       print("-- $option --");
                                              //     },
                                              //     splashRadius: 1,
                                              //     tooltip: "Options",
                                              //     padding: const EdgeInsets.all(0),
                                              //     itemBuilder: (BuildContext context) {
                                              //       return ["Change Assignee", "Delete"].map((String choice) {
                                              //         return PopupMenuItem<String>(
                                              //           value: choice,
                                              //           child: Text(
                                              //             choice,
                                              //             style: TextStyle(
                                              //               color: widget.taskData["status"] == "active" ?
                                              //               Colors.green : widget.taskData["status"] == "in-progress" ?
                                              //               Colors.amber : widget.taskData["status"] == "completed" ? Colors.blue : Colors.white,
                                              //               fontSize: 18,
                                              //             ),
                                              //           ),
                                              //         );
                                              //       }).toList();
                                              //     },
                                              //     child: SizedBox(
                                              //       width: 20,
                                              //       child: Icon(
                                              //         Icons.more_vert,
                                              //         color: widget.taskData["status"] == "active" ?
                                              //         Colors.green : widget.taskData["status"] == "in-progress" ?
                                              //         Colors.amber : widget.taskData["status"] == "completed" ? Colors.blue : Colors.white,
                                              //       ),
                                              //     )),
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(left: 6.0,),
                                          //   child: Text(
                                          //     "${widget.taskData["assigned_task"][i]["developer"]["email"]}",
                                          //     maxLines: 1,
                                          //     style: const TextStyle(
                                          //       fontSize: 12,
                                          //     ),
                                          //   ),
                                          // ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 6.0, top: 5),
                                                child: Text(
                                                  taskData["assigned_task"][i]["note"],
                                                  // maxLines: 4,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 6.0, top: 5),
                                            child: Text(
                                              DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(taskData["assigned_task"][i]["created_at"])),
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
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
                                ),
                              const SizedBox(width: 20,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30), 
                      child: Text(
                        "This task is not assigned to anyone.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SharedPreference.getUser()!.type == "merchant" || SharedPreference.getUser()!.id == widget.projectData["manager"][  "id"] ?  FloatingActionButton(
        onPressed: (){
          assignTaskDescriptionController.text = "";
          AssignTaskModal().assignUserModal(
              context: context,
              assignTaskDescriptionController: assignTaskDescriptionController,
              assignedTaskList: taskData["assigned_task"],
              projectTeam: widget.projectData["team"],
              onAssign: (selectedTeamMember) async {
                if(selectedTeamMember != null){
                  showProgress = true;
                  setState(() {});
                  Navigator.pop(context);
                  var response = await ServiceApis().assignTask(
                    developerId: selectedTeamMember["id"],
                    taskId: taskData["id"],
                    note: assignTaskDescriptionController.text,
                  );
                  if(response.statusCode == 201){
                    await getTask();
                    Widgets().showAlertDialog(alertMessage: "Task assigned successfuly.", context: context);
                  }else{
                    showProgress = false;
                    setState(() {});
                    var data = jsonDecode(response.body);
                    Widgets().showError(data: data, context: context);
                  }
                }else{
                  Widgets().showAlertDialog(alertMessage: "Developer must be selected to assign task.", context: context);
                }
              },
          );
        },
        child: const Icon(Icons.add, size: 28,),
      ) : const Center(),
    );
  }
}
