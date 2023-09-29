import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('Are you sure?'),
        content:  Text('Do you want to exit App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:  Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        bottomNavigationBar: FloatingNavbar(
          onTap: onitemtapped,
          currentIndex: selectindex,
          backgroundColor: Colors.teal[900],
          elevation: 0,
          items: [
            FloatingNavbarItem(icon: Iconsax.home, title: "MEATOZ"),
            FloatingNavbarItem(icon: Iconsax.heart, title: "WISHLIST"),
            FloatingNavbarItem(icon: Iconsax.profile_circle, title: "PROFILE"),
            FloatingNavbarItem(icon: Iconsax.shopping_bag, title: "MY CART"),
          ],
        ),
        body: body.elementAt(selectindex),
      ),
    );
  }
}
