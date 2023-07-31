import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/screens/wishlist/wishlist_page.dart';
import '../cartpage/Cart_page.dart';
import '../accounts/Account_page.dart';
import '../homepage/homepage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectindex = 0;

  List body = <Widget>[const HomePage(), Wishlist(),  Accounts(),Cart_page()];

  void onitemtapped(int index) {
    setState(() {
      selectindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: FloatingNavbar(
        onTap: onitemtapped,
        currentIndex: selectindex,
        backgroundColor: Colors.teal[900],
        elevation: 0,
        items: [
          FloatingNavbarItem(icon: Icons.home_outlined, title: "MEATOZ"),
          FloatingNavbarItem(icon: Icons.favorite_border_sharp, title: "WISHLIST"),
          FloatingNavbarItem(icon: Icons.person_outline, title: "PROFILE"),
          FloatingNavbarItem(icon: Icons.shopping_bag_outlined, title: "MY CART"),
        ],
      ),
      body: body.elementAt(selectindex),
    );
  }
}
