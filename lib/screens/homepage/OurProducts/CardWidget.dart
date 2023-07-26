import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../Components/text_widget.dart';

class OurProductCard extends StatelessWidget {
  final String ItemName;
  final String Description;
  final String TotalPrice;
  final String OfferPrice;
  final String ImagePath;
  final color;
  void Function()? onTap;
  void Function()? onPressed;

  OurProductCard({Key? key,
    required this.ItemName,
    required this.ImagePath,
    this.color,
    required this.onTap,
    required this.onPressed,
    required this.TotalPrice,
    required this.OfferPrice,
    required this.Description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.teal.shade50, width: 1)),
          child: InkWell(
            onTap: onTap,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                      ),
                      // Image border// Image radius
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
                    Positioned(
                      top: 10,
                      left: 140,
                      child: ElevatedButton(
                        onPressed:
                          onPressed,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: CircleBorder(
                            )
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.teal[900],
                          size: 25,
                        ),
                      ),)
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextConst(
                          text: ItemName),
                      SizedBox(
                        height: 10,
                      ),
                      Text(Description,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.teal[900],
                              fontWeight: FontWeight.bold)),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            TotalPrice,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            OfferPrice,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}