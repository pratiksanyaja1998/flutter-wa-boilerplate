
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {

  bool showProgress = true;
  List<dynamic> referralList = [];

  @override
  void initState() {
    // TODO: implement initState
    getReferralList();
    super.initState();
  }

  Future<void> getReferralList()async{
    var response = await ServiceApis().getReferralList();
    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      referralList = data;
      showProgress = false;
      setState(() {});
    }else{
      showProgress = false;
      setState(() {});
      Widgets().showError(data: data, context: context);
    }
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
          ]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Referrals"),
        ),
        body: showProgress ? const Center(
          child: CircularProgressIndicator(
            color: kThemeColor,
          ),
        ) : Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for(int i = 0; i < referralList.length; i++)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Material(
                              elevation: 0,
                              color: Colors.transparent,
                              child: ListTile(
                                onTap: (){

                                },
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(40),
                                              border: Border.all(color: Colors.grey),
                                              color: kPrimaryColor,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(40),
                                              child: referralList[i]["user"]["photo"] != null ? Image.network(
                                                referralList[i]["user"]["photo"],
                                                width: 80,
                                                height: 80,
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
                                          const SizedBox(width: 15,),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text: "${referralList[i]["user"]["first_name"]} ",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: referralList[i]["user"]["last_name"],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 3,),
                                                Text(
                                                  referralList[i]["user"]["phone"],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  referralList[i]["user"]["email"],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                if(referralList[i].containsKey("total_donation"))
                                                  if(referralList[i]["total_donation"] != null)
                                                    Text(
                                                      "Total donation : ₹ ${referralList[i]["total_donation"]}",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
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
                                tileColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                dense: true,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10,)
                      ],
                    ),
                  ),
                ),
                if(SharedPreference.getBusinessConfig()!.socialLink["playStore"] != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Widgets().textButton(
                            onPressed: (){
                              Share.share('check out this amazing app ${SharedPreference.getBusinessConfig()!.socialLink["playStore"]} use my referral code ${SharedPreference.getUser()!.referralCode} to get free coins', subject: 'user referral');
                            },
                            text: "Share",
                            fontSize: 22,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          ),
                        ),
                      ],
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
