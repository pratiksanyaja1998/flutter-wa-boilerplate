
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';

class AssignTaskModal{
  void assignUserModal({
    var selectedDeveloper,
    required BuildContext context,
    required TextEditingController assignTaskDescriptionController,
    required List<dynamic> assignedTaskList,
    required List<dynamic> projectTeam,
    required void Function(dynamic selectedDeveloper)? onAssign,
    void Function()? onDelete,
    bool isEdit = false,
  }){
    var selectedTeamMember = selectedDeveloper;
    CommonFunctions().showBottomSheet(
      context: context,
      child: Container(
        margin: const EdgeInsets.all(15),
        constraints: const BoxConstraints(
          maxHeight: 390,
          maxWidth: 400,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kPrimaryColor,
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
                                    if(isEdit){
                                      if(selectedDeveloper["id"] == projectTeam[int.parse(newValue)]["id"]){
                                        selectedTeamMember = projectTeam[int.parse(newValue)];
                                        state(() {});
                                      }else if(!assignedTaskList.map((element) => element["developer"]["id"]).toList().contains(projectTeam[int.parse(newValue)]["id"])) {
                                        selectedTeamMember = projectTeam[int.parse(newValue)];
                                        state(() {});
                                      }else{
                                        CommonFunctions().showAlertDialog(alertMessage: "This task already assigned to this developer.", context: context);
                                      }
                                    }else{
                                      if(!assignedTaskList.map((element) => element["developer"]["id"]).toList().contains(projectTeam[int.parse(newValue)]["id"])) {
                                        selectedTeamMember = projectTeam[int.parse(newValue)];
                                        state(() {});
                                      }else{
                                        CommonFunctions().showAlertDialog(alertMessage: "This task already assigned to this developer.", context: context);
                                      }
                                    }

                                  },
                                  splashRadius: 1,
                                  tooltip: "select developer",
                                  itemBuilder: (BuildContext context) {
                                    List<PopupMenuEntry<String>> l = [];
                                    for(int i = 0; i < projectTeam.length; i++){
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
                                                  child: projectTeam[i]["photo"] == null ? Image.asset("assets/images/profile.png", width: 80, height: 80,) : projectTeam[i]["photo"].isNotEmpty ? Image.network(
                                                    projectTeam[i]["photo"],
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
                                                    Text(
                                                      projectTeam[i]["type"],
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: "${projectTeam[i]["first_name"]} ",
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: projectTeam[i]["last_name"],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      projectTeam[i]["email"],
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
                                                    child: selectedTeamMember["photo"] == null ? Image.asset("assets/images/profile.png", width: 80, height: 80,) : selectedTeamMember["photo"].isNotEmpty ? Image.network(
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
                    if(isEdit)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        constraints: const BoxConstraints(
                          maxWidth: 450,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Widgets().textButton(
                                onPressed: onDelete,
                                text: "Delete",
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Widgets().textButton(
                                onPressed: (){
                                  onAssign!(selectedTeamMember);
                                },
                                text: "Save",
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Widgets().textButton(
                                onPressed: () async{
                                  onAssign!(selectedTeamMember);
                                },
                                text: "Assign task",
                                fontSize: 22,
                                // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ]
              );
            }
        ),
      ),
    );
    // showModalBottomSheet(
    //   isScrollControlled: true,
    //   context: context, builder: (_) {
    //   return Padding(
    //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    //     child: Container(
    //       constraints: const BoxConstraints(
    //         maxHeight: 400,
    //       ),
    //       child: StatefulBuilder(
    //           builder: (_, state) {
    //             return Column(
    //                 children: [
    //                   const SizedBox(height: 20,),
    //                   const Text(
    //                     "Assign Task",
    //                     style: TextStyle(
    //                       fontSize: 18,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                   const SizedBox(height: 20,),
    //                   Expanded(
    //                     child: SingleChildScrollView(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //                             child: Widgets().textFormField(
    //                               maxLines: 3,
    //                               controller: assignTaskDescriptionController,
    //                               labelText: "Enter project description",
    //                             ),
    //                           ),
    //                           const Padding(
    //                             padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 15),
    //                             child: Text(
    //                               "Assigned developer",
    //                               style: TextStyle(
    //                                 fontSize: 16,
    //                                 fontWeight: FontWeight.bold,
    //                               ),
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //                             child: Container(
    //                               padding: EdgeInsets.all(selectedTeamMember != null ? 0 : 15),
    //                               decoration: BoxDecoration(
    //                                   color: Colors.white,
    //                                   borderRadius: BorderRadius.circular(10),
    //                                   boxShadow: [
    //                                     BoxShadow(
    //                                       color: Colors.black.withOpacity(0.4),
    //                                       blurRadius: 6,
    //                                     ),
    //                                   ]
    //                               ),
    //                               child: PopupMenuButton<String>(
    //                                 // padding: EdgeInsets.only(right: 50),
    //                                 constraints: const BoxConstraints(
    //                                   maxHeight: 350,
    //                                 ),
    //                                 onSelected: (newValue){
    //                                   if(isEdit){
    //                                     if(selectedDeveloper["id"] == projectTeam[int.parse(newValue)]["id"]){
    //                                       selectedTeamMember = projectTeam[int.parse(newValue)];
    //                                       state(() {});
    //                                     }else if(!assignedTaskList.map((element) => element["developer"]["id"]).toList().contains(projectTeam[int.parse(newValue)]["id"])) {
    //                                       selectedTeamMember = projectTeam[int.parse(newValue)];
    //                                       state(() {});
    //                                     }else{
    //                                       Widgets().showAlertDialog(alertMessage: "This task already assigned to this developer.", context: context);
    //                                     }
    //                                   }else{
    //                                     if(!assignedTaskList.map((element) => element["developer"]["id"]).toList().contains(projectTeam[int.parse(newValue)]["id"])) {
    //                                       selectedTeamMember = projectTeam[int.parse(newValue)];
    //                                       state(() {});
    //                                     }else{
    //                                       Widgets().showAlertDialog(alertMessage: "This task already assigned to this developer.", context: context);
    //                                     }
    //                                   }
    //
    //                                 },
    //                                 splashRadius: 1,
    //                                 tooltip: "select developer",
    //                                 itemBuilder: (BuildContext context) {
    //                                   List<PopupMenuEntry<String>> l = [];
    //                                   for(int i = 0; i < projectTeam.length; i++){
    //                                     l.add(PopupMenuItem<String>(
    //                                       value: i.toString(),
    //                                       child: Container(
    //                                         margin: const EdgeInsets.symmetric(vertical: 5),
    //                                         padding: const EdgeInsets.all(10),
    //                                         decoration: BoxDecoration(
    //                                           borderRadius: BorderRadius.circular(10),
    //                                           border: Border.all(color: Colors.black,),
    //                                         ),
    //                                         child: Row(
    //                                           children: [
    //                                             Container(
    //                                               width: 55,
    //                                               height: 55,
    //                                               decoration: BoxDecoration(
    //                                                 borderRadius: BorderRadius.circular(40),
    //                                                 border: Border.all(color: Colors.grey),
    //                                                 color: kPrimaryColor,
    //                                               ),
    //                                               child: ClipRRect(
    //                                                 borderRadius: BorderRadius.circular(40),
    //                                                 child: projectTeam[i]["photo"].isNotEmpty ? Image.network(
    //                                                   projectTeam[i]["photo"],
    //                                                   width: 80,
    //                                                   height: 80,
    //                                                   fit: BoxFit.cover,
    //                                                   loadingBuilder: (context, child, loadingProgress){
    //                                                     if(loadingProgress != null){
    //                                                       return const Center(
    //                                                         child: CircularProgressIndicator(
    //                                                           color: kThemeColor,
    //                                                           strokeWidth: 3,
    //                                                         ),
    //                                                       );
    //                                                     }else{
    //                                                       return child;
    //                                                     }
    //                                                   },
    //                                                   errorBuilder: (context, obj, st){
    //                                                     return Image.asset("assets/images/profile.png", width: 100, height: 100,);
    //                                                   },
    //                                                 ) : Image.asset("assets/images/profile.png", width: 80, height: 80,),
    //                                               ),
    //                                             ),
    //                                             const SizedBox(width: 10,),
    //                                             Expanded(
    //                                               child: Column(
    //                                                 crossAxisAlignment: CrossAxisAlignment.start,
    //                                                 children: [
    //                                                   Text(
    //                                                     projectTeam[i]["type"],
    //                                                     style: const TextStyle(
    //                                                       color: Colors.black,
    //                                                       fontSize: 14,
    //                                                     ),
    //                                                   ),
    //                                                   RichText(
    //                                                     text: TextSpan(
    //                                                       text: "${projectTeam[i]["first_name"]} ",
    //                                                       style: const TextStyle(
    //                                                         color: Colors.black,
    //                                                         fontWeight: FontWeight.bold,
    //                                                         fontSize: 18,
    //                                                       ),
    //                                                       children: [
    //                                                         TextSpan(
    //                                                           text: projectTeam[i]["last_name"],
    //                                                         ),
    //                                                       ],
    //                                                     ),
    //                                                   ),
    //                                                   Text(
    //                                                     projectTeam[i]["email"],
    //                                                     maxLines: 1,
    //                                                     overflow: TextOverflow.ellipsis,
    //                                                     style: const TextStyle(
    //                                                       color: Colors.black,
    //                                                       fontSize: 14,
    //                                                     ),
    //                                                   ),
    //                                                 ],
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     ));
    //                                   }
    //                                   return l;
    //                                 },
    //                                 child: Row(
    //                                   mainAxisSize: MainAxisSize.min,
    //                                   children: <Widget>[
    //                                     if(selectedTeamMember != null)
    //                                       Expanded(
    //                                         child: Container(
    //                                           padding: const EdgeInsets.all(10),
    //                                           decoration: BoxDecoration(
    //                                             borderRadius: BorderRadius.circular(10),
    //                                             border: Border.all(color: Colors.black,),
    //                                           ),
    //                                           child: Row(
    //                                             children: [
    //                                               Container(
    //                                                 width: 55,
    //                                                 height: 55,
    //                                                 decoration: BoxDecoration(
    //                                                   borderRadius: BorderRadius.circular(40),
    //                                                   border: Border.all(color: Colors.grey),
    //                                                   color: kPrimaryColor,
    //                                                 ),
    //                                                 child: ClipRRect(
    //                                                   borderRadius: BorderRadius.circular(40),
    //                                                   child: selectedTeamMember["photo"].isNotEmpty ? Image.network(
    //                                                     selectedTeamMember["photo"],
    //                                                     width: 80,
    //                                                     height: 80,
    //                                                     fit: BoxFit.cover,
    //                                                     loadingBuilder: (context, child, loadingProgress){
    //                                                       if(loadingProgress != null){
    //                                                         return const Center(
    //                                                           child: CircularProgressIndicator(
    //                                                             color: kThemeColor,
    //                                                             strokeWidth: 3,
    //                                                           ),
    //                                                         );
    //                                                       }else{
    //                                                         return child;
    //                                                       }
    //                                                     },
    //                                                     errorBuilder: (context, obj, st){
    //                                                       return Image.asset("assets/images/profile.png", width: 100, height: 100,);
    //                                                     },
    //                                                   ) : Image.asset("assets/images/profile.png", width: 80, height: 80,),
    //                                                 ),
    //                                               ),
    //                                               const SizedBox(width: 10,),
    //                                               Expanded(
    //                                                 child: Column(
    //                                                   crossAxisAlignment: CrossAxisAlignment.start,
    //                                                   children: [
    //                                                     RichText(
    //                                                       text: TextSpan(
    //                                                         text: "${selectedTeamMember["first_name"]} ",
    //                                                         style: const TextStyle(
    //                                                           color: Colors.black,
    //                                                           fontWeight: FontWeight.bold,
    //                                                           fontSize: 18,
    //                                                         ),
    //                                                         children: [
    //                                                           TextSpan(
    //                                                             text: selectedTeamMember["last_name"],
    //                                                           ),
    //                                                         ],
    //                                                       ),
    //                                                     ),
    //                                                     const SizedBox(height: 3,),
    //                                                     Text(
    //                                                       selectedTeamMember["phone"],
    //                                                       style: const TextStyle(
    //                                                         color: Colors.black,
    //                                                         fontSize: 14,
    //                                                       ),
    //                                                     ),
    //                                                     Text(
    //                                                       selectedTeamMember["email"],
    //                                                       maxLines: 1,
    //                                                       overflow: TextOverflow.ellipsis,
    //                                                       style: const TextStyle(
    //                                                         color: Colors.black,
    //                                                         fontSize: 14,
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ),
    //                                       )
    //                                     else const Expanded(
    //                                       child: Text(
    //                                         "select assignee",
    //                                         overflow: TextOverflow.ellipsis,
    //                                         style: TextStyle(
    //                                           fontSize: 16,
    //                                           color: Colors.grey,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   if(isEdit)
    //                     Container(
    //                       margin: const EdgeInsets.all(20),
    //                       constraints: const BoxConstraints(
    //                         maxWidth: 450,
    //                       ),
    //                       child: Row(
    //                         children: [
    //                           Expanded(
    //                             child: Widgets().textButton(
    //                               onPressed: onDelete,
    //                               text: "Delete",
    //                               fontSize: 22,
    //                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    //                             ),
    //                           ),
    //                           const SizedBox(width: 10,),
    //                           Expanded(
    //                             child: Widgets().textButton(
    //                               onPressed: (){
    //                                 onAssign!(selectedTeamMember);
    //                               },
    //                               text: "Save",
    //                               fontSize: 22,
    //                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     )
    //                   else
    //                     Padding(
    //                       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
    //                       child: Row(
    //                         children: [
    //                           Expanded(
    //                             child: Widgets().textButton(
    //                               onPressed: () async{
    //                                 onAssign!(selectedTeamMember);
    //                               },
    //                               text: "Assign task",
    //                               fontSize: 22,
    //                               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     )
    //                 ]
    //             );
    //           }
    //       ),
    //     ),
    //   );
    // },
    // );
  }
}