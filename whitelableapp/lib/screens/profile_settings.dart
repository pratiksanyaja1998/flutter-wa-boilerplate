
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:whitelabelapp/components/address_field.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/model/user_model.dart';
import 'package:whitelabelapp/service/api.dart';
import 'package:whitelabelapp/service/shared_preference.dart';
import 'package:whitelabelapp/widgets/widgets.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  UserModel? user;
  var selectedProfilePicture;
  File? f;

  @override
  void initState() {
    // TODO: implement initState
     user = SharedPreference.getUser();
    if(user != null) {
      firstNameController.text = user!.firstName;
      lastNameController.text = user!.lastName;
      phoneNumberController.text = user!.phone;
      emailController.text = user!.email;
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
            title: Text(getTranslated(context, ["profileScreen", "profileSettings"])),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              constraints: BoxConstraints(
                maxWidth: 370,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: ()async{
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),   
                                context: context,
                                builder: (context){
                                  return ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 228,
                                    ),
                                    child: Column(
                                      children: [
                                        Material(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          child: ListTile(
                                            onTap: ()async{
                                              Navigator.pop(context);
                                              await takePhoto(source: ImageSource.camera);
                                            },
                                            title: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                              child: Text(
                                                getTranslated(context, ["actionSheet", "takePhoto"]),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            tileColor: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            dense: true,
                                          ),
                                        ),
                                        Material(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          child: ListTile(
                                            onTap: ()async{
                                              Navigator.pop(context);
                                              await takePhoto(source: ImageSource.gallery);
                                            },
                                            title: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                              child: Text(
                                                getTranslated(context, ["actionSheet", "choosePhoto"]),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),),
                                            ),
                                            tileColor: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            dense: true,
                                          ),
                                        ),
                                        Material(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          child: ListTile(
                                            onTap: (){
                                              Navigator.pop(context);
                                              f = null;
                                              user!.photo = "";
                                              setState(() {});
                                            },
                                            title: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                              child: Text(
                                                getTranslated(context, ["actionSheet", "removePhoto"]),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            tileColor: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            dense: true,
                                          ),
                                        ),
                                        Material(
                                          elevation: 0,
                                          color: Colors.transparent,
                                          child: ListTile(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            title: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                              child: Text(
                                                getTranslated(context, ["actionSheet", "cancel"]),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            tileColor: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            dense: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.grey),
                                color: kPrimaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: f != null ? Image.file(f!) :  user!.photo.isNotEmpty ? Image.network(
                                  SharedPreference.getUser()!.photo,
                                  width: 100,
                                  height: 100,
                                  loadingBuilder: (context, child, loadingProgress){
                                    if(loadingProgress != null){
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: kThemeColor,
                                          strokeWidth: 3,
                                        ),
                                      );
                                    }else{
                                      return child;
                                    }
                                  },
                                  errorBuilder: (context, obj, st){
                                    return Image.asset("assets/images/profile.png", width: 100, height: 100,);
                                  },
                                ) : Image.asset("assets/images/profile.png", width: 100, height: 100,),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          UserSettingField(
                            controller: firstNameController,
                            fieldName: getTranslated(context, ["profileScreen", "firstName"]),
                            hintText: getTranslated(context, ["profileScreen", "firstName"]),
                          ),
                          const SizedBox(height: 15,),
                          UserSettingField(
                            controller: lastNameController,
                            fieldName: getTranslated(context, ["profileScreen", "lastName"]),
                            hintText: getTranslated(context, ["profileScreen", "lastName"]),
                          ),
                          const SizedBox(height: 15,),
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
                                  getTranslated(context, ["profileScreen", "phone"]),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                IntlPhoneField(
                                  readOnly: true,
                                  enabled: false,
                                  style: const TextStyle(
                                    color: Colors.grey
                                  ),
                                  controller: phoneNumberController,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    hintText: getTranslated(context, ["profileScreen", "phone"]),
                                    hintStyle: const TextStyle(
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    // contentPadding: const EdgeInsets.all(0),
                                    errorStyle: const TextStyle(
                                      fontSize: 0,
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                  ),
                                  initialCountryCode: 'IN',
                                  onChanged: (phone) {
                                    // phoneNumber = phone;
                                  },
                                  autovalidateMode: AutovalidateMode.disabled,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15,),
                          UserSettingField(
                            enabled: false,
                            textColor: Colors.grey,
                            controller: emailController,
                            fieldName: getTranslated(context, ["profileScreen", "email"]),
                            hintText: getTranslated(context, ["profileScreen", "email"]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Widgets().textButton(
                          onPressed: ()async{
                            var response = await ServiceApis().updateUserProfile(
                              photo: f,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                            );
                            if(response.statusCode == 200){
                              // UserModel? user = SharedPreference.getUser();
                              if(user != null){
                                var data = jsonDecode(response.body);
                                user!.firstName = data["first_name"];
                                user!.lastName = data["last_name"];
                                user!.photo = data["photo"] ?? "";
                                await SharedPreference.setUser(userModel: user);
                                setState(() {});
                              }
                            }else{

                            }
                          },
                          text: getTranslated(context, ["editProfileScreen", "save"]),
                          fontSize: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

  Future<void> takePhoto({required ImageSource source})async{
    var result = await ImagePicker.platform.pickImage(source: source);
    if(result != null){
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: result.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
      if(croppedFile != null){
        print("-=-=-=--=-= ${croppedFile.path}");
        f = File(croppedFile.path);
        setState(() {});
      }
    }
  }

}
