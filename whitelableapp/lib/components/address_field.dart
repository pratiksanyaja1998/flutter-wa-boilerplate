
import 'package:flutter/material.dart';
import 'package:whitelabelapp/config.dart';

class UserSettingField extends StatelessWidget {
  const UserSettingField({
    Key? key,
    this.enabled,
    this.textColor,
    required this.controller,
    required this.fieldName,
    required this.hintText,
    this.initialValue,
  }) : super(key: key);

  final Color? textColor;
  final bool? enabled;
  final TextEditingController controller;
  final String fieldName;
  final String hintText;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 2),
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
            fieldName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          TextFormField(
            enabled: enabled ?? true,
            controller: controller,
            style: TextStyle(
              fontSize: 16,
              color: textColor ?? Colors.black,
            ),
            keyboardType: TextInputType.text,
            initialValue: initialValue,
            validator: (val){
              if(val!.isEmpty){
                return "";
              }else{
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(0),
              errorStyle: const TextStyle(
                fontSize: 0,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        ],
      ),
    );
  }
}
