import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Setelah 3 detik, berpindah ke PageEnter
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/enter');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo splash screen
              Image.asset(
                'assets/images/Logo.png', // Pastikan path logo benar
                width: 300,
                height: 300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
