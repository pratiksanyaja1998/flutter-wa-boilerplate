
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class PromotionCard extends StatefulWidget {
  const PromotionCard({
    Key? key,
    this.promotionImage,
    required this.name,
    required this.description,
    required this.couponCode,
    required this.percentOff,
  }) : super(key: key);

  final String? promotionImage;
  final String? name;
  final String? description;
  final String? couponCode;
  final String? percentOff;

  @override
  State<PromotionCard> createState() => _PromotionCardState();
}

class _PromotionCardState extends State<PromotionCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 370,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      // padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 370,
                    maxHeight: 200,
                    minWidth: 370,
                    minHeight: 200,
                  ),
                  // decoration: BoxDecoration(
                  //   color: kPrimaryColor,
                  //   borderRadius: BorderRadius.circular(15),
                  //   boxShadow: [
                  //     BoxShadow(
                  //         color: Colors.black.withOpacity(0.5),
                  //         blurRadius: 10
                  //     )
                  //   ],
                  // ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(8) , topLeft: Radius.circular(8)),
                    child: widget.promotionImage == null ? Image.asset("assets/images/whitelable_app_logo.png") : Image.network(
                      widget.promotionImage!, fit: BoxFit.cover,
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
              Positioned(
                right: 15,
                bottom: 0,
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "${double.parse(widget.percentOff ?? "0").truncate()}% OFF",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name ?? "",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.description ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: DottedBorder(
                          padding: const EdgeInsets.all(0),
                          radius: const Radius.circular(3),
                          borderType: BorderType.RRect,
                          dashPattern: const [2 , 2],
                          color: Colors.grey[400]!,
                          strokeWidth: 1.7,
                          child: Row(
                            children: [
                              Expanded(
                                child: Widgets().textButton(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: ()async{
                                    copyCouponCode();
                                  },
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                  child: Text(
                                    widget.couponCode ?? "",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  text: widget.couponCode ?? "",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3,),
                    SizedBox(
                      height: 42,
                      child: Widgets().textButton(
                        borderRadius: 3,
                        elevation: 0,
                        onPressed: (){
                          copyCouponCode();
                        },
                        text: "COPY",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }

  Future<void> copyCouponCode()async{
    await Clipboard.setData(ClipboardData(text: widget.couponCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          height: 60,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 30,),
              const SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Success!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Copied to clipboard",
                      style: TextStyle(
                        // color: Colors.white,
                        // fontSize: 10,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: (){
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 30,),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

