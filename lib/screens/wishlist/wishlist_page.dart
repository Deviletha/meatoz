import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/screens/wishlist/wishListCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/Title_widget.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';
import '../registration/Login_page.dart';
import '../product_view/Product_view.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  String? UID;
  bool isLoading = true;
  bool isLoggedIn = true;
  GlobalKey<RefreshIndicatorState> refreshKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    setState(() {
      isLoggedIn = UID != null;
      print(UID);
    });
    if (isLoggedIn) {
      wishListGet();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String? base = "https://meatoz.in/basicapi/public/";
  Map? wslist;
  List? WsList;

  Map? prlist;
  Map? prlist1;
  List? Prlist;


  Future<void> wishListGet() async {
    var response = await ApiHelper().post(endpoint: "wishList/get", body: {
      "userid": UID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('wishlist api successful:');
        prlist = jsonDecode(response);
        prlist1 = prlist!["pagination"];
        Prlist = prlist1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  Future<void> removeFromWishtist(String id) async {
    var response = await ApiHelper().post(endpoint: "wishList/remove", body: {
      "id": id
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('Remove api successful:');
        prlist = jsonDecode(response);

        wishListGet();
        Fluttertoast.showToast(
          msg: "Removed product",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );

      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText(text: "WISHLIST",),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.grey.shade400,
                  Colors.grey.shade200,
                  Colors.grey.shade50,
                  Colors.grey.shade200,
                  Colors.grey.shade400,
                ])
        ),
        child: isLoggedIn
            ? isLoading
            ? Center(
          child: CircularProgressIndicator(color: Colors.teal[900]),
        )
            : Prlist == null || Prlist!.isEmpty
            ? Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/wishlist-empty-removebg-preview (1).png"),
              Heading(text: "No Fav Items")
            ],
          ),
        )
            : ListView.builder(
              itemCount: Prlist == null ? 0 : Prlist?.length ?? 0,
              itemBuilder: (context, index) => getWishlist(index),
            )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/logo1.png", height: 80,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage())
                  );
                }, style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[900],
                  shadowColor: Colors.teal[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                  )),
                child: Text(
                  "Please LogIn",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getWishlist(int index) {
    var image = base! + Prlist![index]["image"].toString();
    var price = "₹ " + Prlist![index]["offerPrice"].toString();
    var PID = (Prlist![index]["id"] ?? "").toString();
    var CombID = (Prlist![index]["combinationId"] ?? "").toString();
    return WishlistTile(
        ItemName: Prlist![index]["name"].toString(),
        ImagePath: image,
        onPressed: () {
              removeFromWishtist(Prlist![index]["wishlistId"].toString());
              print(Prlist![index]["wishlistId"].toString(),);
            },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
                serveCapacity: Prlist![index]["serving_cupacity"].toString(),
                noOfPiece: Prlist![index]["no_of_piece"].toString(),
                stock: Prlist![index]["stock"].toString(),
                recipe: "Recipe not available for this item",
                position: index,
                id: PID,
                productname:
                Prlist![index]["name"].toString(),
                url: image,
                description: Prlist![index]["description"].toString(),
                amount: Prlist![index]["offerPrice"].toString(),
                combinationId: CombID,
                psize: "0",
              ),
            ),
          );
        },
        TotalPrice: price,
        Description: Prlist![index]["description"].toString());
  }
}
