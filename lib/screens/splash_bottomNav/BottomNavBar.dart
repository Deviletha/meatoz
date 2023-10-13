import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meatoz/Components/alertbox_text.dart';
import 'package:meatoz/screens/wishlist/wishlist_page.dart';
import '../cartpage/Cart_page.dart';
import '../accounts/Account_page.dart';
import '../category/category_page.dart';
import '../homepage/homepage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectIndex = 0;

  List body = <Widget>[ HomePage(), CategoryPage(),  Accounts(),CartPage()];

  void onItemTapped(int index) {
    setState(() {
      selectIndex = index;
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
            child:  AlertText(text: 'No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:  AlertText(text: 'Yes'),
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
          onTap: onItemTapped,
          currentIndex: selectIndex,
          backgroundColor: Colors.teal[900],
          elevation: 0,
          items: [
            FloatingNavbarItem(icon: Iconsax.home, title: "MEATOZ"),
            FloatingNavbarItem(icon: Iconsax.box, title: "CATEGORIES"),
            FloatingNavbarItem(icon: Iconsax.profile_circle, title: "PROFILE"),
            FloatingNavbarItem(icon: Iconsax.shopping_bag, title: "MY CART"),
          ],
        ),
        body: body.elementAt(selectIndex),
      ),
    );
  }
}
