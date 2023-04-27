import 'package:digmart_business/Screens/Home/home_screen.dart';
import 'package:digmart_business/Screens/Login/login_screen.dart';
import 'package:digmart_business/components/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DigMart Business',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: primaryColor),
      home: const HomeScreen(),
    );
  }
}
