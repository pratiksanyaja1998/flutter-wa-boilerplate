
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingProject{

  static String? fcmToken;

  Future<void> getFcmToken()async{
    fcmToken = await FirebaseMessaging.instance.getToken();
    print("___ FCM TOKEN = $fcmToken ___");
  }

}