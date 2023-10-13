import 'package:flutter/material.dart';

class TextDescription extends StatelessWidget {
  const TextDescription({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 3,
      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
    );
  }
}
