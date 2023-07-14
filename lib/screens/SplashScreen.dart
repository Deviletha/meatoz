import 'dart:async';
import 'package:flutter/material.dart';

import 'BottomNavBar.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const BottomNav()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
         // Image radius
              child: Image.asset("assets/logo.png",
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
