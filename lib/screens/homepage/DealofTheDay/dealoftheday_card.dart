
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Components/text_widget.dart';

class DealOfTheDayCard extends StatefulWidget {
  final String ItemName;
  final String Description;
  final String TotalPrice;
  final String OfferPrice;
  final String ImagePath;
  final String combinationId;
  final color;
  void Function()? onTap;
  void Function()? onPressed;

  DealOfTheDayCard({Key? key,
    required this.ItemName,
    required this.ImagePath,
    this.color,
    required this.onTap,
    required this.onPressed,
    required this.TotalPrice,
    required this.OfferPrice,
    required this.Description, required this.combinationId})
      : super(key: key);

  @override
  State<DealOfTheDayCard> createState() => _DealOfTheDayCardState();
}

class _DealOfTheDayCardState extends State<DealOfTheDayCard> {
  String WID="NO";
  @override
  Widget build(BuildContext context) {
    check(widget.combinationId);
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.teal.shade50, width: 1)),
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    width: double.infinity,
                    height:MediaQuery.of(context).size.height / 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    ),
                    // Image border// Image radius
                    child: CachedNetworkImage(
                      imageUrl: widget.ImagePath,
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

              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.TotalPrice,
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
                          widget.OfferPrice,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, shape: CircleBorder()),
                            onPressed: widget.onPressed,
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
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextConst(
                        text: widget.ItemName),
                    SizedBox(
                      height: 10,
                    ),
                    Text(widget.Description,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.teal[900],
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> check(String id) async {

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      WID = prefs.getString(id)!;
    });

  }
}