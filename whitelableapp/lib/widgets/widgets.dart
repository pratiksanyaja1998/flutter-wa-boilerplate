
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whitelableapp/config.dart';

class Widgets {

  Widget textButton({
    required void Function()? onPressed,
    required String text,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? overlayColor,
    double? fontSize,
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
        elevation: MaterialStateProperty.all(4),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
        overlayColor: MaterialStateProperty.all(overlayColor ?? Colors.black.withOpacity(0.04)),
      ),
      child: child ?? Text(
        text,
        style: TextStyle(
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
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool? obscureText,
    void Function()? showPassword,
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
      constraints: const BoxConstraints(
        maxWidth: 370,
      ),
      child: TextFormField(
        maxLines: 1,
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.grey
          ),
          suffixIcon: showPassword != null ? IconButton(
            onPressed: showPassword,
            icon: Icon(obscureText! ? Icons.remove_red_eye : CupertinoIcons.eye_slash_fill, color: kThemeColor,),
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
        child: Image.asset("assets/images/logo.png", width: width, height: height,),
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

}
