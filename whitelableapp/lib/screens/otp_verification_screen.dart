
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/service/api.dart';
import 'package:whitelableapp/widgets/login_screen_widgets.dart';
import 'package:whitelableapp/widgets/widgets.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    Key? key,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  final String userName;
  final int userId;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {

  late TapGestureRecognizer _onTapRecognizer;

  static final _verifyOtpFormKey = GlobalKey<FormState>();

  // TextEditingController passwordController = TextEditingController();
  // TextEditingController confirmPasswordController = TextEditingController();

  // bool showPassword = false;
  // bool showConfirmPassword = false;

  bool showProgress = false;

  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  TextEditingController otpController5 = TextEditingController();
  TextEditingController otpController6 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    resendOtpGesture();
    super.initState();
  }

  Future<void> resendOtpGesture()async{
    _onTapRecognizer = TapGestureRecognizer()..onTap = resendOtp;
  }

  Future<void> resendOtp() async {
    var response = await ServiceApis().resendVerificationOtp(
        userName: widget.userName,
    );
    if(response != null){
      if(response.statusCode == 200){
        print("otp sent successfully");
      }else{
        print("otp not send .....");
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Stack(
            children: [
              Center(
                child: Form(
                  key: _verifyOtpFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Widgets().appLogo(height: 90, width: 90, radius: 10),
                        const SizedBox(height: 50,),
                        // if(widget.isResetPassword)
                        //   Column(
                        //     children: [
                        //       CommonWidgets().formFields(
                        //         controller: passwordController,
                        //         padding: EdgeInsets.symmetric(vertical: 10),
                        //         hintText: "New Password",
                        //         lableText: "New Password *",
                        //         keyboardType: TextInputType.text,
                        //         obscureText: !showPassword,
                        //         showPassword: (){
                        //           showPassword = !showPassword;
                        //           setState(() {});
                        //         },
                        //         validator: (value){
                        //           if(value!.length < 8){
                        //             return "Password must has 8 characters.";
                        //           }else if(value.isEmpty){
                        //             return "Password can't be empty";
                        //           }else{
                        //             return null;
                        //           }
                        //         },
                        //       ),
                        //       CommonWidgets().formFields(
                        //         controller: confirmPasswordController,
                        //         padding: EdgeInsets.symmetric(vertical: 10),
                        //         hintText: "Confirm Password",
                        //         lableText: "Confirm Password *",
                        //         keyboardType: TextInputType.text,
                        //         obscureText: !showConfirmPassword,
                        //         showPassword: (){
                        //           showConfirmPassword = !showConfirmPassword;
                        //           setState(() {});
                        //         },
                        //         validator: (value){
                        //           if(value!.length < 8){
                        //             return "Password must has 8 characters.";
                        //           }else if(value.isEmpty){
                        //             return "Password can't be empty";
                        //           }else{
                        //             return null;
                        //           }
                        //         },
                        //       ),
                        //       SizedBox(height: 20,),
                        //     ],
                        //   ),

                        const Text(
                          "Enter OTP sent to your mobile number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 30,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _textFieldOTP(first: true, last: false, otpController: otpController1),
                              _textFieldOTP(first: false, last: false, otpController: otpController2),
                              _textFieldOTP(first: false, last: false, otpController: otpController3),
                              _textFieldOTP(first: false, last: false, otpController: otpController4),
                              _textFieldOTP(first: false, last: false, otpController: otpController5),
                              _textFieldOTP(first: false, last: true, otpController: otpController6),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        RichText(
                          text: TextSpan(
                              text: "Didn't receive the OTP?   ",
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: "RESEND",
                                  recognizer: _onTapRecognizer,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ]
                          ),
                        ),
                        const SizedBox(height: 35,),
                        LoginScreenWidgets().loginFormItem(
                          child: Row(
                            children: [
                              Expanded(
                                child: Widgets().textButton(
                                  onPressed: ()async{
                                    if(_verifyOtpFormKey.currentState!.validate()) {
                                      String otp = otpController1.text +
                                          otpController2.text +
                                          otpController3.text +
                                          otpController4.text +
                                          otpController5.text +
                                          otpController6.text;

                                      print("--- $otp ---");

                                      showProgress = true;
                                      setState(() {});

                                      // if(widget.isResetPassword){
                                      //   if(passwordController.text == confirmPasswordController.text){
                                      //     var response = await UserApi().resetPassword(
                                      //       newPassword: passwordController.text,
                                      //       confirmPassword: confirmPasswordController.text,
                                      //       otp: otp,
                                      //       phoneNumber: widget.phoneNumber,
                                      //     );
                                      //     if (response != null) {
                                      //       if (response.statusCode == 200) {
                                      //         var data = jsonDecode(response.body);
                                      //         showProgress = false;
                                      //         setState(() {});
                                      //         Navigator.of(context).pop({"verified":true, "data": data});
                                      //         Navigator.of(context).pop({"verified":true, "data": data});
                                      //       }else{
                                      //         print("something went wrong");
                                      //         showProgress = false;
                                      //         setState(() {});
                                      //         CommonWidgets().showToast(context, message: "something went wrong",);
                                      //       }
                                      //       // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                                      //     }else{
                                      //       showProgress = false;
                                      //       setState(() {});
                                      //       print("something went wrong");
                                      //       CommonWidgets().showToast(context, message: "something went wrong",);
                                      //     }
                                      //   }else{
                                      //     showProgress = false;
                                      //     setState(() {});
                                      //     CommonWidgets().showToast(context, message: "Confirm password does not match with new password.");
                                      //   }
                                      // }else
                                      // {
                                      var response = await ServiceApis().verifyOtp(
                                          userId: widget.userId, otp: otp);
                                      if (response != null) {
                                        var data = jsonDecode(response.body);
                                        if (response.statusCode == 200) {
                                          showProgress = false;
                                          setState(() {});
                                          Navigator.of(context).pop({"verified": true, "data": data});
                                        }else{
                                          showProgress = false;
                                          setState(() {});
                                          print("something went wrong");
                                          if(data.containsKey("detail")){
                                            LoginScreenWidgets()
                                                .showAlertDialog(
                                              alertMessage: data["detail"],
                                              context: context,
                                            );
                                          }else {
                                            LoginScreenWidgets()
                                                .showAlertDialog(
                                              alertMessage: "Something went wrong",
                                              context: context,
                                            );
                                          }
                                        }
                                        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                                      }else{
                                        showProgress = false;
                                        setState(() {});
                                        print("something went wrong");
                                        LoginScreenWidgets().showAlertDialog(
                                          alertMessage: "Something went wrong",
                                          context: context,
                                        );
                                      }
                                      // }
                                    }else{
                                      print("otp could not be empty");
                                      LoginScreenWidgets().showAlertDialog(
                                        alertMessage: "Please enter a valid OTP",
                                        context: context,
                                      );
                                    }
                                  },
                                  text: "Verify OTP",
                                  fontSize: 24,
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
      ),
    );
  }

  Widget _textFieldOTP({
    required bool first,
    required bool last,
    required TextEditingController otpController,
  }) {
    return Container(
      height: 55,
      width: 40,
      margin: EdgeInsets.only(left: first ? 0 :5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6
          ),
        ],
      ),
      child: TextFormField(
        controller: otpController,
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        validator: (value){
          if(value!.isEmpty){
            return "";
          }else{
            return null;
          }
        },
        readOnly: false,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            fontSize: 0,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
          filled: true,
          fillColor: kPrimaryColor,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          counter: const Offstage(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.black.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(6)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5, color: Colors.black,),
              borderRadius: BorderRadius.circular(6)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1.5, color: Colors.black),
              borderRadius: BorderRadius.circular(6)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.black.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

}
