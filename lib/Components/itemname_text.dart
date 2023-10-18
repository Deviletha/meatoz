import 'package:flutter/material.dart';

class ItemName extends StatelessWidget {
  const ItemName({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 10,
      style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
    );
  }
}
