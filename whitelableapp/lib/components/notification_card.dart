
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({
    Key? key,
    this.enabled,
    this.selectAll,
    this.selected,
    this.photo,
    this.title,
    this.description,
    this.date,
  }) : super(key: key);

  final bool? selectAll;
  final bool? enabled;
  final bool? selected;
  final String? photo;
  final String? title;
  final String? description;
  final String? date;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {

  @override
  void initState() {
    // TODO: implement initState
    slide();
    super.initState();
  }

  Future<void> slide()async{
    await Future.delayed(Duration(milliseconds: 0));
    final slidable = Slidable.of(context);
    if(widget.selectAll != null && widget.selectAll == true){
      print("START START");
      slidable?.openStartActionPane();
    }else{
      print("CLOSE CLOSE");
      slidable?.close();
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    slide();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant NotificationCard oldWidget) {
    // TODO: implement didUpdateWidget
    slide();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 370,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title ?? "End of sales",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  widget.description ?? "Hello customers",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  widget.date ?? "07-12-2022",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: kThemeColor,
          ),
        ],
      ),
    );
  }
}
