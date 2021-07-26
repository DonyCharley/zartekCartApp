import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zartech_cart_app/src/business_logic/utils/preferences.dart';
import 'package:zartech_cart_app/src/views/ui/sign_in_screen.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPref _sharedPref=new SharedPref();

}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInScreen(),
    );
  }
}


