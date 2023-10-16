import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/Components/text_widget.dart';

import '../../../Components/discriptiontext.dart';
import '../../../theme/colors.dart';

class ProductViewTile extends StatelessWidget {
  final String itemName;
  final String description;
  final String noOfPiece;
  final String servingCapacity;
  final String price;
  final String imagePath;
  // final color;
  final void Function()? onPressed;

  const ProductViewTile(
      {Key? key,
      required this.itemName,
      required this.imagePath,
      // this.color,
      required this.onPressed,
      required this.price,
      required this.description,
      required this.noOfPiece,
      required this.servingCapacity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
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
                      image: DecorationImage(
                          image: AssetImage("assets/noItem.png"))),
                ),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "₹$price",
              style: TextStyle(
                  color: Color(ColorT.themeColor),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextConst(
              text: itemName,
            ),
            SizedBox(
              height: 5,
            ),
            TextConst(text: "No of Piece: $noOfPiece"),
            SizedBox(
              height: 5,
            ),
            TextConst(text: "Serving Capacity: $servingCapacity"),
            SizedBox(
              height: 5,
            ),
        TextDescription(text:description,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(ColorT.themeColor),
                    shadowColor: Colors.teal[300],),
                child: Text("Add"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
