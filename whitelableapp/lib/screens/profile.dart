
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whitelabelapp/config.dart';
import 'package:whitelabelapp/localization/language_constants.dart';
import 'package:whitelabelapp/model/user_model.dart';
import 'package:whitelabelapp/service/shared_preference.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  UserModel? user;
  var selectedProfilePicture;
  File? f;

  @override
  void initState() {
    // TODO: implement initState
    user = SharedPreference.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          )
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40,),
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: kPrimaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: f != null ? Image.file(f!) :  user!.photo.isNotEmpty ? Image.network(
                    SharedPreference.getUser()!.photo,
                    width: 80,
                    height: 80,
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
                      return Image.asset("assets/images/profile.png", width: 80, height: 80,);
                    },
                  ) : Image.asset("assets/images/profile.png", width: 80, height: 80,),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              "${user!.firstName} ${user!.lastName}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 2,),
            Text(
              user!.type,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            // const SizedBox(height: 2,),
            // Text(
            //   user!.email,
            //   style: const TextStyle(
            //     fontSize: 16,
            //   ),
            // ),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xff00d2c5),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.window, color: Colors.white,),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "General",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "general user data",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                thickness: 0.3,
                color: Colors.grey,
                height: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xffff7990),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.settings, color: Colors.white,),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Setting",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "notification setting",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                thickness: 0.3,
                color: Colors.grey,
                height: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xffff7990),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.settings, color: Colors.white,),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Setting",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "notification setting",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
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
