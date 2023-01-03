
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/components/address_field.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/service/api.dart';

class AddEditAddress extends StatefulWidget {
  const AddEditAddress({
    Key? key,
    required this.isEdit,
    this.addressList,
    this.index,
  }) : super(key: key);

  final bool isEdit;
  final List<dynamic>? addressList;
  final int? index;

  @override
  State<AddEditAddress> createState() => _AddEditAddressState();
}

class _AddEditAddressState extends State<AddEditAddress> {

  bool showProgress = false;

  String selectedType = "Home";

  List<String> types = ["Home", "Work", "Custom"];

  TextEditingController customTypeController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();

  @override
  void initState() {
    if(widget.isEdit){
      selectedType = types.contains(widget.addressList![widget.index!]["type"]) ? widget.addressList![widget.index!]["type"] : "Custom";
      streetController.text = widget.addressList![widget.index!]["street"];
      areaController.text = widget.addressList![widget.index!]["area"];
      cityController.text = widget.addressList![widget.index!]["city"];
      stateController.text = widget.addressList![widget.index!]["state"];
      countryController.text = widget.addressList![widget.index!]["country"];
      postCodeController.text = widget.addressList![widget.index!]["pincode"];
    }
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
              ]
          )
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              widget.isEdit ? getTranslated(context, ["addNewAddressScreen", "editAddress"]) : getTranslated(context, ["addNewAddressScreen", "addNewAddress"]),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: Center(
            child: showProgress ? const CircularProgressIndicator(
              color: kThemeColor,
            ) : Column(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 450,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                                    getTranslated(context, ["addNewAddressScreen", "placeHolder", "type"]),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedType,
                                    hint: Text(
                                      getTranslated(context, ["addNewAddressScreen", "placeHolder", "type"]),
                                    ),
                                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                                    iconSize: 28,
                                    elevation: 4,
                                    isDense: true,
                                    underline: Container(
                                      height: 0,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedType = newValue!;
                                        printMessage("--- $selectedType");
                                      });
                                    },
                                    alignment: Alignment.bottomCenter,
                                    dropdownColor: Theme.of(context).canvasColor,
                                    items: ["Home", "Work", "Custom"].map<
                                        DropdownMenuItem<
                                            String>>(
                                            (String value) {
                                          return DropdownMenuItem<
                                              String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                // color: Colors.black,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15,),
                            AddressField(
                              controller: customTypeController,
                              fieldName: getTranslated(context, ["addNewAddressScreen", "title", "newType"]),
                              hintText: getTranslated(context, ["addNewAddressScreen", "placeHolder", "newType"]),
                            ),
                            const SizedBox(height: 15,),
                            AddressField(
                              controller: streetController,
                              fieldName: getTranslated(context, ["addNewAddressScreen", "title", "street"]),
                              hintText: getTranslated(context, ["addNewAddressScreen", "placeHolder", "street"]),
                            ),
                            const SizedBox(height: 15,),
                            AddressField(
                              controller: areaController,
                              fieldName: getTranslated(context, ["addNewAddressScreen", "title", "area"]),
                              hintText: getTranslated(context, ["addNewAddressScreen", "placeHolder", "area"]),
                            ),
                            const SizedBox(height: 15,),
                            AddressField(
                              controller: cityController,
                              fieldName: getTranslated(context, ["addNewAddressScreen", "title", "city"]),
                              hintText: getTranslated(context, ["addNewAddressScreen", "placeHolder", "city"]),
                            ),
                            const SizedBox(height: 15,),
                            AddressField(
                              controller: stateController,
                              fieldName: getTranslated(context, ["addNewAddressScreen", "title", "state"]),
                              hintText: getTranslated(context, ["addNewAddressScreen", "placeHolder", "state"]),
                            ),
                            const SizedBox(height: 15,),
                            AddressField(
                              controller: countryController,
                              fieldName: getTranslated(context, ["addNewAddressScreen", "title", "country"]),
                              hintText: getTranslated(context, ["addNewAddressScreen", "placeHolder", "country"]),
                            ),
                            const SizedBox(height: 15,),
                            AddressField(
                              controller: postCodeController,
                              fieldName: getTranslated(context, ["addNewAddressScreen", "title", "postcode"]),
                              hintText: getTranslated(context, ["addNewAddressScreen", "placeHolder", "postcode"]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Widgets().textButton(
                        onPressed: () async {
                          if(selectedType.isEmpty){
                            CommonFunctions().showAlertDialog(alertMessage: getTranslated(context, ["addNewAddressScreen", "alert", "type"]), context: context,);
                          }else if(streetController.text.isEmpty){
                            CommonFunctions().showAlertDialog(alertMessage: getTranslated(context, ["message", "streetRequire"]), context: context,);
                          }else if(areaController.text.isEmpty){
                            CommonFunctions().showAlertDialog(alertMessage: getTranslated(context, ["message", "areaRequire"]), context: context,);
                          }else if(cityController.text.isEmpty){
                            CommonFunctions().showAlertDialog(alertMessage: getTranslated(context, ["message", "cityRequire"]), context: context,);
                          }else if(stateController.text.isEmpty){
                            CommonFunctions().showAlertDialog(alertMessage: getTranslated(context, ["message", "stateRequire"]), context: context,);
                          }else if(countryController.text.isEmpty){
                            CommonFunctions().showAlertDialog(alertMessage: getTranslated(context, ["message", "countryRequire"]), context: context,);
                          }else if(postCodeController.text.isEmpty){
                            CommonFunctions().showAlertDialog(alertMessage: getTranslated(context, ["message", "postCodeRequire"]), context: context,);
                          }else{
                            if(widget.isEdit){

                            }else{
                              var response = await ServiceApis().addAddress(
                                street: streetController.text,
                                area: areaController.text,
                                pinCode: postCodeController.text,
                                city: cityController.text,
                                state: stateController.text,
                                type: selectedType == "Custom" ? customTypeController.text : selectedType,
                                country: countryController.text,
                              );

                              if(!mounted) return;
                              if(response.statusCode == 201){
                                Navigator.pop(context);
                              }else{
                                var data = jsonDecode(response.body);
                                CommonFunctions().showError(data: data, context: context);
                              }

                            }
                          }
                        },
                        text: widget.isEdit ? getTranslated(context, ["addNewAddressScreen", "edit"]) : getTranslated(context, ["addNewAddressScreen", "add"]),
                        fontSize: 24,
                        borderRadius: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: kIsWeb ? 18 : 12,),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
