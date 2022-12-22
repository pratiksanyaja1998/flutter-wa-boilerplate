
import 'package:flutter/material.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({Key? key, required this.taskData, required this.projectData}) : super(key: key);

  final dynamic taskData;
  final dynamic projectData;

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {

  bool showProgress = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Task detail",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        shadowColor: Colors.black,
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
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  splashColor: widget.taskData["status"] == "active" ?
                  Colors.green.withOpacity(0.1) : widget.taskData["status"] == "in-progress" ?
                  Colors.amber.withOpacity(0.1) : widget.taskData["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                  hoverColor: widget.taskData["status"] == "active" ?
                  Colors.green.withOpacity(0.1) : widget.taskData["status"] == "in-progress" ?
                  Colors.amber.withOpacity(0.1) : widget.taskData["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.taskData["status"][0].toUpperCase()}${widget.taskData["status"].substring(1).toLowerCase()}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.projectData["status"] == "active" ?
                          Colors.green : widget.projectData["status"] == "in-progress" ?
                          Colors.amber : widget.projectData["status"] == "completed" ? Colors.blue : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      if(widget.taskData["name"].isNotEmpty)
                        Text(
                          widget.taskData["name"],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      const SizedBox(height: 5,),
                      Text(
                        widget.projectData["description"],
                        maxLines: isExpanded ? null : 2,
                        overflow: TextOverflow.ellipsis,
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
                                  "Assigned task developers",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6,),
                                if(widget.taskData["assigned_task"].isNotEmpty)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: (widget.taskData["assigned_task"].length * 26)+ 14.0,
                                              ),
                                              for(int j = 0; j < (widget.taskData["assigned_task"].length > 4 ? 5 : widget.taskData["assigned_task"].length); j++)
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
                                                          "${widget.taskData["assigned_task"].length - 4}+",
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
                                                        child: widget.taskData["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                                                        Image.network(
                                                          widget.taskData["assigned_task"][j]["developer"]["photo"],
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
                                                              name: widget.taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                                  widget.taskData["assigned_task"][j]["developer"]["last_name"][0],
                                                            );
                                                          },
                                                        ) : Widgets().noProfileContainer(
                                                          name: widget.taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                              widget.taskData["assigned_task"][j]["developer"]["last_name"][0],
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
                                const SizedBox(height: 2,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if(widget.taskData["assigned_task"].isNotEmpty)
                        if(isExpanded)
                          Column(
                            children: [
                              const SizedBox(height: 10,),
                              for(int j = 0; j < widget.taskData["assigned_task"].length; j++)
                                Container(
                                  margin: const EdgeInsets.only(top: 8,),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: widget.taskData["status"] == "active" ?
                                      Colors.green.withOpacity(0.6) : widget.taskData["status"] == "in-progress" ?
                                      Colors.amber.withOpacity(0.6) : widget.taskData["status"] == "completed" ? Colors.blue.withOpacity(0.6) : Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
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
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      splashColor: widget.taskData["status"] == "active" ?
                                      Colors.green.withOpacity(0.1) : widget.taskData["status"] == "in-progress" ?
                                      Colors.amber.withOpacity(0.1) : widget.taskData["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
                                      hoverColor: widget.taskData["status"] == "active" ?
                                      Colors.green.withOpacity(0.1) : widget.taskData["status"] == "in-progress" ?
                                      Colors.amber.withOpacity(0.1) : widget.taskData["status"] == "completed" ? Colors.blue.withOpacity(0.1) : null,
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
                                              child: widget.taskData["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                                              Image.network(
                                                widget.taskData["assigned_task"][j]["developer"]["photo"],
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
                                                    name: widget.taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                        widget.taskData["assigned_task"][j]["developer"]["last_name"][0],
                                                  );
                                                },
                                              ) : Widgets().noProfileContainer(
                                                name: widget.taskData["assigned_task"][j]["developer"]["first_name"][0]+
                                                    widget.taskData["assigned_task"][j]["developer"]["last_name"][0],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 5,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${widget.taskData["assigned_task"][j]["developer"]["first_name"]} ${widget.taskData["assigned_task"][j]["developer"]["last_name"]}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  widget.taskData["assigned_task"][j]["developer"]["email"],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      tileColor: widget.taskData["status"] == "active" ?
                                      Colors.green.withOpacity(0.6) : widget.taskData["status"] == "in-progress" ?
                                      Colors.amber.withOpacity(0.6) : widget.taskData["status"] == "completed" ? Colors.blue.withOpacity(0.6) : Colors.white,
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
                  tileColor: Colors.white,
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
    );
  }
}
