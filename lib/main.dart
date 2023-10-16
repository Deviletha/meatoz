import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meatoz/screens/splash_bottomNav/SplashScreen.dart';
import 'package:meatoz/theme/colors.dart';

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
      appBarTheme: AppBarTheme(backgroundColor: Color(ColorT.themeColor),
   elevation: 0,systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(ColorT.themeColor),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),),focusColor: Color(ColorT.themeColor),primaryColor: Color(ColorT.themeColor)
  );
}