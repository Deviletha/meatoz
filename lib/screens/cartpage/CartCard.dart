import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../Components/text_widget.dart';

class CartTile extends StatelessWidget {
  final String ItemName;
  final String Quantity;
  final String TotalPrice;
  final String ImagePath;
  final color;
  void Function()? onPressed;
  void Function()? onPressedAdd;
  void Function()? onPressedLess;

  CartTile({Key? key,
    required this.ItemName,
    required this.ImagePath,
    this.color,
    required this.onPressed,
    required this.onPressedAdd,
    required this.onPressedLess,
    required this.TotalPrice,
    required this.Quantity
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(20), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(50), // Image radius
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
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  TextConst(text:
                  ItemName,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "₹$TotalPrice",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green),
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      IconButton(
                          onPressed: onPressedLess,
                          icon: Icon(Iconsax.minus_square,)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextConst(text:
                        Quantity,
                        ),
                      ),
                      IconButton(
                          onPressed: onPressedAdd,
                          icon: Icon(Iconsax.add_square,)),
                    ],
                  ),
                ],
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Iconsax.trash, size: 25, color: Colors.red,
                ),
              )
            ],
          ),
        ),
      );
  }
}