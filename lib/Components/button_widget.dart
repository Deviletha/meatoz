import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const Button({
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed:() {
          onPressed;
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shadowColor: Colors.teal[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(10)),
            )),
        child: Text(
          text
        ));
  }
}