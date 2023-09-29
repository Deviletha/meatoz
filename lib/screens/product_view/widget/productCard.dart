import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/Components/text_widget.dart';

class ProductViewTile extends StatelessWidget {
  final String ItemName;
  final String Description;
  final String noOfPiece;
  final String servingCaapcity;
  final String Price;
  final String ImagePath;
  final color;
  void Function()? onPressed;

  ProductViewTile(
      {Key? key,
      required this.ItemName,
      required this.ImagePath,
      this.color,
      required this.onPressed,
      required this.Price,
      required this.Description,
      required this.noOfPiece,
      required this.servingCaapcity})
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
              height: 15,
            ),
            Text(
              "₹${Price}",
              style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            TextConst(
              text: ItemName,
            ),
            SizedBox(
              height: 10,
            ),
            TextConst(text: "No of Piece: $noOfPiece"),
            SizedBox(
              height: 10,
            ),
            TextConst(text: "Serving Capacity: $servingCaapcity"),
            SizedBox(
              height: 10,
            ),
            TextConst(
              text: Description,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[900],
                    shadowColor: Colors.teal[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                    )),
                child: Text("Add to Cart"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
