import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meatoz/Components/discriptiontext.dart';

import '../../Components/text_widget.dart';

class WishlistTile extends StatelessWidget {
  final String itemName;
  final String description;
  final String totalPrice;
  final String imagePath;
  // final color;
  final void Function()? onPressed;
  final void Function()? onTap;

  const WishlistTile({Key? key,
    required this.itemName,
    required this.imagePath,
    // this.color,
    required this.onPressed,
    required this.onTap,
    required this.totalPrice,
    required this.description
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          onTap: onTap,
          title: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                          placeholder: (context, url) =>
                              Container(
                                color: Colors.grey[300],
                              ),
                          errorWidget: (context, url, error) =>
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/noItem.png"))),
                              ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [SizedBox(
                        height: 10,
                      ),
                       TextConst(text:
                       itemName
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextDescription(text: description,),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          totalPrice,
                          style:  TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.teal.shade800),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Iconsax.trash, size: 25, color: Colors.red,
            ),
          )),
    );
  }
}