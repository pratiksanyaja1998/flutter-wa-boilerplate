
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whitelabelapp/components/notification_card.dart';
import 'package:whitelabelapp/config.dart';

class NotificationDetailScreen extends StatefulWidget {
  const NotificationDetailScreen({
    Key? key,
    required this.notificationData,
  }) : super(key: key);

  final dynamic notificationData;

  @override
  State<NotificationDetailScreen> createState() => _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kThemeColor,
            Colors.white,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.notificationData["title"] ?? "Notification detail"),
        ),
        body: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 370,
              minWidth: 370
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.notificationData["photo"] != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 370,
                        maxHeight: 200,
                        minWidth: 370,
                        minHeight: 200,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.notificationData["photo"] == null ? Image.asset("assets/images/whitelable_app_logo.png") : Image.network(
                          widget.notificationData["photo"], fit: BoxFit.cover,
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
                        ),
                      ),
                    ),
                  ),
                const Text(
                  "Description",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                  ),
                ),
                const SizedBox(height: 8,),
                Text(
                  widget.notificationData["description"] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8,),
                Text(
                  DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(widget.notificationData["updated_at"])),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
