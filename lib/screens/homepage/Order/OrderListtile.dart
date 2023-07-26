import 'package:flutter/material.dart';
import '../../../../Components/text_widget.dart';

class OrderCard extends StatelessWidget {
  final String CartName;
  final String ImagePath;
  final color;
  void Function()? onTap;

  OrderCard({Key? key,
    required this.CartName,
    required this.ImagePath,
    this.color,
    required this.onTap,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          size: Size.fromRadius(40), // Image radius
                          child: Image.network(
                            ImagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             TextConst(
                              text: "Order Placed",
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextConst(
                              text: CartName,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
  }}