import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/Components/text_widget.dart';

class RelatedItemTile extends StatelessWidget {
  final String ItemName;
  final String Price;
  final String ImagePath;
  final color;
  void Function()? onPressed;

  RelatedItemTile({Key? key,
    required this.ItemName,
    required this.ImagePath,
    this.color,
    required this.onPressed,
    required this.Price,
    })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox.fromSize(
                size: Size.fromHeight(90),
                child: CachedNetworkImage(
                  imageUrl: ImagePath,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/noItem.png"),
                      ),
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
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
            Text(
              Price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[900],
                  shadowColor: Colors.teal[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
                child: Text("Add")),
          ],
        ),
      );
  }
}