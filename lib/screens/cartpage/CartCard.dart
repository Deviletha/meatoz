import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meatoz/Components/itemname_text.dart';
import '../../theme/colors.dart';

class CartTile extends StatelessWidget {
  final String itemName;
  final String quantity;
  final String totalPrice;
  final String imagePath;
  final String description;

  // final color;
  final void Function()? onPressed;
  final void Function()? onPressedAdd;
  final void Function()? onPressedLess;

  const CartTile(
      {Key? key,
      required this.itemName,
      required this.imagePath,
      // this.color,
      required this.onPressed,
      required this.onPressedAdd,
      required this.onPressedLess,
      required this.totalPrice,
      required this.quantity,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    size: Size.fromRadius(60), // Image radius
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
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ItemName(
                      text: itemName,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      description,
                      maxLines: 3,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "₹$totalPrice",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(ColorT.themeColor),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            children: [
                              Container(
                                color: Colors.grey,
                                child: IconButton(
                                    onPressed: onPressedLess,
                                    icon: Icon(
                                      Iconsax.minus,
                                      size: 15,
                                    )),
                              ),
                              SizedBox(
                                width: 50,
                                child: Text(
                                  quantity,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                color: Colors.grey,
                                child: IconButton(
                                    onPressed: onPressedAdd,
                                    icon: Icon(
                                      Iconsax.add,
                                      size: 15,
                                    )),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: onPressed,
                          icon: Icon(
                            Iconsax.trash,
                            size: 25,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
