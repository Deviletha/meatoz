import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/text_widget.dart';

class CategoryViewTile extends StatefulWidget {
  final String ItemName;
  final String Description;
  final String TotalPrice;
  final String OfferPrice;
  final String ImagePath;
  final String combinationId;
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
    required this.TotalPrice, required this.combinationId})
      : super(key: key);

  @override
  State<CategoryViewTile> createState() => _CategoryViewTileState();
}

class _CategoryViewTileState extends State<CategoryViewTile> {
  String WID="NO";
  @override
  Widget build(BuildContext context) {
    // check(widget.combinationId);
    return
      Padding(
        padding:  EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(clipBehavior: Clip.antiAlias,decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),color: Colors.white
                ),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: CachedNetworkImage(
                    imageUrl: widget.ImagePath,
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
                  text: widget.ItemName,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹${widget.TotalPrice}",
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
                       "₹ ${widget.OfferPrice}",
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
                 widget.Description,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed:
                          widget.onPressed,
                          icon :  WID=="NO"?
                          Icon(
                            Iconsax.heart,
                            color: Colors.black,
                            size: 25,
                          ):Icon(
                            Iconsax.heart5,
                            color: Colors.red,
                            size: 25,
                          )
                      ),
                      ElevatedButton(
                        onPressed: widget.onPressed1,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[900],
                          shadowColor: Colors.teal[300],
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
  // Future<void> check(String id) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     WID = prefs.getString(id)!;
  //   });
  //
  // }
}