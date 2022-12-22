
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/screens/task_detail.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    getTaskList();
    super.initState();
  }

  Future<void> getTaskList()async{
    await Future.delayed(const Duration(seconds: 0));
    var response = await ServiceApis().getTaskList(projectId: widget.projectData["id"].toString());
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      taskList = data;
      showProgress = false;
      setState(() {});
    } else {
      showProgress = false;
      setState(() {});
      Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.projectData["name"],
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        shadowColor: Colors.black,
        centerTitle: true,
      ),
      body: showProgress ? const Center(
        child: CircularProgressIndicator(
          color: kThemeColor,
        ),
      ) : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: widget.projectData["status"] == "active" ?
                  Colors.green.withOpacity(0.7) : widget.projectData["status"] == "in-progress" ?
                  Colors.amber.withOpacity(0.7) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.7) : Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: widget.projectData["status"] == "active" ?
                    Colors.green.withOpacity(0.3) : widget.projectData["status"] == "in-progress" ?
                    Colors.amber.withOpacity(0.3) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.3),
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
                    isExpanded = !isExpanded;
                    setState(() {});
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10,),
                  splashColor: widget.projectData["status"] == "active" ?
                  Colors.green.withOpacity(0.1) : widget.projectData["status"] == "in-progress" ?
                  Colors.amber.withOpacity(0.1) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                  hoverColor: widget.projectData["status"] == "active" ?
                  Colors.green.withOpacity(0.1) : widget.projectData["status"] == "in-progress" ?
                  Colors.amber.withOpacity(0.1) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(widget.projectData["name"].isNotEmpty)
                        Text(
                          widget.projectData["name"],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: widget.projectData["status"] == "active" ?
                            Colors.green : widget.projectData["status"] == "in-progress" ?
                            Colors.amber : widget.projectData["status"] == "completed" ? Colors.blue : Colors.white,
                          ),
                        ),
                      const SizedBox(height: 5,),
                      Text(
                        widget.projectData["description"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
                                  "Team",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6,),
                                if(widget.projectData["team"].isNotEmpty)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: (widget.projectData["team"].length * 26)+ 14.0,
                                              ),
                                              for(int j = 0; j < (widget.projectData["team"].length > 4 ? 5 : widget.projectData["team"].length); j++)
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
                                                          "${widget.projectData["team"].length - 4}+",
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
                                                        child: widget.projectData["team"][j]["photo"].isNotEmpty ?
                                                        Image.network(
                                                          widget.projectData["team"][j]["photo"],
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
                                                              name: widget.projectData["team"][j]["first_name"][0]+
                                                                  widget.projectData["team"][j]["last_name"][0],
                                                            );
                                                          },
                                                        ) : Widgets().noProfileContainer(
                                                          name: widget.projectData["team"][j]["first_name"][0]+
                                                              widget.projectData["team"][j]["last_name"][0],
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
                                    "No team member is added.",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                const SizedBox(height: 2,),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Status",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                widget.projectData["status"] == "active" ?
                                "Active" : widget.projectData["status"] == "in-progress" ?
                                "In-progress" : widget.projectData["status"] == "completed" ? "Completed" : "",
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                  color: widget.projectData["status"] == "active" ?
                                  Colors.green : widget.projectData["status"] == "in-progress" ?
                                  Colors.amber : widget.projectData["status"] == "completed" ? Colors.blue : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if(widget.projectData["team"].isNotEmpty)
                        if(isExpanded)
                          Column(
                            children: [
                              const SizedBox(height: 15,),
                              for(int j = 0; j < widget.projectData["team"].length; j++)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8,),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: widget.projectData["status"] == "active" ?
                                    Colors.green.withOpacity(0.05) : widget.projectData["status"] == "in-progress" ?
                                    Colors.amber.withOpacity(0.05) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.05) : Colors.black.withOpacity(0.3),
                                    border: Border.all(
                                      color: widget.projectData["status"] == "active" ?
                                      Colors.green.withOpacity(0.7) : widget.projectData["status"] == "in-progress" ?
                                      Colors.amber.withOpacity(0.7) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.7) : Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
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
                                          child: widget.projectData["team"][j]["photo"].isNotEmpty ?
                                          Image.network(
                                            widget.projectData["team"][j]["photo"],
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
                                                name: widget.projectData["team"][j]["first_name"][0]+
                                                    widget.projectData["team"][j]["last_name"][0],
                                              );
                                            },
                                          ) : Widgets().noProfileContainer(
                                            name: widget.projectData["team"][j]["first_name"][0]+
                                                widget.projectData["team"][j]["last_name"][0],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${widget.projectData["team"][j]["first_name"]} ${widget.projectData["team"][j]["last_name"]}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              widget.projectData["team"][j]["email"],
                                              style: const TextStyle(
                                                fontSize: 14,
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
                    ],
                  ),
                  tileColor: widget.projectData["status"] == "active" ?
                  Colors.green.withOpacity(0.06) : widget.projectData["status"] == "in-progress" ?
                  Colors.yellow.withOpacity(0.06) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.06) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dense: true,
                ),
              ),
            ),
            // Container(
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
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //     decoration: BoxDecoration(
            //       color: widget.projectData["status"] == "active" ?
            //       Colors.green.withOpacity(0.06) : widget.projectData["status"] == "in-progress" ?
            //       Colors.yellow.withOpacity(0.06) : widget.projectData["status"] == "completed" ? Colors.blue.withOpacity(0.06) : Colors.white,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         if(widget.projectData["name"].isNotEmpty)
            //           Text(
            //             widget.projectData["name"],
            //             style: TextStyle(
            //               fontSize: 24,
            //               fontWeight: FontWeight.bold,
            //               color: widget.projectData["status"] == "active" ?
            //               Colors.green : widget.projectData["status"] == "in-progress" ?
            //               Colors.amber : widget.projectData["status"] == "completed" ? Colors.blue : Colors.white,
            //             ),
            //           ),
            //         const SizedBox(height: 5,),
            //         Text(
            //           widget.projectData["description"],
            //           style: const TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //         const Divider(
            //           height: 25,
            //           color: Colors.grey,
            //         ),
            //         Row(
            //           children: [
            //             Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   const Text(
            //                     "Team",
            //                     style: TextStyle(
            //                       fontWeight: FontWeight.w500,
            //                       fontSize: 16,
            //                     ),
            //                   ),
            //                   const SizedBox(height: 6,),
            //                   Row(
            //                     children: [
            //                       Expanded(
            //                         child: SingleChildScrollView(
            //                           scrollDirection: Axis.horizontal,
            //                           child: Stack(
            //                             children: [
            //                               SizedBox(
            //                                 height: 40,
            //                                 width: (widget.projectData["team"].length * 26)+ 14.0,
            //                               ),
            //                               for(int j = 0; j < (widget.projectData["team"].length > 4 ? 5 : widget.projectData["team"].length); j++)
            //                                 if(j > 3)
            //                                   Positioned(
            //                                     left: j * 26 + 2,
            //                                     top: 2,
            //                                     child: Container(
            //                                       width: 36,
            //                                       height: 36,
            //                                       decoration: BoxDecoration(
            //                                         borderRadius: BorderRadius.circular(18),
            //                                         // border: Border.all(color: Colors.grey),
            //                                         color: Colors.indigo,
            //                                         boxShadow: [
            //                                           BoxShadow(
            //                                             color: Colors.black.withOpacity(0.3),
            //                                             blurRadius: 4,
            //                                           )
            //                                         ],
            //                                       ),
            //                                       child: Center(
            //                                         child: Text(
            //                                           "${widget.projectData["team"].length - 4}+",
            //                                           style: const TextStyle(
            //                                             color: Colors.white,
            //                                             fontWeight: FontWeight.bold,
            //                                             fontSize: 18,
            //                                           ),
            //                                         ),
            //                                       ),
            //                                     ),
            //                                   )
            //                                 else
            //                                   Positioned(
            //                                     left: j * 26 + 2,
            //                                     top: 2,
            //                                     child: Container(
            //                                       margin: const EdgeInsets.only(right: 5),
            //                                       width: 36,
            //                                       height: 36,
            //                                       decoration: BoxDecoration(
            //                                         borderRadius: BorderRadius.circular(18),
            //                                         // border: Border.all(color: Colors.grey),
            //                                         color: kPrimaryColor,
            //                                         boxShadow: [
            //                                           BoxShadow(
            //                                             color: Colors.black.withOpacity(0.3),
            //                                             blurRadius: 4,
            //                                           )
            //                                         ],
            //                                       ),
            //                                       child: ClipRRect(
            //                                         borderRadius: BorderRadius.circular(20),
            //                                         child: widget.projectData["team"][j]["photo"].isNotEmpty ?
            //                                         Image.network(
            //                                           widget.projectData["team"][j]["photo"],
            //                                           width: 40,
            //                                           height: 40,
            //                                           fit: BoxFit.cover,
            //                                           loadingBuilder: (context, child, loadingProgress){
            //                                             if(loadingProgress != null){
            //                                               return const Center(
            //                                                 child: CircularProgressIndicator(
            //                                                   color: kThemeColor,
            //                                                   strokeWidth: 3,
            //                                                 ),
            //                                               );
            //                                             }else{
            //                                               return child;
            //                                             }
            //                                           },
            //                                           errorBuilder: (context, obj, st){
            //                                             return Widgets().noProfileContainer(
            //                                               name: widget.projectData["team"][j]["first_name"][0]+
            //                                                   widget.projectData["team"][j]["last_name"][0],
            //                                             );
            //                                           },
            //                                         ) : Widgets().noProfileContainer(
            //                                           name: widget.projectData["team"][j]["first_name"][0]+
            //                                               widget.projectData["team"][j]["last_name"][0],
            //                                         ),
            //                                       ),
            //                                     ),
            //                                   ),
            //                             ],
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                   const SizedBox(height: 2,),
            //                 ],
            //               ),
            //             ),
            //             Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.end,
            //               children: [
            //                 const Text(
            //                   "Status",
            //                   style: TextStyle(
            //                     fontWeight: FontWeight.w500,
            //                     fontSize: 15,
            //                   ),
            //                 ),
            //                 Text(
            //                   widget.projectData["status"] == "active" ?
            //                   "Active" : widget.projectData["status"] == "in-progress" ?
            //                   "In-progress" : widget.projectData["status"] == "completed" ? "Completed" : "",
            //                   style: TextStyle(
            //                     fontSize: 20,
            //                     height: 1,
            //                     fontWeight: FontWeight.bold,
            //                     color: widget.projectData["status"] == "active" ?
            //                     Colors.green : widget.projectData["status"] == "in-progress" ?
            //                     Colors.amber : widget.projectData["status"] == "completed" ? Colors.blue : Colors.black,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //         if(isExpanded)
            //           Text("Expanded"),
            //       ],
            //     ),
            //   ),
            // ),
            const Padding(
              padding: EdgeInsets.only(left: 22.0, right: 22, bottom: 8),
              child: Text(
                "Tasks",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            for(int i = 0; i < taskList.length; i++)
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: taskList[i]["status"] == "active" ?
                    Colors.green.withOpacity(0.7) : taskList[i]["status"] == "in-progress" ?
                    Colors.amber.withOpacity(0.7) : taskList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.7) : Colors.white,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: taskList[i]["status"] == "active" ?
                      Colors.green.withOpacity(0.3) : taskList[i]["status"] == "in-progress" ?
                      Colors.amber.withOpacity(0.3) : taskList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.3),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetail(taskData: taskList[i], projectData: widget.projectData)));
                    },
                    contentPadding: const EdgeInsets.only(left:0, right: 16, top: 10, bottom: 10),
                    splashColor: taskList[i]["status"] == "active" ?
                    Colors.green.withOpacity(0.1) : taskList[i]["status"] == "in-progress" ?
                    Colors.amber.withOpacity(0.1) : taskList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                    hoverColor: taskList[i]["status"] == "active" ?
                    Colors.green.withOpacity(0.1) : taskList[i]["status"] == "in-progress" ?
                    Colors.amber.withOpacity(0.1) : taskList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                    title: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 80,
                          decoration: BoxDecoration(
                            color: taskList[i]["status"] == "active" ?
                            Colors.green : taskList[i]["status"] == "in-progress" ?
                            Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  if(taskList[i]["name"].isNotEmpty)
                                    Expanded(
                                      child: Text(
                                        taskList[i]["name"],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: taskList[i]["status"] == "active" ?
                                          Colors.green : taskList[i]["status"] == "in-progress" ?
                                          Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                        ),
                                      ),
                                    ),
                                  if(SharedPreference.isLogin())
                                    if(SharedPreference.getUser()!.type == "manager" || SharedPreference.getUser()!.type == "merchant")
                                      PopupMenuButton<String>(
                                          surfaceTintColor: taskList[i]["status"] == "active" ?
                                          Colors.green[200] : taskList[i]["status"] == "in-progress" ?
                                          Colors.amber[200] : taskList[i]["status"] == "completed" ? Colors.blue[200] : Colors.white,
                                          shadowColor: taskList[i]["status"] == "active" ?
                                          Colors.green : taskList[i]["status"] == "in-progress" ?
                                          Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(
                                              color: taskList[i]["status"] == "active" ?
                                              Colors.green : taskList[i]["status"] == "in-progress" ?
                                              Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                            ),
                                          ),
                                          onSelected: (option) async {
                                            switch (option) {
                                              case 'Assign':
                                                assignUserModal(taskIndex: i);
                                                break;
                                              case 'Update':
                                                taskNameController.text = taskList[i]["name"];
                                                taskDescriptionController.text = taskList[i]["description"];
                                                editCreateTaskModal(projectId: widget.projectData["id"], isUpdate: true, taskId: taskList[i]["id"].toString());
                                                break;
                                              case 'Update status':
                                                break;
                                              case 'Delete':
                                                Widgets().showConfirmationDialog(
                                                  confirmationMessage: "Are you sure to delete this task.",
                                                  confirmButtonText: "Delete",
                                                  cancelButtonText: "Cancel",
                                                  context: context,
                                                  onConfirm: ()async{
                                                    showProgress = true;
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                    var response = await ServiceApis().deleteTask(taskId: taskList[i]["id"].toString());
                                                    if(response.statusCode == 204){
                                                      await getTaskList();
                                                      Widgets().showAlertDialog(alertMessage: "Task deleted successfuly", context: context);
                                                    }else{
                                                      showProgress = true;
                                                      setState(() {});
                                                      Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context);
                                                    }
                                                  },
                                                );
                                                break;
                                              default:
                                                break;
                                            }
                                            print("-- $option --");
                                          },
                                          icon: Icon(
                                            Icons.more_horiz,
                                            color: taskList[i]["status"] == "active" ?
                                            Colors.green : taskList[i]["status"] == "in-progress" ?
                                            Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                            size: 30,
                                          ),
                                          splashRadius: 1,
                                          tooltip: "Options",
                                          padding: const EdgeInsets.all(0),
                                          itemBuilder: (BuildContext context) {
                                            return ["Assign", "Update", "Update status", "Delete"].map((String choice) {
                                              return PopupMenuItem<String>(
                                                value: choice,
                                                child: choice == "Update status" ?
                                                PopupMenuButton(
                                                  surfaceTintColor: taskList[i]["status"] == "active" ?
                                                  Colors.green[200] : taskList[i]["status"] == "in-progress" ?
                                                  Colors.amber[200] : taskList[i]["status"] == "completed" ? Colors.blue[200] : Colors.white,
                                                  shadowColor: taskList[i]["status"] == "active" ?
                                                  Colors.green : taskList[i]["status"] == "in-progress" ?
                                                  Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    side: BorderSide(
                                                      color: taskList[i]["status"] == "active" ?
                                                      Colors.green : taskList[i]["status"] == "in-progress" ?
                                                      Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                                    ),
                                                  ),
                                                  itemBuilder: (BuildContext context){
                                                    return ["Assign", "active", "in-progress", "completed"].map((String status) {
                                                      return PopupMenuItem<String>(
                                                        value: status,
                                                        child: Text(
                                                          status,
                                                          style: TextStyle(
                                                            color: taskList[i]["status"] == "active" ?
                                                            Colors.green : taskList[i]["status"] == "in-progress" ?
                                                            Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList();
                                                  },
                                                  splashRadius: 1,
                                                  onSelected: (status) async {
                                                    if(["active", "in-progress", "completed"].contains(status)){
                                                      Navigator.pop(context);
                                                      showProgress = true;
                                                      setState(() {});
                                                      var response = await ServiceApis().updateTaskStatus(taskId: taskList[i]["id"].toString(), status: status);
                                                      if(response.statusCode == 200){
                                                        getTaskList();
                                                      } else {
                                                        showProgress = false;
                                                        setState(() {});
                                                        Widgets().showAlertDialog(
                                                            alertMessage: "Something went wrong",
                                                            context: context);
                                                      }
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                          child: Text(
                                                            "Update status",
                                                            style: TextStyle(
                                                              color: taskList[i]["status"] == "active" ?
                                                              Colors.green : taskList[i]["status"] == "in-progress" ?
                                                              Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                    : Text(
                                                  choice,
                                                  style: TextStyle(
                                                    color: taskList[i]["status"] == "active" ?
                                                    Colors.green : taskList[i]["status"] == "in-progress" ?
                                                    Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              );
                                            }).toList();
                                          }),
                                ],
                              ),
                              if(taskList[i]["description"].isNotEmpty)
                                Text(
                                  taskList[i]["description"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    // fontWeight: FontWeight.w500,
                                  ),
                                ),
                              const SizedBox(height: 3,),
                              Text(
                                DateFormat("dd MM yyyy hh:mm a").format(DateTime.parse(taskList[i]["created_at"])),
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
                                        // const Text(
                                        //   "Team",
                                        //   style: TextStyle(
                                        //     fontWeight: FontWeight.w500,
                                        //     fontSize: 16,
                                        //   ),
                                        // ),
                                        // const SizedBox(height: 6,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: taskList[i]["assigned_task"].isEmpty ? const Text(
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
                                                      width: (taskList[i]["assigned_task"].length * 20)+ 10.0,
                                                    ),
                                                    for(int j = 0; j < (taskList[i]["assigned_task"].length > 4 ? 5 : taskList[i]["assigned_task"].length); j++)
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
                                                                "${taskList[i]["assigned_task"].length - 4}+",
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
                                                              child: taskList[i]["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                                                              Image.network(
                                                                taskList[i]["assigned_task"][j]["developer"]["photo"],
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
                                                                    name: taskList[i]["assigned_task"][j]["developer"]["first_name"][0]+
                                                                        taskList[i]["assigned_task"][j]["developer"]["last_name"][0],
                                                                  );
                                                                },
                                                              ) : Widgets().noProfileContainer(
                                                                name: taskList[i]["assigned_task"][j]["developer"]["first_name"][0]+
                                                                    taskList[i]["assigned_task"][j]["developer"]["last_name"][0],
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
                                    taskList[i]["status"] == "active" ?
                                    "Active" : taskList[i]["status"] == "in-progress" ?
                                    "In-progress" : taskList[i]["status"] == "completed" ? "Completed" : "",
                                    style: TextStyle(
                                      fontSize: 18,
                                      height: 1,
                                      fontWeight: FontWeight.bold,
                                      color: taskList[i]["status"] == "active" ?
                                      Colors.green : taskList[i]["status"] == "in-progress" ?
                                      Colors.amber : taskList[i]["status"] == "completed" ? Colors.blue : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              // const Divider(
                              //   color: Colors.grey,
                              // ),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Expanded(
                              //       child: Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           const Text(
                              //             "Team",
                              //             style: TextStyle(
                              //               fontWeight: FontWeight.w500,
                              //               fontSize: 15,
                              //             ),
                              //           ),
                              //           const SizedBox(height: 5,),
                              //           if(projectList[i]["team"].isNotEmpty)
                              //             Row(
                              //               children: [
                              //                 Expanded(
                              //                   child: SingleChildScrollView(
                              //                     scrollDirection: Axis.horizontal,
                              //                     child: Stack(
                              //                       children: [
                              //                         SizedBox(
                              //                           height: 40,
                              //                           width: (projectList[i]["team"].length * 27)+ 8.0,
                              //                         ),
                              //                         for(int j = 0; j < projectList[i]["team"].length; j++)
                              //                           Positioned(
                              //                             left: j * 27,
                              //                             child: Container(
                              //                               width: 35,
                              //                               height: 35,
                              //                               decoration: BoxDecoration(
                              //                                 borderRadius: BorderRadius.circular(20),
                              //                                 border: Border.all(color: Colors.grey),
                              //                                 color: kPrimaryColor,
                              //                               ),
                              //                               child: ClipRRect(
                              //                                 borderRadius: BorderRadius.circular(20),
                              //                                 child: businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList().isNotEmpty ?
                              //                                 (businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList()[0]["photo"].isNotEmpty ?
                              //                                 Image.network(
                              //                                   businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList()[0]["photo"],
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
                              //                                       name: businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList()[0]["first_name"][0]+
                              //                                           businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList()[0]["last_name"][0],
                              //                                     );
                              //                                   },
                              //                                 ) : Widgets().noProfileContainer(
                              //                                   name: businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList()[0]["first_name"][0]+
                              //                                       businessUserList.where((element) => element["id"].toString() == projectList[i]["team"][j].toString()).toList()[0]["last_name"][0],
                              //                                 )) : Image.asset("assets/images/profile.png"),
                              //                               ),
                              //                             ),
                              //                           ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //         ],
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       height: 68,
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         crossAxisAlignment: CrossAxisAlignment.end,
                              //         children: [
                              //           const Text(
                              //             "Status",
                              //             style: TextStyle(
                              //               fontWeight: FontWeight.w500,
                              //               fontSize: 15,
                              //             ),
                              //           ),
                              //           Text(
                              //             projectList[i]["status"] == "active" ?
                              //             "Active" : projectList[i]["status"] == "in-progress" ?
                              //             "In-progress" : projectList[i]["status"] == "completed" ? "Completed" : "",
                              //             style: TextStyle(
                              //               fontSize: 20,
                              //               height: 1,
                              //               fontWeight: FontWeight.bold,
                              //               color: projectList[i]["status"] == "active" ?
                              //               Colors.green : projectList[i]["status"] == "in-progress" ?
                              //               Colors.amber : projectList[i]["status"] == "completed" ? Colors.blue : Colors.black,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    tileColor: taskList[i]["status"] == "active" ?
                    Colors.green.withOpacity(0.06) : taskList[i]["status"] == "in-progress" ?
                    Colors.yellow.withOpacity(0.06) : taskList[i]["status"] == "completed" ? Colors.blue.withOpacity(0.06) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    dense: true,
                  ),
                ),
              ),
            const SizedBox(height: 80,),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      ),
    );
  }

  void editCreateTaskModal({bool isUpdate = false, String? taskId, required int projectId}){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, builder: (_) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 330,
          ),
          child: StatefulBuilder(
              builder: (_, addProjectState) {
                return Column(
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
                                    Widgets().showAlertDialog(
                                      alertMessage: "Task name can not be empty.",
                                      context: context,
                                    );
                                  } else {
                                    showProgress = true;
                                    setState(() {});
                                    Navigator.pop(context);
                                    var response;
                                    if(isUpdate){
                                      response = await ServiceApis().updateTask(
                                        taskId: taskId ?? "",
                                        taskName: taskNameController.text,
                                        taskDescription: taskDescriptionController.text,
                                        projectId: projectId,
                                      );
                                      if (response.statusCode == 200) {
                                        getTaskList();
                                      } else {
                                        showProgress = false;
                                        setState(() {});
                                        Widgets().showAlertDialog(
                                            alertMessage: "Something went wrong",
                                            context: context);
                                      }
                                    }else {
                                      response = await ServiceApis().createTask(
                                        taskName: taskNameController.text,
                                        taskDescription: taskDescriptionController.text,
                                        projectId: projectId,
                                      );
                                      if (response.statusCode == 201) {
                                        getTaskList();
                                      } else {
                                        showProgress = false;
                                        setState(() {});
                                        Widgets().showAlertDialog(
                                            alertMessage: "Something went wrong",
                                            context: context);
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
                );
              }
          ),
        ),
      );
    },
    );
  }

  void assignUserModal({required int taskIndex}){
    var selectedTeamMember;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, builder: (_) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: StatefulBuilder(
              builder: (_, state) {
                return Column(
                    children: [
                      const SizedBox(height: 20,),
                      const Text(
                        "Assign Task",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Widgets().textFormField(
                                  maxLines: 3,
                                  controller: assignTaskDescriptionController,
                                  labelText: "Enter project description",
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 15),
                                child: Text(
                                  "Assigned developer",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Container(
                                  padding: EdgeInsets.all(selectedTeamMember != null ? 0 : 15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: 6,
                                        ),
                                      ]
                                  ),
                                  child: PopupMenuButton<String>(
                                    // padding: EdgeInsets.only(right: 50),
                                    constraints: const BoxConstraints(
                                      maxHeight: 350,
                                    ),
                                    onSelected: (newValue){
                                      if(!taskList[taskIndex]['assigned_task'].map((element) => element["developer"]["id"]).toList().contains(widget.projectData["team"][int.parse(newValue)]["id"])) {
                                        selectedTeamMember = widget.projectData["team"][int.parse(newValue)];
                                        setState(() {});
                                        state(() {});
                                      }else{
                                        Widgets().showAlertDialog(alertMessage: "This task already assigned to this developer.", context: context);
                                      }
                                    },
                                    splashRadius: 1,
                                    tooltip: "select developer",
                                    itemBuilder: (BuildContext context) {
                                      List<PopupMenuEntry<String>> l = [];
                                      for(int i = 0; i < widget.projectData["team"].length; i++){
                                        l.add(PopupMenuItem<String>(
                                          value: i.toString(),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(vertical: 5),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.black,),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 55,
                                                  height: 55,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(40),
                                                    border: Border.all(color: Colors.grey),
                                                    color: kPrimaryColor,
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(40),
                                                    child: widget.projectData["team"][i]["photo"].isNotEmpty ? Image.network(
                                                      widget.projectData["team"][i]["photo"],
                                                      width: 80,
                                                      height: 80,
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
                                                        return Image.asset("assets/images/profile.png", width: 100, height: 100,);
                                                      },
                                                    ) : Image.asset("assets/images/profile.png", width: 80, height: 80,),
                                                  ),
                                                ),
                                                const SizedBox(width: 10,),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "${widget.projectData["team"][i]["first_name"]} ",
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: widget.projectData["team"][i]["last_name"],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 3,),
                                                      Text(
                                                        widget.projectData["team"][i]["phone"],
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.projectData["team"][i]["email"],
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                      }
                                      return l;
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        if(selectedTeamMember != null)
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: Colors.black,),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 55,
                                                    height: 55,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40),
                                                      border: Border.all(color: Colors.grey),
                                                      color: kPrimaryColor,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(40),
                                                      child: selectedTeamMember["photo"].isNotEmpty ? Image.network(
                                                        selectedTeamMember["photo"],
                                                        width: 80,
                                                        height: 80,
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
                                                          return Image.asset("assets/images/profile.png", width: 100, height: 100,);
                                                        },
                                                      ) : Image.asset("assets/images/profile.png", width: 80, height: 80,),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                            text: "${selectedTeamMember["first_name"]} ",
                                                            style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18,
                                                            ),
                                                            children: [
                                                              TextSpan(
                                                                text: selectedTeamMember["last_name"],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(height: 3,),
                                                        Text(
                                                          selectedTeamMember["phone"],
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        Text(
                                                          selectedTeamMember["email"],
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else const Expanded(
                                          child: Text(
                                            "select assignee",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                  if(selectedTeamMember != null){
                                    showProgress = true;
                                    setState(() {});
                                    Navigator.pop(context);
                                    var response = await ServiceApis().assignTask(
                                      developerId: selectedTeamMember["id"],
                                      taskId: taskList[taskIndex]["id"],
                                      note: assignTaskDescriptionController.text,
                                    );
                                    if(response.statusCode == 201){
                                      await getTaskList();
                                      Widgets().showAlertDialog(alertMessage: "Task assigned successfuly.", context: context);
                                    }else{
                                      showProgress = false;
                                      setState(() {});
                                      Widgets().showAlertDialog(alertMessage: "Something went wrong.", context: context);
                                    }
                                  }else{
                                    Widgets().showAlertDialog(alertMessage: "Developer must be selected to assign task.", context: context);
                                  }
                                },
                                text: "Assign task",
                                fontSize: 22,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                );
              }
          ),
        ),
      );
    },
    );
  }

}
