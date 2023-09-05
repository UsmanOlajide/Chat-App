import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_chatapp/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:new_chatapp/screens/chat.dart';
import 'package:new_chatapp/screens/splash.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      theme: ThemeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          // the if statement means if a user is logged in
          if (snapshot.hasData) {
            return const ChatScreen();
          }
          // then if we dont have any data (if a user is not logged in )
          return const AuthScreen();
        },
      ),
    );
  }
}

//* FEATURE / FIREBASE BRANCH

//  GOAL
// Show a different screen if we have the auth token which is generated when a user logs in  or creates an acc
// So that means if a user opens this app he should either see the auth screen or the chat screen
// auth screen if we dont have the auth token
// chat screen if we have the auth token

//* PROBLEM 
//* I can't work with uploading images from camera or gallery even on physical device
 
//* 
//*
//*