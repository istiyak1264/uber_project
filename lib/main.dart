import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:users_app/authentication/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCI-26aKz3KCKvztWX2Ow2NT7zJtLWd9Jw",
      appId: "1:438526843454:android:92b590c1c9a443d0ee0f6f",
      messagingSenderId: "438526843454",
      projectId: "uberproject-66082",
      databaseURL: "https://uberproject-66082-default-rtdb.firebaseio.com/",
    ),
  );

  /*await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
    if (valueOfPermission) {
      Permission.locationWhenInUse.request();
    }
  });*/

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      home: LoginScreen(),
    );
  }
}
