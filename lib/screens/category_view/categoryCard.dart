import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Components/text_widget.dart';

class CategoryViewTile extends StatelessWidget {
  final String ItemName;
  final String Description;
  final String TotalPrice;
  final String OfferPrice;
  final String ImagePath;
  final color;
  void Function()? onPressed;
  void Function()? onPressed1;

  CategoryViewTile({Key? key,
    required this.ItemName,
    required this.ImagePath,
    this.color,
    required this.onPressed,
    required this.onPressed1,
    required this.OfferPrice,
    required this.Description,
    required this.TotalPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.teal.shade50, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(clipBehavior: Clip.antiAlias,decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),color: Colors.white
                ),
                  width: double.infinity,
                  height: 150,
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
                ),TextConst(
                  text: ItemName,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹${TotalPrice}",
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationStyle: TextDecorationStyle.solid,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 20
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                       "₹ ${OfferPrice}",
                      style: TextStyle(
                          color: Colors.green,fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                TextConst(text:
                 Description,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly
                    ,
                    children: [
                      ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[900],
                          shadowColor: Colors.teal[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                        child: Icon(Icons.favorite_sharp),
                      ),
                      ElevatedButton(
                        onPressed: onPressed1,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[900],
                          shadowColor: Colors.teal[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                          ),
                        ),
                        child: Text("Add to Cart"),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }
}