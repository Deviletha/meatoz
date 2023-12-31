import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TopPicksCard extends StatelessWidget {
  final String imagePath;

  final void Function()? onTap;

  const TopPicksCard({
    Key? key,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: MediaQuery.of(context).size.height / 6,
        width: MediaQuery.of(context).size.width / 1.05,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        // Image border// Image radius
        child: CachedNetworkImage(
          imageUrl: imagePath,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
          ),
          errorWidget: (context, url, error) => Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/noItem.png"))),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
