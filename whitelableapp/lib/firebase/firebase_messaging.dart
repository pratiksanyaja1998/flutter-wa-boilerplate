
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';

class FirebaseMessagingProject{

  static String? fcmToken;

  Future<void> getFcmToken()async{
    fcmToken = await FirebaseMessaging.instance.getToken();
    printMessage("___ FCM TOKEN = $fcmToken ___");
  }



}