import 'package:flutter/material.dart';
import 'package:meatoz/screens/wishlist_page.dart';
import 'Cart_page.dart';
import 'Account_page.dart';
import 'homepage.dart';

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
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          selectedFontSize: 15,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.teal[900],
          unselectedItemColor: Colors.teal[100],
          selectedItemColor: Colors.white,
          elevation: 0,
          iconSize: 25,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "MEATOZ",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_sharp),
              label: "WISHLIST",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "PROFILE",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: "MY CART",
            ),
          ],
          currentIndex: selectindex,
          onTap: onitemtapped,
        ),
      ),
      body: body.elementAt(selectindex),
    );
  }
}
