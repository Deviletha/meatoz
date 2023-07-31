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
      backgroundColor: Colors.teal[900],
      body: Center(
              child: Image.asset("assets/logo1.png",height: 80,color: Colors.white,
                // fit: BoxFit.cover,
              ),
            ),
    );
  }
}