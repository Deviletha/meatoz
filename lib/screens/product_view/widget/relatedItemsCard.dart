
import 'package:flutter/material.dart';
import 'package:meatoz/Components/text_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../theme/colors.dart';

class RelatedItemTile extends StatelessWidget {
  final String itemName;
  final String price;
  final String imagePath;
  // final color;
  final void Function()? onPressed;

  const RelatedItemTile({Key? key,
    required this.itemName,
    required this.imagePath,
    // this.color,
    required this.onPressed,
    required this.price,
    })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.shade500,blurRadius: 3,),],
            borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),
                  topRight: Radius.circular(15)),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextConst(
                  text: itemName,
                ),
              ),
              Text(
                price,
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(ColorT.themeColor),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(ColorT.themeColor),
                    shadowColor: Colors.teal[300],
                  ),
                  child: Text("Add")),
            ],
          ),
        ),
      );
  }
}