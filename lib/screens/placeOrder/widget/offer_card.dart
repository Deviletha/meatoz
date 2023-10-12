import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final bool isApplied;
  final void Function()? onPressed;

  const OfferCard({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.isApplied,
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
        color: isApplied ? Colors.green[50] : Colors.white, // Change color based on isApplied
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
              onPressed: isApplied ? null : onPressed,
              child: Text(
                isApplied ? "Applied" : "Apply Now",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
