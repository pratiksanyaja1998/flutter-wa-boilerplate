
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whitelableapp/config.dart';
import 'package:whitelableapp/localization/language_constants.dart';
import 'package:whitelableapp/screens/login.dart';
import 'package:whitelableapp/widgets/widgets.dart';

class LoginScreenWidgets {

  Widget loginTypeButton({
    required void Function()? onPressed,
    required var selectedLoginType,
    required var buttonType,
  }){
    return Expanded(
      child: Widgets().textButton(
        onPressed: onPressed,
        text: buttonType == LoginType.email ? "Email" : "Phone",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(buttonType == LoginType.email ? Icons.email : Icons.phone, color: selectedLoginType == buttonType ? kPrimaryColor : kThemeColor,),
            const SizedBox(width: 10,),
            Text(
              buttonType == LoginType.email ? "Email" : "Phone",
              style: TextStyle(
                color: selectedLoginType == buttonType ? kPrimaryColor : kThemeColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: selectedLoginType == buttonType ? kThemeColor : kPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: kIsWeb ? 15 : 10),
      ),
    );
  }

  Widget loginFormItem({required Widget child, double? verticalPadding}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: verticalPadding ?? 20),
      child: Container(
        constraints: const BoxConstraints(
            maxWidth: 370
        ),
        child: child,
      ),
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

}