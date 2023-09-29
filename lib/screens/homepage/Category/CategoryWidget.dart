import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../Components/text_widget.dart';

class CategoryCard extends StatelessWidget {
  final String ItemName;
  final String ImagePath;
  final color;
  void Function()? onTap;

  CategoryCard({Key? key,
    required this.ItemName,
    required this.ImagePath,
    this.color,
    required this.onTap,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360), color: Colors.grey),
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.height / 12,
              child: CachedNetworkImage(
                imageUrl: ImagePath,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/noItem.png"))),
                ),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            TextConst(
              text: ItemName,
            ),
          ],
        ),
      );
  }
}