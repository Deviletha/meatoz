import 'package:flutter/material.dart';
import '../../../../../Components/text_widget.dart';

class TopPicksCard extends StatelessWidget {
  final String ImagePath;
  final color;
  void Function()? onTap;

  TopPicksCard({Key? key,
    required this.ImagePath,
    this.color,
    required this.onTap,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        width: 330,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image:
            DecorationImage(image: NetworkImage(ImagePath), fit: BoxFit.cover)),
      ),
    );
  }
}