import 'package:flutter/material.dart';

class AppliedOfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  void Function()? onPressed;

  AppliedOfferCard({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white),
        boxShadow: [BoxShadow(color: Colors.grey.shade500,blurRadius: 3,),],
        color: Colors.green[50],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                image,
                height: 40,
                width: 60,
              ),
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    description,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 90,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: Colors.teal[900],
            ),
            child: TextButton(
              onPressed: onPressed,
              child: Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
