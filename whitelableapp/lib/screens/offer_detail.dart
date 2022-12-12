
import 'package:flutter/material.dart';
import 'package:whitelabelapp/components/promotion_card.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';

class OfferDetailScreen extends StatefulWidget {
  const OfferDetailScreen({Key? key, required this.offerDetail}) : super(key: key);

  final dynamic offerDetail;

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {

  bool showProgress = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          title: Text(getTranslated(context, ["promotionDetailScreen", "title"])),
        ),
        body: Center(
          child: Column(
            children: [
              widget.offerDetail == null ?
              const Center() : PromotionCard(
                promotionImage: widget.offerDetail["image"],
                name: widget.offerDetail["name"],
                description: widget.offerDetail["description"],
                couponCode: widget.offerDetail["coupon_code"],
                percentOff: widget.offerDetail["percentage_of"],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
