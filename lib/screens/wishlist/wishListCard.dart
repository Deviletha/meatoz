import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Components/text_widget.dart';

class WishlistTile extends StatelessWidget {
  final String ItemName;
  final String Description;
  final String TotalPrice;
  final String ImagePath;
  final color;
  void Function()? onPressed;
  void Function()? onTap;

  WishlistTile({Key? key,
    required this.ItemName,
    required this.ImagePath,
    this.color,
    required this.onPressed,
    required this.onTap,
    required this.TotalPrice,
    required this.Description
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
                          imageUrl: ImagePath,
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
                        ItemName
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(Description,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.teal[900],
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          TotalPrice,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green),
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
          trailing: TextButton(
            onPressed: onPressed,
            child: Text(
              "Remove",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}