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
      maxLines: 10,
      style: TextStyle(fontSize: 12, color: Colors.teal[900],fontWeight: FontWeight.bold),
    );
  }
}
