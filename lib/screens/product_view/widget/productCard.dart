import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/Components/text_widget.dart';

import '../../../Components/discriptiontext.dart';
import '../../../Components/itemname_text.dart';
import '../../../theme/colors.dart';

class ProductViewTile extends StatelessWidget {
  final String itemName;
  final String description;
  final String? noOfPiece;
  final String? servingCapacity;
  final String price;
  final String actualPrice;
  final String imagePath;
  final void Function()? onPressed;

  const ProductViewTile(
      {Key? key,
      required this.itemName,
      required this.imagePath,
      required this.onPressed,
      required this.price,
      required this.description,
      this.noOfPiece,
      this.servingCapacity,
      required this.actualPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            // Row(mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     ElevatedButton(
            //       onPressed: onPressed,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Color(ColorT.themeColor),
            //         shadowColor: Colors.teal[300],),
            //       child: Text("Add"),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 10,
            ),
            ItemName(
              text: itemName,
            ),
            SizedBox(
              height: 5,
            ),
            TextDescription(
              text: description,
            ),
            SizedBox(
              height: 5,
            ),
            Visibility(
                visible: noOfPiece != "null",
                child: TextConst(text: "No of Piece: $noOfPiece")),
            SizedBox(
              height: 5,
            ),
            Visibility(
                visible: servingCapacity != "null",
                child: TextConst(text: "Serving Capacity: $servingCapacity")),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  actualPrice,
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationStyle: TextDecorationStyle.solid,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "₹$price",
                  style: TextStyle(
                      color: Color(ColorT.themeColor),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
