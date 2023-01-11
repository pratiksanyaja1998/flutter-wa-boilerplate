
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whitelabelapp/config.dart';

class AssignTaskCard extends StatefulWidget {
  const AssignTaskCard({Key? key, required this.assignTaskData, this.onTap}) : super(key: key);

  final dynamic assignTaskData;
  final void Function()? onTap;

  @override
  State<AssignTaskCard> createState() => _AssignTaskCardState();
}

class _AssignTaskCardState extends State<AssignTaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, bottom: 15,),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: kThemeColor,
        ),
        boxShadow: [
          BoxShadow(
            color: kThemeColor.withOpacity(0.3),
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
          onTap: widget.onTap,
          contentPadding: const EdgeInsets.only(left: 0, right: 16, top: 10, bottom: 10),
          splashColor: kThemeColor.withOpacity(0.1),
          hoverColor: kThemeColor.withOpacity(0.1),
          title: Row(
            children: [
              Container(
                width: 7,
                height: 100,
                decoration: const BoxDecoration(
                  color: kThemeColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(widget.assignTaskData["note"].isNotEmpty)
                      Text(
                        widget.assignTaskData["note"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          // fontWeight: FontWeight.w400,
                        ),
                      ),
                    Text(
                      DateFormat("dd MM yyyy hh:mm a").format(DateTime.parse(widget.assignTaskData["created_at"])),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        height: 2,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Image.asset("assets/images/working_hours_person.png"),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                "${(double.parse(widget.assignTaskData["total_time_hr"].toString())).abs().floor()} hour ${((double.parse(widget.assignTaskData["total_time_hr"].toString())*60.0)%60.0).abs().round()} min",
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
          tileColor: kThemeColor.withOpacity(0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          dense: true,
        ),
      ),
    );
  }
}
