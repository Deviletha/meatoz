import 'package:flutter/material.dart';

class TextConst extends StatelessWidget {
  const TextConst({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 15, color: Colors.teal[900],fontWeight: FontWeight.bold),
    );
  }
}
