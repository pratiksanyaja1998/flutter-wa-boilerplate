
import 'package:firebase_core/firebase_core.dart';
import 'package:wa_flutter_lib/wa_flutter_lib.dart';
import 'package:whitelabelapp/firebase_options.dart';

class FirebaseProject {

  Future<void> initializeFirebaseApp()async{
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }catch(e){
      printMessage("__________ $e ____________");
    }
  }

}