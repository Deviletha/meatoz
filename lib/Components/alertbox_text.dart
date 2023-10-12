import 'package:flutter/material.dart';

class AlertText extends StatelessWidget {
  const AlertText({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 15, color: Colors.teal.shade900,fontWeight: FontWeight.bold),
    );
  }
}