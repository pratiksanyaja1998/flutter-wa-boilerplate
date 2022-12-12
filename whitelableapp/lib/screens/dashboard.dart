
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/payment_gateways/cashfree/cashfree.dart';
import 'package:whitelabelapp/payment_gateways/paytm/paytm.dart';
import 'package:whitelabelapp/payment_gateways/razor_pay/razor_pay.dart';
import 'package:whitelabelapp/payment_gateways/stripe/stripe.dart';
import 'package:whitelabelapp/screens/contact_us.dart';
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

  List<dynamic> donationList = [];

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getDonations();
    super.initState();
  }

  Future<void> getDonations()async{
    var response = await ServiceApis().getDonationList();
    var data = jsonDecode(response.body);
    if(response.statusCode == 200){
      donationList = data;
      showProgress = false;
      setState(() {});
    }else{
      showProgress = false;
      setState(() {});
      Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context);
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
                  title: const Text(
                    "Home",
                    style: TextStyle(
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
                                  Navigator.pop(context);
                                  await ServiceApis().userLogOut();
                                  // selectedItem = 0;
                                  setState(() {});
                                },
                              );
                            }else{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen())).then((value) {
                                getDonations();
                              });
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
          child: Container(
            // padding: const EdgeInsets.all(20.0),
            constraints: BoxConstraints(
              maxWidth: 450,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: !SharedPreference.isLogin() ? Center(
              child: Widgets().textButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen())).then((value) {
                    getDonations();
                  });
                },
                text: "Login",
              ),
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                                        text: "Close",
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
                const SizedBox(height: 20,),
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
                          const Expanded(
                            child: Text(
                              "Referral code",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            SharedPreference.getUser()!.referralCode ?? "",
                            style: const TextStyle(
                              color: Colors.black,fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black,),
                        ],
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (contxt) => ReferralScreen()));
                      },
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: showProgress ? const Center(
                    child: CircularProgressIndicator(
                      color: kThemeColor,
                    ),
                  ) : SingleChildScrollView(
                    child: Column(
                      children: [
                        for(int i = 0; i < donationList.length; i++)
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            constraints: const BoxConstraints(
                              minWidth: 370,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Column(
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
                                        DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse(donationList[i]["updated_at"])),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.italic
                                        ),
                                      ),
                                    ),
                                    Text(
                                      donationList[i]["status"].toString().toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
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
                                          labelText: "Enter amount",
                                          keyboardType: TextInputType.number,
                                        ),
                                        const SizedBox(height: 20,),
                                        Widgets().textFormField(
                                          controller: descriptionController,
                                          labelText: "Enter description",
                                        ),
                                        const SizedBox(height: 30,),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Widgets().textButton(
                                                onPressed: ()async{
                                                  if(amountController.text.isEmpty){
                                                    Widgets().showAlertDialog(alertMessage: "Enter a valid amount", context: context);
                                                  }else{
                                                    showProgress = true;
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
                                                              showProgress = false;
                                                              setState(() {});
                                                            }else{
                                                              showProgress = false;
                                                              setState(() {});
                                                              Widgets().showAlertDialog(alertMessage: "Something went wrong.", context: context);
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
                                                            showProgress = false;
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
                                                          showProgress = false;
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
                                                          showProgress = false;
                                                          setState(() {});
                                                        });
                                                      }
                                                      print("!_!_!_!_!_!_!_!_!_!_!_!_!_!_!_!_!_!_!_!_!_!_!");
                                                      await getDonations();
                                                    }else{
                                                      Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context);
                                                      showProgress = false;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
