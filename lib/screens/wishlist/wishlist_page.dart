import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/screens/wishlist/wishListCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/title_widget.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';
import '../registration/Login_page.dart';
import '../product_view/Product_view.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  String? uID;
  bool isLoading = true;
  bool isLoggedIn = true;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
    setState(() {
      isLoggedIn = uID != null;
      if (kDebugMode) {
        print(uID);
      }
    });
    if (isLoggedIn) {
      wishListGet();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Map? prList;
  Map? prList1;
  List? finalPrList;


  Future<void> wishListGet() async {
    var response = await ApiHelper().post(endpoint: "wishList/get", body: {
      "userid": uID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('wishlist api successful:');
        prList = jsonDecode(response);
        prList1 = prList!["pagination"];
        finalPrList = prList1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  Future<void> removeFromWishList(String id) async {
    var response = await ApiHelper().post(endpoint: "wishList/remove", body: {
      "id": id
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('Remove api successful:');

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
        title: AppText(text: "Wishlist",),
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
            : finalPrList == null || finalPrList!.isEmpty
            ? Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/wishlist-empty-removebg-preview (1).png"),
              Heading(text: "No Fav Items")
            ],
          ),
        )
            : ListView.builder(
              itemCount: finalPrList == null ? 0 : finalPrList?.length ?? 0,
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
                  shadowColor: Colors.teal[300],),
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
    var image = UrlConstants.base + finalPrList![index]["image"].toString();
    var price = "₹ ${finalPrList![index]["offerPrice"]}";
    var pId = (finalPrList![index]["id"] ?? "").toString();
    var combID = (finalPrList![index]["combinationId"] ?? "").toString();
    return WishlistTile(
        itemName: finalPrList![index]["name"].toString(),
        imagePath: image,
        onPressed: () {
          removeFromWishList(finalPrList![index]["wishlistId"].toString());
              if (kDebugMode) {
                print(finalPrList![index]["wishlistId"].toString(),);
              }
            },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
                serveCapacity: finalPrList![index]["serving_cupacity"].toString(),
                noOfPiece: finalPrList![index]["no_of_piece"].toString(),
                stock: finalPrList![index]["stock"].toString(),
                recipe: "Recipe not available for this item",
                position: index,
                id: pId,
                productName:
                finalPrList![index]["name"].toString(),
                url: image,
                description: finalPrList![index]["description"].toString(),
                amount: finalPrList![index]["offerPrice"].toString(),
                combinationId: combID,
                pSize: "0",
              ),
            ),
          );
        },
        totalPrice: price,
        description: finalPrList![index]["description"].toString());
  }
}
