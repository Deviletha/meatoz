import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Components/discriptiontext.dart';
import '../../Components/text_widget.dart';
import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../cartpage/Cart_page.dart';

class CategoryView extends StatefulWidget {
  final String itemName;
  final int id;

  const CategoryView({
    Key? key,
    required this.itemName,
    required this.id,
  }) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  Map? categoryList;
  List? finalCategoryList;
  int index = 0;

  String? productId;
  String? productName;
  String? price1;
  String? pSize;
  String? combinationId;

  bool isLoading = true;
  String? uID;
  String? data;

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

  removeFromWishList(String id) async {
    var response =
        await ApiHelper().post(endpoint: "wishList/removeByCombination", body: {
      "userid": uID,
      "product_id": id,
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add-wishlist api successful:');

        wishListGet();
        Fluttertoast.showToast(
          msg: "Removed from Wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('Remove wishlist failed:');
    }
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });

    wishListGet();
  }

  addToWishList(String id, String combId, String amount) async {
    var response = await ApiHelper().post(endpoint: "wishList/add", body: {
      "userid": uID,
      "productid": id,
      "combination": combId,
      "amount": amount
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add wishlist api successful:');
        // print(response);
        Fluttertoast.showToast(
          msg: "Added to Wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('Add to wishlist failed:');
    }
  }

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
          MaterialPageRoute(builder: (context) => CartPage()), // Replace with your cart page
        );
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForProductsByCategory() async {
    var response = await ApiHelper().post(
      endpoint: "categories/getProducts",
      body: {
        "id": widget.id.toString(),
      },
    ).catchError((err) {});
    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        categoryList = jsonDecode(response);
        finalCategoryList = categoryList!["products"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  void initState() {
    super.initState();
    apiForProductsByCategory();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: widget.itemName,
        ),
      ),
      body: isLoading ?
      Center(
        child: CircularProgressIndicator(
          color: Color(ColorT.themeColor),
        ),
      ):
      Container(
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
            ])),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Expanded(
                child:
                    finalCategoryList != null && finalCategoryList!.isNotEmpty
                        ? isLoading ?
                    Center(
                      child: CircularProgressIndicator(
                        color: Color(ColorT.themeColor),
                      ),
                    ): ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: finalCategoryList!.length,
                            itemBuilder: (context, index) => getCatView(index),
                          )
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "There are currently no items. Items will be available soon..!!",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCatView(int index1) {
    var image =
        UrlConstants.base + finalCategoryList![index1]["image"].toString();
    var price = finalCategoryList![index1]["offerPrice"].toString();
    var pId = finalCategoryList![index1]["id"].toString();
    var combId = finalCategoryList![index1]["combinationId"].toString();

    bool isInWishlist = finalPrList != null &&
        finalPrList!.any((item) => item['combinationId'].toString() == combId);
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    width: 90,
                    height: 70,
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "₹${finalCategoryList![index1]["totalPrice"].toString()}",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationStyle: TextDecorationStyle.solid,
                            color: Colors.grey.shade600,
                            fontSize: 15),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "₹ ${finalCategoryList![index1]["offerPrice"].toString()}",
                        style: TextStyle(
                            color: Colors.teal.shade800,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    TextConst(
                      text: finalCategoryList![index1]["name"].toString(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextDescription(
                        text:
                            finalCategoryList![index1]["description"].toString(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                              color: isInWishlist ? Colors.red : Colors.black,
                              size: 30,
                            ),
                            onPressed: () {
                              if (isInWishlist) {
                                removeFromWishList(combId);
                                wishListGet();
                              } else {
                                // The item is not in the wishlist, you may want to add it.
                                addToWishList(pId, combId, price);
                                wishListGet();
                              }
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              productId =
                                  finalCategoryList![index1]["id"].toString();
                              productName =
                                  finalCategoryList![index1]["name"].toString();
                              price1 = finalCategoryList![index1]["offerPrice"]
                                  .toString();
                              combinationId = finalCategoryList![index1]
                                      ["combinationId"]
                                  .toString();
                              pSize = finalCategoryList![index1]
                                      ["size_attribute_name"]
                                  .toString();
                              addToCart(productId!, productName!, price1!,
                                  pSize!, combinationId!);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(ColorT.themeColor),
                              shadowColor: Colors.teal[300],
                            ),
                            child: Text("Add"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
