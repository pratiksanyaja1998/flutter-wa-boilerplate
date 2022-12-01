
import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';

class AddressField extends StatelessWidget {
  const AddressField({
    Key? key,
    required this.controller,
    required this.fieldName,
    required this.hintText,
    this.initialValue,
  }) : super(key: key);

  final TextEditingController controller;
  final String fieldName;
  final String hintText;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            fieldName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          TextFormField(
            controller: controller,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black
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
