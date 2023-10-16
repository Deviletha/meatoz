import 'package:flutter/material.dart';

class TextDescriptionHome extends StatelessWidget {
  const TextDescriptionHome({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
    );
  }
}
