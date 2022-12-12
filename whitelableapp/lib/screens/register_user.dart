
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/model/user_model.dart';
import 'package:whitelabelapp/screens/otp_verification_screen.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/login_screen_widgets.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {

  bool showProgress = false;

  static final _registerUserFormKey = GlobalKey<FormState>();

  TapGestureRecognizer onTermsAndCondition = TapGestureRecognizer();

  PhoneNumber? phoneNumber;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPassword = true;

  @override
  void initState() {
    // TODO: implement initState
    onTermsAndCondition.onTap = (){
      print("terms and condition");
    };
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(getTranslated(context, ["registerScreen", "registration"]),),
        ),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _registerUserFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 370,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0,3),
                              ),
                            ],
                          ),
                          child: IntlPhoneField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(
                              labelText: getTranslated(context, ["registerScreen", "placeHolder", "phone"]),
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              suffixIcon: const Icon(Icons.phone, color: kThemeColor,),
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              errorStyle: const TextStyle(
                                fontSize: 0,
                              ),
                              counterText: "",
                              hintText: getTranslated(context, ["registerScreen", "placeHolder", "phone"]),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 16),
                              filled: true,
                              fillColor: kPrimaryColor,
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                borderRadius: BorderRadius.circular(10),
                                gapPadding: 0,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
                                gapPadding: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
                              ),
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              phoneNumber = phone;
                            },
                            autovalidateMode: AutovalidateMode.disabled,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                        child: Widgets().textFormField(
                          controller: firstNameController,
                          labelText: getTranslated(context, ["registerScreen", "placeHolder", "first_name"]),
                          validator: (val) {
                            if(val!.isEmpty){
                              Widgets().showAlertDialog(
                                alertMessage: getTranslated(context, ["registerScreen", "validate", "first_name"]), context: context,
                              );
                              return "";
                            }else{
                              return null;
                            }
                          },
                          // suffixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                        child: Widgets().textFormField(
                          controller: lastNameController,
                          labelText: getTranslated(context, ["registerScreen", "placeHolder", "last_name"]),
                          validator: (val) {
                            if(val!.isEmpty){
                              Widgets().showAlertDialog(
                                alertMessage: getTranslated(context, ["registerScreen", "validate", "last_name"]), context: context,
                              );
                              return "";
                            }else{
                              return null;
                            }
                          },
                          // suffixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                        child: Widgets().textFormField(
                          controller: emailController,
                          labelText: getTranslated(context, ["registerScreen", "placeHolder", "email"]),
                          validator: (val) {
                            if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)){
                              return null;
                            }else{
                              Widgets().showAlertDialog(
                                alertMessage: getTranslated(context, ["registerScreen", "validate", "email"]), context: context,
                              );
                              return "";
                            }
                          },
                          suffixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                        child: Widgets().textFormField(
                          controller: passwordController,
                          labelText: getTranslated(context, ["registerScreen", "placeHolder", "password"]),
                          validator: (val) {
                            if(val!.length < 6){
                              Widgets().showAlertDialog(
                                alertMessage: getTranslated(context, ["registerScreen", "validate", "password"]), context: context,
                              );
                              return "";
                            }else{
                              return null;
                            }
                          },
                          suffixIcon: Icons.remove_red_eye,
                          obscureText: showPassword,
                          showPassword: (){
                            showPassword = !showPassword;
                            setState(() {});
                          },
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      LoginScreenWidgets().loginFormItem(
                        child: Row(
                          children: [
                            Expanded(
                              child: Widgets().textButton(
                                onPressed: ()async{
                                  if(phoneNumber != null) {
                                    if (phoneNumber!.number.length < 10) {
                                      Widgets().showAlertDialog(
                                        alertMessage: getTranslated(context, ["registerScreen", "validate", "phone"]), context: context,
                                      );
                                      print("Invalid phone number");
                                    }else if(_registerUserFormKey.currentState!.validate()){
                                      showProgress = true;
                                      setState(() {});
                                      var response = await ServiceApis().registerUser(
                                        phone: phoneNumber!.completeNumber,
                                        email: emailController.text,
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        password: passwordController.text,
                                      );
                                      if(response.statusCode == 200){
                                        var data = jsonDecode(response.body);
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                            OtpVerificationScreen(userName: data["username"], userId: data["id"],))
                                        ).then((value){
                                          if(value != null){
                                            if(value["verified"]){
                                              showProgress = false;
                                              setState(() {});
                                              Navigator.of(context).pop();
                                              UserModel userModel = UserModel.fromJson(value["data"]);
                                              SharedPreference.setUser(userModel: userModel);
                                              SharedPreference.setIsLogin(true);
                                              Navigator.of(context).pop();
                                            }else{
                                              showProgress = false;
                                              setState(() {});
                                              Navigator.of(context).pop();
                                              print("Sorry you did not verified please login and verify otp.");
                                              Widgets().showAlertDialog(
                                                alertMessage: "Sorry you did not verified please login and verify otp.",
                                                context: context,
                                              );
                                            }
                                          }else{
                                            // showProgress = false;
                                            // setState(() {});
                                            showProgress = false;
                                            setState(() {});
                                            print("Sorry you did not verified please login and verify otp.");
                                            Widgets().showAlertDialog(
                                              alertMessage: "Sorry you did not verified please login and verify otp.",
                                              context: context,
                                            );
                                          }
                                        });
                                      }else{
                                        var data = jsonDecode(response.body);
                                        if(data.containsKey("detail")){
                                          print("---- ${data["detail"]}");
                                          Widgets().showAlertDialog(
                                            alertMessage: data["detail"], context: context,
                                          );
                                        }else{
                                          print("Log in failed something went wrong");
                                          Widgets().showAlertDialog(
                                            alertMessage: "Something went wrong", context: context,
                                          );
                                        }
                                        showProgress = false;
                                        setState(() {});
                                      }
                                    }
                                  }else{
                                    Widgets().showAlertDialog(
                                      alertMessage: "Please enter a valid mobile number", context: context,
                                    );
                                    print("Invalid phone number");
                                  }
                                },
                                text: getTranslated(context, ["registerScreen", "register"]),
                                fontSize: 24,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 12 : 8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      LoginScreenWidgets().loginFormItem(
                        child: RichText(
                          text:  TextSpan(
                            text: getTranslated(context, ["registerScreen", "agree"]),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                            children: [
                              TextSpan(
                                text: getTranslated(context, ["registerScreen", "termsAndConditions"]),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                recognizer: onTermsAndCondition,
                              ),
                            ],
                          ),
                        ),
                        verticalPadding: 0,
                      ),
                      const SizedBox(height: 40,),
                    ],
                  ),
                ),
              ),
            ),
            if(showProgress)
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: kThemeColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
