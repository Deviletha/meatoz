import 'package:flutter/material.dart';

class AccountCustomTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color; // Nullable Color
  final void Function()? onTap;

  const AccountCustomTile({
    Key? key,
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, size: 20), // Use the IconData for the Icon widget
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
