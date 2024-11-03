import 'package:chasier_cafe/EnterPage.dart';
import 'package:chasier_cafe/Login.dart';
import 'package:chasier_cafe/Register.dart';
import 'package:chasier_cafe/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wikusama Cafe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Mulai dengan splash screen
      routes: {
        '/register': (context) => RegisterPage(), // Route ke Register Page
        '/login': (context) => LoginPage(), // Route ke Login Page
        '/enter': (context) => PageEnter(), // Route ke PageEnter
      },
    );
  }
}
