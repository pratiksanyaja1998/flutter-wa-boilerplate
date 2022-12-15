
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class CoinTransactionScreen extends StatefulWidget {
  const CoinTransactionScreen({Key? key}) : super(key: key);

  @override
  State<CoinTransactionScreen> createState() => _CoinTransactionScreenState();
}

class _CoinTransactionScreenState extends State<CoinTransactionScreen> with TickerProviderStateMixin{

  bool showProgress = true;
  List<dynamic> coinTransaction = [];
  List<dynamic> creditList = [];
  List<dynamic> debitList = [];

  DateTime? searchDate;

  TextEditingController searchTextController = TextEditingController();
  TextEditingController redeemCoinController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getCoinTransactions();
    super.initState();
  }

  Future<void> getCoinTransactions()async{
    var response = await ServiceApis().getCoinTransactions(
      searchText: searchTextController.text,
      date: searchDate != null ? DateFormat("yyyy-MM-dd").format(searchDate!) : null,
    );
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      coinTransaction = data;
      creditList = coinTransaction.where((element) => element["type"] == "credit").toList();
      debitList = coinTransaction.where((element) => element["type"] == "debit").toList();
      showProgress = false;
      setState(() {});
    }else{
      Widgets().showAlertDialog(
        alertMessage: "Something went wrong",
        context: context,
      );
      showProgress = false;
      setState(() {});
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                  child: Widgets().textFormField(
                    controller: searchTextController,
                    labelText: "search",
                    suffixIcon: Icons.search,
                    onPressedSuffixIcon: (){
                      showProgress = true;
                      setState(() {});
                      getCoinTransactions();
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    constraints: const BoxConstraints(
                      minWidth: 370,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Filter by date",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        GestureDetector(
                          onTap: ()async{
                            var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if(date != null){
                              searchDate = date;
                              showProgress = true;
                              setState(() {});
                              getCoinTransactions();
                            }
                          },
                          child: Text(
                            searchDate != null ? DateFormat("dd MMM yyyy hh:mm a").format(searchDate!) : "select date",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                          decoration: BoxDecoration(
                            color: kThemeColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: TabBar(
                              labelStyle: const TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              unselectedLabelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                // decoration: TextDecoration.underline,
                                decorationThickness: 2,
                              ),
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.white,
                              indicator: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              tabs: const [
                                Tab(
                                  text: "Credit",
                                ),
                                Tab(
                                  text: "Debit",
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              tabView(),
                              tabView(isCredit: false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
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
                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                child: Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 340,
                                    maxWidth: 370,
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Redeem coins",
                                        style: TextStyle(
                                          fontSize:20 ,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      const Expanded(child: Center()),
                                      Widgets().textFormField(
                                        controller: redeemCoinController,
                                        labelText: "Redeem coin amount",
                                        keyboardType: TextInputType.number,
                                      ),
                                      const SizedBox(height: 25,),
                                      Widgets().textFormField(
                                        controller: upiIdController,
                                        labelText: "UPI id",
                                      ),
                                      const Expanded(child: Center()),
                                      const SizedBox(height: 30,),
                                      Text("Minimum ${SharedPreference.getBusinessConfig()!.redeemCoin.minCoin} coins required to redeem"),
                                      const SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Widgets().textButton(
                                              onPressed: () async{
                                                if(redeemCoinController.text.isEmpty){
                                                  Widgets().showAlertDialog(alertMessage: "coin amount can not be empty", context: context);
                                                }else if(double.parse(redeemCoinController.text) < SharedPreference.getBusinessConfig()!.redeemCoin.minCoin){
                                                  Widgets().showAlertDialog(alertMessage: "coin amount should be more than minimum required amount of coin", context: context);
                                                }else if(double.parse(redeemCoinController.text) > double.parse(SharedPreference.getUser()!.coin)){
                                                  Widgets().showAlertDialog(alertMessage: "coin amount could not be greater than coins in your wallet", context: context);
                                                }else if(upiIdController.text.isEmpty){
                                                  Widgets().showAlertDialog(alertMessage: "UPI id can not be empty", context: context);
                                                }else{
                                                  showProgress = true;
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                  var response = await ServiceApis().redeemCoins(coin: double.parse(redeemCoinController.text), upiId: upiIdController.text);
                                                  if(response.statusCode == 201){
                                                    showDialog(context: context, builder: (_){
                                                      return AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        content: const Text(
                                                          "Your request for redeem coin sent successfully we will notify you when further action will be taken.",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        contentPadding: EdgeInsets.only(left: 20, right: 20, top: 20),
                                                        actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Expanded(
                                                                child: Widgets().textButton(
                                                                  onPressed: (){
                                                                    Navigator.pop(context);
                                                                  },
                                                                  text: "Ok",
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },);
                                                  }else{
                                                    Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context);
                                                  }
                                                }
                                                showProgress = false;
                                                setState(() {});
                                              },
                                              text: "Request",
                                              fontSize: 22,
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                          },
                          text: "Redeem coins",
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

  Widget tabView({bool isCredit = true}){
    return SingleChildScrollView(
      child: Column(
        children: [
          for(int i = 0; i < (isCredit ? creditList.length : debitList.length); i++)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
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
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "TRD${(isCredit ? creditList : debitList)[i]["id"].toString().padLeft(5, "0")}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  DateFormat("dd MMM yyyy hh:mm a").format(DateTime.parse((isCredit ? creditList : debitList)[i]["created_at"])),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "₹ ${(isCredit ? creditList : debitList)[i]["coin"].toString().padLeft(5, "0")}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  isCredit ? "CREDITED" : "DEBITED",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isCredit ? const Color(0xFF1166ff) : null,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if((isCredit ? creditList : debitList)[i]["remark"] != null)
                              if((isCredit ? creditList : debitList)[i]["remark"].isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top:5.0),
                                  child: Text(
                                    (isCredit ? creditList : debitList)[i]["remark"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
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
        ],
      ),
    );
  }

}
