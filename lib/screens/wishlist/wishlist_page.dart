import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/Components/itemname_text.dart';
import 'package:meatoz/screens/wishlist/wishListCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/discriptiontext.dart';
import '../../Components/title_widget.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../cartpage/Cart_page.dart';
import '../registration/login_page.dart';

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
    var response = await ApiHelper().post(
        endpoint: "wishList/remove", body: {"id": id}).catchError((err) {});
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

  String? productId;
  String? productName;
  String? price1;
  String? pSize;
  String? combinationId;

  addToCart(String prID, String prName, String prPrice, String pSize,
      String combID) async {
    var response = await ApiHelper().post(endpoint: "cart/add", body: {
      "userid": uID,
      "productid": prID,
      "product": prName,
      "price": prPrice,
      "quantity": "1",
      "psize": pSize,
      "combination_id": combID
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cart page successful:');

        Fluttertoast.showToast(
          msg: "Item added to Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CartPage()), // Replace with your cart page
        );
      });
    } else {
      debugPrint('api failed:');
    }
  }

  void _showBottomSheet(BuildContext context, int index1) {
    var image = UrlConstants.base + finalPrList![index1]["image"].toString();

    var stock = finalPrList![index1]["stock"].toString();
    bool isStockAvailable = int.parse(stock) > 0;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                clipBehavior: Clip.antiAlias,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                // Image border// Image radius
                child: CachedNetworkImage(
                  imageUrl: image,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/noItem.png"))),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (isStockAvailable) {
                          productId = finalPrList![index1]["id"].toString();
                          productName = finalPrList![index1]["name"].toString();
                          price1 =
                              finalPrList![index1]["offerPrice"].toString();
                          combinationId =
                              finalPrList![index1]["combinationId"].toString();
                          pSize = finalPrList![index1]["size_attribute_name"]
                              .toString();
                          addToCart(productId!, productName!, price1!, pSize!,
                              combinationId!);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Product is out of stock!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.SNACKBAR,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(ColorT.themeColor),
                        shadowColor: Colors.teal[300],
                      ),
                      child: Text("Add"),
                    ),
                  ],
                ),
              ),
              ItemName(
                text: finalPrList![index1]["name"].toString(),
              ),
              SizedBox(
                height: 10,
              ),
              TextDescription(
                text: finalPrList![index1]["description"].toString(),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "₹${finalPrList![index1]["totalPrice"].toString()}",
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationStyle: TextDecorationStyle.solid,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "₹${finalPrList![index1]["offerPrice"].toString()}",
                    style: TextStyle(
                        color: Color(ColorT.themeColor),
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText(
          text: "Wishlist",
        ),
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
            ]
            )),
        child: isLoggedIn
            ? isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Colors.teal[900]),
                  )
                : finalPrList == null || finalPrList!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                "assets/wishlist-empty-removebg-preview (1).png"),
                            Heading(text: "No Fav Items")
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount:
                            finalPrList == null ? 0 : finalPrList?.length ?? 0,
                        itemBuilder: (context, index) => getWishlist(index),
                      )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/logo1.png",
                      height: 80,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[900],
                        shadowColor: Colors.teal[300],
                      ),
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
    var price = "₹${finalPrList![index]["offerPrice"]}";
    var actualPrice = "₹${finalPrList![index]["totalPrice"]}";
    return WishlistTile(
        actualPrice: actualPrice,
        itemName: finalPrList![index]["name"].toString(),
        imagePath: image,
        onPressed: () {
          removeFromWishList(finalPrList![index]["wishlistId"].toString());
          if (kDebugMode) {
            print(
              finalPrList![index]["wishlistId"].toString(),
            );
          }
        },
        onTap: () {
          _showBottomSheet(context, index);
        },
        totalPrice: price,
        description: finalPrList![index]["description"].toString());
  }
}
