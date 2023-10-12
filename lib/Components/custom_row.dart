import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  const CustomRow({
    required this.text,
    required this.subtext,
    super.key,
  });
  final String text;
  final String subtext;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10,bottom: 5, top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                text,
                // style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(subtext,
                // style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
  }
}
