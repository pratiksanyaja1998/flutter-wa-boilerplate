
import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';

class Widgets {

  Widget textButton({
    required void Function()? onPressed,
    required String text,
  }){
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(kThemeColor),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 15, vertical: 6)),
        elevation: MaterialStateProperty.all(4),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        overlayColor: MaterialStateProperty.all(Colors.black.withOpacity(0.1)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
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
  }){
    return TextFormField(
      maxLines: 1,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        // floatingLabelStyle: const TextStyle(
        //   color: kPrimaryColor,
        // ),
        // focusedBorder: const OutlineInputBorder(
        //     borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
        //     gapPadding: 0
        // ),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            gapPadding: 0
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(),
        ),
      ),
      validator: validator,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: "Poppins",
      ),
    );
  }

}
