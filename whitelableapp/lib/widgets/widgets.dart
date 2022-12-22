
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';

class Widgets {

  Widget textButton({
    required void Function()? onPressed,
    required String text,
    double? elevation,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? overlayColor,
    double? fontSize,
    TextStyle? style,
    double? borderRadius,
    Widget? child,
  }){
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor ?? kThemeColor),
        surfaceTintColor: MaterialStateProperty.all(kPrimaryColor),
        foregroundColor: MaterialStateProperty.all(Colors.transparent),
        padding: MaterialStateProperty.all(padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 6)),
        elevation: MaterialStateProperty.all(elevation ?? 4),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        overlayColor: MaterialStateProperty.all(overlayColor ?? Colors.black.withOpacity(0.04)),
      ),
      child: child ?? Text(
        text,
        style: style ?? TextStyle(
          fontSize: fontSize ?? 18,
          fontWeight: FontWeight.bold,
          color: kPrimaryColor
        ),
      ),
    );
  }

  Widget textFormField({
    required TextEditingController controller,
    required String labelText,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool? obscureText,
    double? maxWidth,
    void Function()? onPressedSuffixIcon,
    IconData? suffixIcon,
  }){
    return Container(
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
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? 370,
      ),
      child: TextFormField(
        maxLines: 1,
        controller: controller,
        obscureText: obscureText ?? false,
        onChanged: onChanged ?? null,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.grey
          ),
          suffixIcon: onPressedSuffixIcon != null ? IconButton(
            onPressed: onPressedSuffixIcon,
            icon: obscureText != null ? Icon(obscureText ? Icons.remove_red_eye : CupertinoIcons.eye_slash_fill, color: kThemeColor,) :
            Icon(suffixIcon ?? Icons.remove_red_eye, color: kThemeColor,),
          ) : suffixIcon != null ? Icon(suffixIcon, color: kThemeColor,) : null,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          errorStyle: const TextStyle(
            fontSize: 0,
          ),
          hintText: labelText,
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
        validator: validator,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    );
  }

  Widget appLogo({
    required double height,
    required double width,
    required double radius,
  }){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset("assets/images/logo.png", width: width, height: height, fit: BoxFit.cover,),
      ),
    );
  }

  void showToast({required String msg}){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: kPrimaryColor,
      textColor: kThemeColor,
      fontSize: 16.0,
    );
  }

  void showAlertDialog({required String alertMessage, required BuildContext context}){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              alertMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15,),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Widgets().textButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      text: getTranslated(context, ["common", "ok"])
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void showConfirmationDialog({
    required String confirmationMessage,
    required String confirmButtonText,
    required String cancelButtonText,
    required BuildContext context,
    required void Function()? onConfirm,
  }){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              confirmationMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15,),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Widgets().textButton(
                    onPressed: onConfirm,
                    text: confirmButtonText,
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Widgets().textButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    text: cancelButtonText,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget otpField({
    required BuildContext context,
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

  Widget settingOptionTile({
    required BuildContext context,
    required String tileText,
    void Function()? onTap,
    bool showArrowIcon = true,
    Color? tileTextColor,
  }){
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
          leading: Text(
            tileText,
            style: TextStyle(
              color: tileTextColor,
              fontSize: 13,
            )
          ),
          onTap: onTap,
          tileColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          dense: true,
          trailing: showArrowIcon ? const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black, size: 20,) : null,
        ),
      ),
    );
  }

  void showSuccessModal({required BuildContext context, bool success = true}){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Container(
          constraints: const BoxConstraints(
            maxHeight: 190
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(success ? Icons.done_all_rounded : Icons.close_rounded, color: success ? Colors.green : Colors.red, size: 40,),
              Text(
                success ? "Payment Successful" : "Payment failed",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: success ? Colors.green : Colors.red,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: textButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      text: getTranslated(context, ["common", "ok"])
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

}
