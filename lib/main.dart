import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meatoz/screens/splash_bottomNav/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meatoz Application',
      theme: _buildTheme(Brightness.light),
      home: SplashScreen(),
    );
  }
}
ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    // textTheme: GoogleFonts.robotoCondensedTextTheme(baseTheme.textTheme),
      appBarTheme: AppBarTheme(backgroundColor: Colors.teal[900],
  centerTitle: true, elevation: 0,systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.teal[900],
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),),focusColor: Colors.teal[900],primaryColor: Colors.teal[900]
  );
}