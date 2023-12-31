import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../../Components/text_widget.dart';

class PopularCard extends StatelessWidget {
  final String imagePath;
  final String itemName;
  final void Function()? onTap;

  const PopularCard({
    Key? key,
    required this.imagePath,
    required this.onTap,
    required this.itemName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey.shade700),
              // boxShadow: [BoxShadow(color: Colors.grey.shade500,blurRadius: 3,),],
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
                    image: DecorationImage(
                        image: AssetImage("assets/noItem.png"))),
              ),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width / 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextConst(
                  text: itemName,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
