import 'package:flutter/material.dart';

class AccountCustomTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color; // Nullable Color
  void Function()? onTap;

  AccountCustomTile({
    Key? key,
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: Row(
            children: [
              Icon(icon, size: 25), // Use the IconData for the Icon widget
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
