
import 'package:firebase_core/firebase_core.dart';
import 'package:whitelabelapp/firebase_options.dart';

class FirebaseProject {

  Future<void> initializeFirebaseApp()async{
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }catch(e){
      print("__________ $e ____________");
    }
  }

}