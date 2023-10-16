import 'dart:async';
import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import 'BottomNavBar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
      backgroundColor: Color(ColorT.themeColor),
      body: Center(
              child: Image.asset("assets/logo1.png",height: 80,color: Colors.white,
                // fit: BoxFit.cover,
              ),
            ),
    );
  }
}
