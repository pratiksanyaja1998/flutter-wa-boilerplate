
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.onSelected,
    this.managerId,
    this.onSelectProjectUpdateStatus,
    this.controller,
    this.animation,
    this.onExpand,
  }) : super(key: key);

  final dynamic task;
  final void Function(String)? onSelected;
  final void Function(String)? onSelectProjectUpdateStatus;
  final void Function()? onTap;
  final int? managerId;
  final AnimationController? controller;
  final Animation<double>? animation;
  final void Function()? onExpand;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  String taskStatus = "";
  Color taskStatusColor = Colors.white;
  List<dynamic> projectTeam = [];

  bool isExpanded = false;

  bool showAllDescription = false;

  @override
  void initState() {
    taskStatus = widget.task["status"];
    taskStatusColor = taskStatus == "active" ?
    Colors.green : taskStatus == "in-progress" ?
    Colors.amber : taskStatus == "completed" ? Colors.blue : Colors.white;
    projectTeam = widget.task["assigned_task"];
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 600),
      margin: const EdgeInsets.only(left: 31, right: 25, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: taskStatusColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: taskStatusColor,
            offset: const Offset(-5, 0),
          ),
          BoxShadow(
            color: taskStatusColor.withOpacity(0.3),
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
          onTap: widget.onTap ?? (){
            showAllDescription = !showAllDescription;
            setState(() {});
          },
          contentPadding: const EdgeInsets.only(left:16, right: 16, top: 5, bottom: 5),
          splashColor: taskStatusColor.withOpacity(0.1),
          hoverColor: taskStatusColor.withOpacity(0.1),
          title: Row(
            children: [
              // Container(
              //   width: 6,
              //   height: 150,
              //   decoration: BoxDecoration(
              //     color: taskStatusColor,
              //     borderRadius: const BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
              //   ),
              // ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        if(widget.task["name"].isNotEmpty)
                          Expanded(
                            child: Text(
                              widget.task["name"],
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: taskStatusColor,
                              ),
                            ),
                          ),
                        if(SharedPreference.isLogin() && widget.onSelected != null)
                          if(SharedPreference.getUser()!.type == "merchant" || SharedPreference.getUser()!.id == widget.managerId)
                            PopupMenuButton<String>(
                                surfaceTintColor: taskStatus == "active" ?
                                Colors.green[200] : taskStatus == "in-progress" ?
                                Colors.amber[200] : taskStatus == "completed" ? Colors.blue[200] : Colors.white,
                                shadowColor: taskStatusColor,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: taskStatusColor,
                                  ),
                                ),
                                onSelected: widget.onSelected,
                                splashRadius: 1,
                                tooltip: "Options",
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (BuildContext context) {
                                  return ["Assign", "Update", "Update status", "Delete"].map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: choice == "Update status" ?
                                      PopupMenuButton(
                                        surfaceTintColor: taskStatus == "active" ?
                                        Colors.green[200] : taskStatus == "in-progress" ?
                                        Colors.amber[200] : taskStatus == "completed" ? Colors.blue[200] : Colors.white,
                                        shadowColor: taskStatusColor,
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: taskStatusColor,
                                          ),
                                        ),
                                        itemBuilder: (BuildContext context){
                                          return ["active", "in-progress", "completed"].map((String status) {
                                            return PopupMenuItem<String>(
                                              value: status,
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                  color: taskStatusColor,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            );
                                          }).toList();
                                        },
                                        splashRadius: 1,
                                        onSelected: widget.onSelectProjectUpdateStatus,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                child: Text(
                                                  "Update status",
                                                  style: TextStyle(
                                                    color: taskStatusColor,
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
                                          color: taskStatusColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                child: Icon(
                                  Icons.more_horiz,
                                  color: taskStatusColor,
                                  size: 30,
                                )),
                      ],
                    ),
                    const SizedBox(height: 3,),
                    AnimatedContainer(
                      constraints: BoxConstraints(
                        maxHeight: widget.onSelected != null ? 48 : showAllDescription ? 100 : 48,
                      ),
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 600),
                      child: SingleChildScrollView(
                        physics: showAllDescription ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
                        child: Text(
                          widget.task["description"],
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3,),
                    Text(
                      DateFormat("dd MM yyyy hh:mm a").format(DateTime.parse(widget.task["created_at"])),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    // const SizedBox(height: 5,),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if(widget.task.containsKey("assigned_task"))
                                Row(
                                  children: [
                                    Expanded(
                                      child: widget.task["assigned_task"].isEmpty ? const Text(
                                        "Not assigned to anyone.",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ) : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: 36,
                                              width: (widget.task["assigned_task"].length * 20)+ 16.0,
                                            ),
                                            for(int j = 0; j < (widget.task["assigned_task"].length > 4 ? 5 : widget.task["assigned_task"].length); j++)
                                              if(j > 3)
                                                Positioned(
                                                  left: j * 23 + 3,
                                                  top: 3,
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      // border: Border.all(color: Colors.grey),
                                                      color: Colors.indigo,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.4),
                                                          blurRadius: 3,
                                                        )
                                                      ],
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "${widget.task["assigned_task"].length - 4}+",
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
                                                  left: j * 20 + 3,
                                                  top: 3,
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
                                                          color: Colors.black.withOpacity(0.4),
                                                          blurRadius: 3,
                                                        )
                                                      ],
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: widget.task["assigned_task"][j]["developer"]["photo"] == null ? Widgets().noProfileContainer(
                                                        name: widget.task["assigned_task"][j]["developer"]["first_name"][0]+
                                                            widget.task["assigned_task"][j]["developer"]["last_name"][0],
                                                      ) : widget.task["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                                                      Image.network(
                                                        widget.task["assigned_task"][j]["developer"]["photo"],
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
                                                            name: widget.task["assigned_task"][j]["developer"]["first_name"][0]+
                                                                widget.task["assigned_task"][j]["developer"]["last_name"][0],
                                                          );
                                                        },
                                                      ) : Widgets().noProfileContainer(
                                                        name: widget.task["assigned_task"][j]["developer"]["first_name"][0]+
                                                            widget.task["assigned_task"][j]["developer"]["last_name"][0],
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
                        const SizedBox(width: 10,),
                        Text(
                          taskStatus == "active" ?
                          "Active" : taskStatus == "in-progress" ?
                          "In-progress" : taskStatus == "completed" ? "Completed" : "",
                          style: TextStyle(
                            fontSize: 18,
                            height: 1,
                            fontWeight: FontWeight.bold,
                            color: taskStatusColor,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        if(widget.animation != null)
                          GestureDetector(
                            onTap: (){
                              if(widget.controller!.isCompleted){
                                widget.controller!.reverse();
                              }else {
                                widget.controller!.forward();
                              }
                              isExpanded = !isExpanded;
                              setState(() {});
                            },
                            child: RotationTransition(
                              turns: widget.animation!,
                              child: Icon(
                                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down_rounded,
                                color: taskStatusColor,
                                size: 30,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if(widget.onSelected == null)
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
                                  const SizedBox(height: 5,),
                                  for(int j = 0; j < widget.task["assigned_task"].length; j++)
                                    Container(
                                      margin: const EdgeInsets.only(top: 8,),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: taskStatusColor.withOpacity(0.6),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: taskStatusColor.withOpacity(0.3),
                                        //     blurRadius: 4,
                                        //   ),
                                        // ],
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
                                          splashColor: taskStatusColor.withOpacity(0.1),
                                          hoverColor: taskStatusColor.withOpacity(0.1),
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
                                                  child: widget.task["assigned_task"][j]["developer"]["photo"] == null ? Widgets().noProfileContainer(
                                                    name: widget.task["assigned_task"][j]["developer"]["first_name"][0]+
                                                        widget.task["assigned_task"][j]["developer"]["last_name"][0],
                                                  ) : widget.task["assigned_task"][j]["developer"]["photo"].isNotEmpty ?
                                                  Image.network(
                                                    widget.task["assigned_task"][j]["developer"]["photo"],
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
                                                        name: widget.task["assigned_task"][j]["developer"]["first_name"][0]+
                                                            widget.task["assigned_task"][j]["developer"]["last_name"][0],
                                                      );
                                                    },
                                                  ) : Widgets().noProfileContainer(
                                                    name: widget.task["assigned_task"][j]["developer"]["first_name"][0]+
                                                        widget.task["assigned_task"][j]["developer"]["last_name"][0],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5,),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${widget.task["assigned_task"][j]["developer"]["first_name"]} ${widget.task["assigned_task"][j]["developer"]["last_name"]}",
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      widget.task["assigned_task"][j]["developer"]["email"],
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
                    const SizedBox(height: 2,),
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
                                "${(double.parse(widget.task["total_time_hr"].toString())).abs().floor()} h ${((double.parse(widget.task["total_time_hr"].toString())*60.0)%60.0).abs().round()} m",
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
                                "${(double.parse(widget.task["estimate_time"].toString())).abs().floor()} h ${((double.parse(widget.task["estimate_time"].toString())*60.0)%60.0).abs().round()} m",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(0),
                              padding: const EdgeInsets.all(5),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: CustomPaint(
                                painter: ProgressGraph(
                                    buttonBorderColor: taskStatusColor.withOpacity(0.3),
                                    progressColor: taskStatusColor,
                                    percentage: double.parse(widget.task["estimate_time"].toString()) == 0.0 ? 100 :
                                    double.parse((double.parse(widget.task["total_time_hr"].toString())/
                                        double.parse(widget.task["estimate_time"].toString()) * 100
                                    ).toString()),
                                    width: 2,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              left: 0,
                              bottom: 0,
                              child: Center(
                                child: Text(
                                  "${double.parse(widget.task["estimate_time"].toString()) == 0.0 ? 100 : double.parse((double.parse(widget.task["total_time_hr"].toString())/
                                      double.parse(widget.task["estimate_time"].
                                      toString())
                                      * 100).toString()).round()
                                  } %",
                                ),
                              ),
                            ),
                            // Positioned(
                            //   left: 2,
                            //   top: 2,
                            //   right: 2,
                            //   bottom: 2,
                            //   child: CircularProgressIndicator(
                            //     value: double.parse(widget.task["total_time_hr"].toString())/double.parse(widget.task["estimate_time"].toString()),
                            //     color: taskStatusColor,
                            //     backgroundColor: taskStatusColor.withOpacity(0.4),
                            //     semanticsLabel: "Completed time out of estimated time",
                            //     semanticsValue: "${double.parse(widget.task["total_time_hr"].toString())/double.parse(widget.task["estimate_time"].toString())}",
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          tileColor: taskStatusColor.withOpacity(0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          dense: true,
        ),
      ),
    );
  }


}

class ProgressGraph extends CustomPainter{
  Color buttonBorderColor;
  Color progressColor;
  double percentage;
  double width;

  ProgressGraph({required this.buttonBorderColor,required this.progressColor,required this.percentage,required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    Paint progress = Paint()
      ..color = progressColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = width;
    Paint background =  Paint()
      ..color = buttonBorderColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = width;
    Paint border =  Paint()
      ..color = progressColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center  = Offset(size.width/2, size.height/2);
    double radius  = min(size.width/2,size.height/2);
    canvas.drawCircle(
      center,
      radius,
      background,
    );
    canvas.drawCircle(center, radius, border);
    double arcAngle = 2*pi* (percentage/100);
    canvas.drawArc(
        Rect.fromCircle(center: center,radius: radius),
        -pi/2,
        arcAngle,
        true,
        progress
    );
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
