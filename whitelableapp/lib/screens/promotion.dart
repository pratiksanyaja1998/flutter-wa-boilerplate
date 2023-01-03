
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/components/drawer.dart';
import 'package:whitelabelapp/components/promotion_card.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/screens/offer_detail.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({Key? key}) : super(key: key);

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {

  List<dynamic> promotionList = [];

  bool showProgress = true;

  @override
  void initState() {
    // TODO: implement initState
    getPromotions();
    super.initState();
  }

  Future<void> getPromotions()async{
    var response = await BusinessServices().getPromotionList();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      promotionList = data;
      showProgress = false;
      if(mounted) {
        setState(() {});
      }
    } else {
      showProgress = false;
      if(!mounted) return;
      setState(() {});
      CommonFunctions().showError(data: data, context: context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(getTranslated(context, ["menu","promotion"])),
      ),
      drawer: DrawerItem().drawer(context, setState),
      body: Center(
        child: RefreshIndicator(
          onRefresh: ()async{
            showProgress = true;
            setState(() {});
            getPromotions();
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: showProgress ? const Center(
              child: CircularProgressIndicator(
                color: kThemeColor,
              ),
            ) : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: promotionList.isEmpty ?
              SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child: const Center(
                  child: Text("sorry no offers available."),
                ),
              ) : Column(
                children: [
                  for(int i = 0; i < promotionList.length; i++)
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OfferDetailScreen(offerDetail: promotionList[i])));
                      },
                      child: PromotionCard(
                        promotionImage: promotionList[i]["image"],
                        name: promotionList[i]["name"],
                        description: promotionList[i]["description"],
                        couponCode: promotionList[i]["coupon_code"],
                        percentOff: promotionList[i]["percentage_of"],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
