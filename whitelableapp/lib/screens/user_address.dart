
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/screens/add_edit_address.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class UserAddress extends StatefulWidget {
  const UserAddress({Key? key}) : super(key: key);

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {

  bool showProgress = true;

  List<dynamic> savedAddressList = [];

  @override
  void initState() {
    // TODO: implement initState
    getSavedAddresses();
    super.initState();
  }

  Future<void> getSavedAddresses()async{
    var response = await ServiceApis().getUserAddressList();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      savedAddressList = data;
      showProgress = false;
      if(mounted) {
        setState(() {});
      }
    } else {
      showProgress = false;
      if(mounted) {
        setState(() {});
      }
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
          )
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              getTranslated(context, ["addressList", "title"]),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 450,
                minHeight: MediaQuery.of(context).size.height,
              ),
              padding: const EdgeInsets.all(20.0),
              child: showProgress ? const Center(
                child: CircularProgressIndicator(
                  color: kThemeColor,
                ),
              ) : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for(int i = 0; i < savedAddressList.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  extentRatio: 0.35,
                                  // dismissible: DismissiblePane(onDismissed: () {}),
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10, left: 20),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        // color: Colors.black.withOpacity(0.3),
                                      ),
                                      child: Widgets().textButton(
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditAddress(
                                            isEdit: true,
                                            addressList: savedAddressList,
                                            index: i,
                                          )));
                                        },
                                        text: "edit",
                                        backgroundColor: Colors.grey[600],
                                        borderRadius: 20,
                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                        overlayColor: Colors.white.withOpacity(0.2),
                                        child: const Icon(Icons.edit_outlined, size: 20, color: Colors.white,),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 0),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.red,
                                      ),
                                      child: Widgets().textButton(
                                        onPressed: ()async{
                                          showProgress = true;
                                          setState(() {});
                                          var response = await ServiceApis().deleteAddress(addressId: savedAddressList[i]["id"]);
                                          if(response.statusCode == 204){
                                            await getSavedAddresses();
                                          }else{
                                            var data = jsonDecode(response.body);
                                            if(data.containsKey("detail")){
                                              print("---- ${data["detail"]}");
                                              Widgets().showAlertDialog(alertMessage: data["detail"], context: context,);
                                            }else{
                                              print("something went wrong");
                                              Widgets().showAlertDialog(alertMessage: "Something went wrong", context: context,);
                                            }
                                            showProgress = false;
                                            setState(() {});
                                          }
                                        },
                                        text: "edit",
                                        backgroundColor: Colors.red,
                                        borderRadius: 20,
                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                        overlayColor: Colors.white.withOpacity(0.2),
                                        child: const Icon(Icons.delete_outline, size: 20, color: Colors.white,),
                                      ),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  constraints: const BoxConstraints(
                                    minWidth: 370,
                                  ),
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        savedAddressList[i]["type"],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "${savedAddressList[i]["street"]}, ${savedAddressList[i]["area"]},",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "${savedAddressList[i]["city"]}, ${savedAddressList[i]["state"]}, ${savedAddressList[i]["country"]} - ${savedAddressList[i]["pincode"] ?? ""}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Widgets().textButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditAddress(isEdit: false))).then((value) async {
                              showProgress = true;
                              setState(() {});
                              await getSavedAddresses();
                            });
                          },
                          text: getTranslated(context, ["addressList", "addAddress"]),
                          fontSize: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: kIsWeb ? 15 : 10,),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
