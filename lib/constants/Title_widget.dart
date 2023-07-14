import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  const Heading({
    required this.text,
    super.key,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 20, color: Colors.teal[900],fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
