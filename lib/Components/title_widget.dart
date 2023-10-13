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
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 17, color: Colors.grey.shade600,),
            ),
          ],
        ),
      ),
    );
  }
}
