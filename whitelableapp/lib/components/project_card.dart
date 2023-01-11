
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/config.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({Key? key, required this.project, this.onSelected, this.onTap}) : super(key: key);

  final dynamic project;
  final void Function(String)? onSelected;
  final void Function()? onTap;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {

  String projectStatus = "";
  Color projectStatusColor = Colors.white;
  List<dynamic> projectTeam = [];

  bool isExpanded = false;

  @override
  void initState() {
    projectStatus = widget.project["status"];
    projectStatusColor = projectStatus == "active" ?
    Colors.green : projectStatus == "in-progress" ?
    Colors.amber : projectStatus == "completed" ? Colors.blue : Colors.white;
    projectTeam = widget.project["team"];
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 600),
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 25,),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: projectStatusColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: projectStatusColor.withOpacity(0.3),
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
            isExpanded = !isExpanded;
            setState(() {});
          },
          minVerticalPadding: 0,
          contentPadding: const EdgeInsets.only(left:16, right: 16, top: 0, bottom: 10),
          splashColor: projectStatusColor.withOpacity(0.1),
          hoverColor: projectStatusColor.withOpacity(0.1),
          title: Column(
            children: [
              Container(
                width: 160,
                height: 8,
                decoration: BoxDecoration(
                  color: projectStatusColor,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
              ),
              const SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if(widget.project["name"].isNotEmpty)
                        Expanded(
                          child: Text(
                            widget.project["name"],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: projectStatusColor,
                            ),
                          ),
                        ),
                      if(SharedPreference.isLogin())
                        if(SharedPreference.getUser()!.type == "merchant" && widget.onSelected != null)
                          PopupMenuButton<String>(
                              surfaceTintColor: projectStatus == "active" ?
                              Colors.green[200] : projectStatus == "in-progress" ?
                              Colors.amber[200] : projectStatus == "completed" ? Colors.blue[200] : Colors.white,
                              shadowColor: projectStatusColor,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: projectStatusColor,
                                ),
                              ),
                              onSelected: widget.onSelected,
                              icon: Icon(
                                Icons.more_horiz,
                                color: projectStatusColor,
                                size: 30,
                              ),
                              splashRadius: 1,
                              tooltip: "Options",
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (BuildContext context) {
                                return ["Update", "Delete"].map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(
                                      choice,
                                      style: TextStyle(
                                        color: projectStatusColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                }).toList();
                              }),
                    ],
                  ),
                  if(widget.project["description"].isNotEmpty)
                    Text(
                      widget.project["description"],
                      maxLines: widget.onSelected != null ? 2 : null,
                      overflow: widget.onSelected != null ? TextOverflow.ellipsis : null,
                      style: const TextStyle(
                        fontSize: 18,
                        // fontWeight: FontWeight.w400,
                      ),
                    ),
                  const SizedBox(height: 10,),
                  const Text(
                    "Manager",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                          color: kPrimaryColor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: widget.project["manager"]["photo"] == null ? Widgets().noProfileContainer(
                            name: widget.project["manager"]["first_name"][0]+
                                widget.project["manager"]["last_name"][0],
                          ) : widget.project["manager"]["photo"].isNotEmpty ?
                          Image.network(
                            widget.project["manager"]["photo"],
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
                                name: widget.project["manager"]["first_name"][0]+
                                    widget.project["manager"]["last_name"][0],
                              );
                            },
                          ) : Widgets().noProfileContainer(
                            name: widget.project["manager"]["first_name"][0]+
                                widget.project["manager"]["last_name"][0],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.project["manager"]["first_name"]} ${widget.project["manager"]["last_name"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${widget.project["manager"]["email"]}",
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(widget.project["created_at"])),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 68,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Team",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              if(projectTeam.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: (projectTeam.length * 27)+ 8.0,
                                              ),
                                              for(int j = 0; j < projectTeam.length; j++)
                                                Positioned(
                                                  left: j * 27,
                                                  child: Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      border: Border.all(color: Colors.grey),
                                                      color: kPrimaryColor,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: projectTeam[j]["photo"] == null ? Widgets().noProfileContainer(
                                                        name: projectTeam[j]["first_name"][0]+
                                                            projectTeam[j]["last_name"][0],
                                                      ) : projectTeam[j]["photo"].isNotEmpty ?
                                                      Image.network(
                                                        projectTeam[j]["photo"],
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
                                                            name: projectTeam[j]["first_name"][0]+
                                                                projectTeam[j]["last_name"][0],
                                                          );
                                                        },
                                                      ) : Widgets().noProfileContainer(
                                                        name: projectTeam[j]["first_name"][0]+
                                                            projectTeam[j]["last_name"][0],
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
                                )
                              else
                                const Text("No team added."),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 68,
                        child: Column(
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
                              widget.project["status"] == "active" ?
                              "Active" : widget.project["status"] == "in-progress" ?
                              "In-progress" : widget.project["status"] == "completed" ? "Completed" : "",
                              style: TextStyle(
                                fontSize: 20,
                                height: 1,
                                fontWeight: FontWeight.bold,
                                color: projectStatusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if(widget.onTap == null)
                    AnimatedContainer(
                    constraints: BoxConstraints(
                      maxHeight: isExpanded ? 320 : 0,
                    ),
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 800),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if(projectTeam.isNotEmpty)
                            const SizedBox(height: 15,),
                          for(int j = 0; j < projectTeam.length; j++)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8,),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: projectStatusColor.withOpacity(0.05),
                                border: Border.all(
                                  color: projectStatusColor.withOpacity(0.7),
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
                                      child: projectTeam[j]["photo"] == null ? Widgets().noProfileContainer(
                                        name: projectTeam[j]["first_name"][0]+
                                            projectTeam[j]["last_name"][0],
                                      ) : projectTeam[j]["photo"].isNotEmpty ?
                                      Image.network(
                                        projectTeam[j]["photo"],
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
                                            name: projectTeam[j]["first_name"][0]+
                                                projectTeam[j]["last_name"][0],
                                          );
                                        },
                                      ) : Widgets().noProfileContainer(
                                        name: projectTeam[j]["first_name"][0]+
                                            projectTeam[j]["last_name"][0],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${projectTeam[j]["first_name"]} ${projectTeam[j]["last_name"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                        Text(
                                          projectTeam[j]["email"],
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
                              "${(double.parse(widget.project["total_time_hr"].toString())).abs().floor()} hour ${((double.parse(widget.project["total_time_hr"].toString())*60.0)%60.0).abs().round()} min",
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
                              "${(double.parse(widget.project["estimate_time"].toString())).abs().floor()} hour ${((double.parse(widget.project["estimate_time"].toString())*60.0)%60.0).abs().round()} min",
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
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 5),
                    height: 6,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: double.parse(widget.project["estimate_time"].toString()) == 0.0 ? 1 : double.parse(widget.project["total_time_hr"].toString())/double.parse(widget.project["estimate_time"].toString()),
                        minHeight: 6,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          projectStatusColor,
                        ),
                        backgroundColor: projectStatusColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Completed",
                      ),
                      Text(
                        "${double.parse(widget.project["estimate_time"].toString()) == 0.0 ? 100 : double.parse((double.parse(widget.project["total_time_hr"].toString())/
                            double.parse(widget.project["estimate_time"].
                            toString())
                            * 100).toString()).round()
                        } %",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          tileColor: projectStatusColor.withOpacity(0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          dense: true,
        ),
      ),
    );
  }
}
