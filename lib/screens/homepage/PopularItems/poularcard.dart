import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../Components/text_widget.dart';

class PopularCard extends StatelessWidget {
  final String ImagePath;
  final String ItemName;
  final color;
  void Function()? onTap;

  PopularCard({Key? key,
    required this.ImagePath,
    this.color,
    required this.onTap, required this.ItemName,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width / 1,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
// Image border// Image radius
              child: CachedNetworkImage(
                imageUrl: ImagePath,
                placeholder: (context, url) =>
                    Container(
                      color: Colors.grey[300],
                    ),
                errorWidget: (context, url, error) =>
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/noItem.png"))),
                    ),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 5,
              child: TextConst(
                text: ItemName,
              ),
            )
          ],
        ),
      );
  }
}