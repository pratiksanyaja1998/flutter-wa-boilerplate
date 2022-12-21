
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/payment_gateways/cashfree/cashfree.dart';
import 'package:whitelabelapp/payment_gateways/paytm/paytm.dart';
import 'package:whitelabelapp/payment_gateways/razor_pay/razor_pay.dart';
import 'package:whitelabelapp/payment_gateways/stripe/stripe.dart';
import 'package:whitelabelapp/screens/coin_transactions.dart';
import 'package:whitelabelapp/screens/contact_us.dart';
import 'package:whitelabelapp/screens/payment_detail.dart';
import 'package:whitelabelapp/screens/login.dart';
import 'package:whitelabelapp/screens/profile_settings.dart';
import 'package:whitelabelapp/screens/referral.dart';
import 'package:whitelabelapp/screens/settings.dart';
import 'package:whitelabelapp/screens/terms_and_condition.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  bool showProgress = true;
  bool showDonationProgress = true;

  List<dynamic> donationList = [];

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    getDonations();
    super.initState();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> getDonations()async{
    await Future.delayed(const Duration(seconds: 0));
    if(SharedPreference.isLogin()) {
      var profile = await ServiceApis().getUserProfile();
      showProgress = false;
      setState(() {});
      var response = await ServiceApis().getDonationList();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        donationList = data;
        showDonationProgress = false;
        setState(() {});
      } else {
        showDonationProgress = false;
        setState(() {});
        Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context);
      }
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(SharedPreference.getBusinessConfig()!.appName),
        ),
        drawer: Drawer(
          backgroundColor: kPrimaryColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          width: 200,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15,),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.black,),
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: (){
                    Navigator.pop(context);
                  },
                  title: Text(
                    getTranslated(context, ["menu", "home"]),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.black,),
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
                  },
                  title: Text(
                    getTranslated(context, ["menu", "settings"]),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.my_library_books_rounded, color: Colors.black,),
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TermsAndConditionScreen()));
                  },
                  title: Text(
                    getTranslated(context, ["menu", "termPolicy"]),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.contacts_rounded, color: Colors.black,),
                  style: ListTileStyle.drawer,
                  horizontalTitleGap: 0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactUsScreen()));
                  },
                  title: Text(
                    getTranslated(context, ["menu", "contactUs"]),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Expanded(child: Center()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Widgets().textButton(
                          onPressed: (){
                            if(SharedPreference.isLogin()){
                              Widgets().showConfirmationDialog(
                                confirmationMessage: getTranslated(context, ["settingScreen", "logoutMessage"]),
                                confirmButtonText: getTranslated(context, ["settingScreen", "confirm"]),
                                cancelButtonText: getTranslated(context, ["settingScreen", "cancel"]),
                                context: context,
                                onConfirm: ()async{
                                  showProgress = true;
                                  setState(() {});
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  await ServiceApis().userLogOut();
                                  showProgress = false;
                                  setState(() {});
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                                },
                              );
                            }else{
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                            }
                          },
                          text: SharedPreference.isLogin() ? getTranslated(context, ["menu", "logout"]) : getTranslated(context, ["menu", "login"]),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Powered by\nSpyhunter IT Solution\nv 3.0.4",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: showProgress ? const CircularProgressIndicator(
            color: kThemeColor,
          ) : Container(
            // padding: const EdgeInsets.all(20.0),
            constraints: BoxConstraints(
              maxWidth: 450,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: !SharedPreference.isLogin() ? Center(
              child: Widgets().textButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                text: "Login",
              ),
            ) : Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingsScreen())).then((value) {
                              setState(() {});
                            });
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          title: Row(
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(color: Colors.grey),
                                  color: kPrimaryColor,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: SharedPreference.getUser()!.photo.isNotEmpty ? Image.network(
                                    SharedPreference.getUser()!.photo,
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
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: "${SharedPreference.getUser()!.firstName} ",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: SharedPreference.getUser()!.lastName,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 3,),
                                    Text(
                                      SharedPreference.getUser()!.phone,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      SharedPreference.getUser()!.email,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 0,),
                              GestureDetector(
                                onTap: (){
                                  showDialog(
                                    context: context,
                                    useSafeArea: false,
                                    builder: (_){
                                      return Scaffold(
                                          body: Center(
                                            child: Container(
                                              padding: const EdgeInsets.all(30),
                                              constraints: const BoxConstraints(
                                                maxWidth: 370,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Widgets().appLogo(
                                                      height: 100,
                                                      width: 100,
                                                      radius: 5,
                                                    ),
                                                    const SizedBox(height: 30,),
                                                    QrImage(
                                                      data: SharedPreference.getUser()!.id.toString(),
                                                      version: QrVersions.auto,
                                                      // size: 200.0,
                                                    ),
                                                    const SizedBox(height: 10,),
                                                    Text(
                                                      "${SharedPreference.getUser()!.firstName} ${SharedPreference.getUser()!.lastName}",
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    Text(
                                                      SharedPreference.getUser()!.phone,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20,),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Widgets().textButton(
                                                            onPressed: (){
                                                              Navigator.pop(context);
                                                            },
                                                            text: getTranslated(context, ["donationDashboardScreen", "close"]),
                                                            fontSize: 22,
                                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 12 : 8),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                    },
                                  );
                                },
                                child: const Icon(
                                  CupertinoIcons.qrcode,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                          tileColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          dense: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
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
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  getTranslated(context, ["donationDashboardScreen", "coins"]),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                SharedPreference.getUser()!.coin ?? "",
                                style: const TextStyle(
                                  color: Colors.black,fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 5,),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                            ],
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (contxt) => CoinTransactionScreen()));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
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
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  getTranslated(context, ["donationDashboardScreen", "referralCode"]),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                SharedPreference.getUser()!.referralCode ?? "",
                                style: const TextStyle(
                                  color: Colors.black,fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 5,),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                            ],
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (contxt) => ReferralScreen()));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Expanded(
                      child: showDonationProgress ? const Center(
                        child: CircularProgressIndicator(
                          color: kThemeColor,
                        ),
                      ) : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 7,),
                            for(int i = 0; i < donationList.length; i++)
                              Container(
                                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
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
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹ ${donationList[i]["amount"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        if(donationList[i]["note"].isNotEmpty)
                                          const SizedBox(height: 3,),
                                        if(donationList[i]["note"].isNotEmpty)
                                          Text(
                                            donationList[i]["note"],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        const SizedBox(height: 3,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(donationList[i]["created_at"])),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.italic
                                                ),
                                              ),
                                            ),
                                            Text(
                                              donationList[i]["status"].toString().toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: donationList[i]["status"] == "paid" ? const Color(0xFF5577EE) : null,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDetailScreen(donationData: donationList[i]))).then((value){
                                        showDonationProgress = true;
                                        setState(() {});
                                        getDonations();
                                      });
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50,),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20.0, right: 20,  bottom: 20, top: 15),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Widgets().textButton(
                    //           onPressed: (){
                    //             showModalBottomSheet(
                    //                 context: context,
                    //                 isScrollControlled: true,
                    //                 builder: (_){
                    //                   return Padding(
                    //                     padding: EdgeInsets.only(
                    //                         bottom: MediaQuery.of(context).viewInsets.bottom),
                    //                     child: Container(
                    //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                    //                       constraints: const BoxConstraints(
                    //                         // maxHeight: 300,
                    //                       ),
                    //                       child: SingleChildScrollView(
                    //                         child: Column(
                    //                           children: [
                    //                             const Text(
                    //                               "Donate",
                    //                               style: TextStyle(
                    //                                 fontSize: 20,
                    //                                 fontWeight: FontWeight.bold,
                    //                               ),
                    //                             ),
                    //                             const SizedBox(height: 20,),
                    //                             Widgets().textFormField(
                    //                               controller: amountController,
                    //                               labelText: "Enter amount",
                    //                               keyboardType: TextInputType.number,
                    //                             ),
                    //                             const SizedBox(height: 20,),
                    //                             Widgets().textFormField(
                    //                               controller: descriptionController,
                    //                               labelText: "Enter description",
                    //                             ),
                    //                             const SizedBox(height: 30,),
                    //                             Row(
                    //                               children: [
                    //                                 Expanded(
                    //                                   child: Widgets().textButton(
                    //                                     onPressed: ()async{
                    //                                       if(amountController.text.isEmpty){
                    //                                         Widgets().showAlertDialog(alertMessage: "Enter a valid amount", context: context);
                    //                                       }else{
                    //                                         showDonationProgress = true;
                    //                                         setState(() {});
                    //                                         Navigator.pop(context);
                    //                                         var response = await ServiceApis().createDonation(
                    //                                           amount: double.parse(amountController.text),
                    //                                           description: descriptionController.text,
                    //                                         );
                    //                                         if(response.statusCode == 201){
                    //                                           int id = jsonDecode(response.body)["id"];
                    //                                           var data = jsonDecode(response.body)["payment"];
                    //                                           if(!kIsWeb) {
                    //                                             if (SharedPreference
                    //                                                 .getBusinessConfig()!
                    //                                                 .paymentType ==
                    //                                                 "paytm") {
                    //                                               await Paytm()
                    //                                                   .doPayment(
                    //                                                 id: id,
                    //                                                 context: context,
                    //                                                 orderId: data["id"]
                    //                                                     .toString(),
                    //                                                 amount: data["paid_amount"]
                    //                                                     .toString(),
                    //                                                 txnToken: data["payment_order_key"]
                    //                                                     .toString(),
                    //                                               ).then((value) {
                    //                                                 if(value == true){
                    //                                                   showDonationProgress = false;
                    //                                                   setState(() {});
                    //                                                 }else{
                    //                                                   showDonationProgress = false;
                    //                                                   setState(() {});
                    //                                                   Widgets().showAlertDialog(alertMessage: "Something went wrong.", context: context);
                    //                                                 }
                    //                                               });
                    //                                             } else
                    //                                             if (SharedPreference
                    //                                                 .getBusinessConfig()!
                    //                                                 .paymentType ==
                    //                                                 "razorpay") {
                    //                                               await RazorPay(
                    //                                                 id: id,
                    //                                                 context: context,
                    //                                                 order: data,
                    //                                               ).init().then((value){
                    //                                                 showDonationProgress = false;
                    //                                                 setState(() {});
                    //                                               });
                    //                                             }
                    //                                           }
                    //                                           if (SharedPreference
                    //                                               .getBusinessConfig()!
                    //                                               .paymentType ==
                    //                                               "cashfree") {
                    //                                             await CashFree(
                    //                                               id: id,
                    //                                               context: context,
                    //                                               orderId: data["payment_cashfree_order_id"]
                    //                                                   .toString(),
                    //                                               orderToken: data["payment_order_key"],
                    //                                             ).init().then((value){
                    //                                               showDonationProgress = false;
                    //                                               setState(() {});
                    //                                             });
                    //                                           }else
                    //                                           if (SharedPreference
                    //                                               .getBusinessConfig()!
                    //                                               .paymentType ==
                    //                                               "stripe") {
                    //                                             await StripePg(
                    //                                               id: id,
                    //                                               context: context,
                    //                                               orderId: data["id"]
                    //                                                   .toString(),
                    //                                               clientSecret: data["payment_key"]
                    //                                                   .toString(),
                    //                                             ).init().then((value){
                    //                                               showDonationProgress = false;
                    //                                               setState(() {});
                    //                                             });
                    //                                           }
                    //                                           await getDonations();
                    //                                         }else{
                    //                                           Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context);
                    //                                           showDonationProgress = false;
                    //                                           setState(() {});
                    //                                         }
                    //                                       }
                    //                                     },
                    //                                     text: "Donate",
                    //                                     fontSize: 22,
                    //                                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    //                                   ),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                             const SizedBox(height: 10,),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   );
                    //                 });
                    //           },
                    //           fontSize: 22,
                    //           text: "Donate",
                    //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 12 : 8),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 10,
                  child: Widgets().textButton(
                    onPressed: (){
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_){
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                                constraints: const BoxConstraints(
                                  // maxHeight: 300,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Donate",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      Widgets().textFormField(
                                        controller: amountController,
                                        labelText: getTranslated(context, ["donationDashboardScreen", "label", "amount"]),
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(height: 20,),
                                      Widgets().textFormField(
                                        controller: descriptionController,
                                        labelText: getTranslated(context, ["donationDashboardScreen", "label", "description"]),
                                      ),
                                      const SizedBox(height: 30,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Widgets().textButton(
                                              onPressed: ()async{
                                                if(amountController.text.isEmpty){
                                                  Widgets().showAlertDialog(alertMessage: getTranslated(context, ["donationDashboardScreen", "validate", "amount"]), context: context);
                                                }else{
                                                  showDonationProgress = true;
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                  var response = await ServiceApis().createDonation(
                                                    amount: double.parse(amountController.text),
                                                    description: descriptionController.text,
                                                  );
                                                  if(response.statusCode == 201){
                                                    int id = jsonDecode(response.body)["id"];
                                                    var data = jsonDecode(response.body)["payment"];
                                                    if(!kIsWeb) {
                                                      if (SharedPreference
                                                          .getBusinessConfig()!
                                                          .paymentType ==
                                                          "paytm") {
                                                        await Paytm()
                                                            .doPayment(
                                                          id: id,
                                                          context: context,
                                                          orderId: data["id"]
                                                              .toString(),
                                                          amount: data["paid_amount"]
                                                              .toString(),
                                                          txnToken: data["payment_order_key"]
                                                              .toString(),
                                                        ).then((value) {
                                                          if(value == true){
                                                            showDonationProgress = false;
                                                            setState(() {});
                                                          }else{
                                                            showDonationProgress = false;
                                                            setState(() {});
                                                            Widgets().showAlertDialog(alertMessage: getTranslated(context, ["donationDashboardScreen", "donationError"]), context: context);
                                                          }
                                                        });
                                                      } else
                                                      if (SharedPreference
                                                          .getBusinessConfig()!
                                                          .paymentType ==
                                                          "razorpay") {
                                                        await RazorPay(
                                                          id: id,
                                                          context: context,
                                                          order: data,
                                                        ).init().then((value){
                                                          showDonationProgress = false;
                                                          setState(() {});
                                                        });
                                                      }
                                                    }
                                                    if (SharedPreference
                                                        .getBusinessConfig()!
                                                        .paymentType ==
                                                        "cashfree") {
                                                      await CashFree(
                                                        id: id,
                                                        context: context,
                                                        orderId: data["payment_cashfree_order_id"]
                                                            .toString(),
                                                        orderToken: data["payment_order_key"],
                                                      ).init().then((value){
                                                        showDonationProgress = false;
                                                        setState(() {});
                                                      });
                                                    }else
                                                    if (SharedPreference
                                                        .getBusinessConfig()!
                                                        .paymentType ==
                                                        "stripe") {
                                                      await StripePg(
                                                        id: id,
                                                        context: context,
                                                        orderId: data["id"]
                                                            .toString(),
                                                        clientSecret: data["payment_key"]
                                                            .toString(),
                                                      ).init().then((value){
                                                        showDonationProgress = false;
                                                        setState(() {});
                                                      });
                                                    }
                                                    await getDonations();
                                                  }else{
                                                    Widgets().showAlertDialog(alertMessage: getTranslated(context, ["donationDashboardScreen", "donationError"]), context: context);
                                                    showDonationProgress = false;
                                                    setState(() {});
                                                  }
                                                }
                                              },
                                              text: "Donate",
                                              fontSize: 22,
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10,),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    fontSize: 22,
                    text: "Donate",
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 12 : 8),
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
