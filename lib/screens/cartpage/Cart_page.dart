import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meatoz/screens/cartpage/CartCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/title_widget.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';
import '../placeOrder/widget/offer_card.dart';
import '../registration/Login_page.dart';
import '../placeOrder/Select_address.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ///CartList
  Map? cList;
  List? cartList;
  List? cartDiscountList;
  int index = 0;

  String? uID;
  bool isLoading = true;
  bool isLoggedIn = true;

  String? discountType;
  String? discountId;
  String? productId;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  bool _isApplied = false;

  void _onApplyButtonPressed() {
    // Call the apiForDiscounts() function here or perform any other actions
    apiForDiscounts();
    // Update the state to toggle the button text
    setState(() {
      _isApplied = true;
    });
  }

  apiForDiscounts() async {
    var responseDiscount = await ApiHelper().post(
      endpoint: "discount/applyDiscountAtCart",
      body: {
        "user_id": uID,
        "discount_id": discountId,
        "product_id": productId
      },
    ).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (responseDiscount != null) {
      setState(() {
        debugPrint('Apply discount api successful:');

        // print("apply discount response: " + responseDiscount);

        Map<String, dynamic> responseData = json.decode(responseDiscount);

        if (responseData.containsKey('discountAmount')) {
          Map<String, dynamic> discountAmount = responseData['discountAmount'];

          if (discountAmount['status'] != null && discountAmount['status'] == false) {
            Fluttertoast.showToast(
              msg: "Offer is not available for you",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }
      });
    } else {
      debugPrint('discount api failed:');
    }
  }


  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
    setState(() {
      isLoggedIn = uID != null;
    });
    if (isLoggedIn) {
      apiForCart();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  apiForCart() async {
    var response = await ApiHelper().post(endpoint: "cart/get", body: {
      "userid": uID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        cList = jsonDecode(response);
        cartList = cList!["cart"];
        cartDiscountList = cList!["cartDiscountsData"];

        if (cartDiscountList != null && cartDiscountList!.isNotEmpty) {
          String discountBy = cartDiscountList![index]["discount_by"];
          if (discountBy == "percentage") {
            discountType = "%";
          } else if (discountBy == "amount") {
            discountType = "/-";
          }
        }
        if (cartList != null && cartList!.isNotEmpty) {
          if (cartDiscountList != null && cartDiscountList!.isNotEmpty) {
            productId = cartDiscountList![index]["productID"].toString();
            discountId = cartDiscountList![index]["id"].toString();
          } else {
            discountId = "0";
          }
        }
        // print(discountId);
        // print(productId);

      });
    } else {
      debugPrint('api failed:');
    }
  }

  incrementQty(
    String cartID,
  ) async {
    var response = await ApiHelper().post(endpoint: "cart/increment", body: {
      "userid": uID,
      "cart_id": cartID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
      });
      apiForCart();
    } else {
      debugPrint('api failed:');
    }
  }

  decrementQty(String cartId) async {
    var response = await ApiHelper().post(endpoint: "cart/decrement", body: {
      "userid": uID,
      "cart_id": cartId,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
      });
      apiForCart();
    } else {
      debugPrint('api failed:');
    }
  }

  removeFromCart(String cartID) async {
    var response = await ApiHelper().post(endpoint: "cart/remove", body: {
      "userid": uID,
      "cart_id": cartID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cart page successful:');

        Fluttertoast.showToast(
          msg: "Item Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
      apiForCart();
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText(
          text: "MY CART",
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
            ])),
        child: isLoggedIn
            ? isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Colors.teal[900]),
                  )
                : cartList == null || cartList!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset("assets/Emptycart.json",
                                height: 300, repeat: false),
                            Heading(text: "Empty Cart")
                          ],
                        ),
                      )
                    : ListView(
                        children: [
                          Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${cartList!.length} Items in Cart",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
                                    onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return SetectAddress();
                                          }),
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal[900],
                                      shadowColor: Colors.teal[300],
                                    ),
                                    child: Text("Place Order"))
                              ],
                            ),
                          ),
                          ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartList == null ? 0 : cartList?.length ?? 0,
                            itemBuilder: (context, index) => getCartList(index),
                          ),
                          // GridView.builder(
                          //   gridDelegate:
                          //       const SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount: 2,
                          //     childAspectRatio: .54,
                          //   ),
                          //   itemCount: CartList?.length ?? 0,
                          //   itemBuilder: (context, index) => getCartList(index),
                          //   physics: ScrollPhysics(),
                          //   shrinkWrap: true,
                          // ),
                          if (cartDiscountList != null &&
                              cartDiscountList!.isNotEmpty &&
                              cartDiscountList![0]["discountAvailable"] == 1)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OfferCard(
                                title: cartDiscountList![index]["title"] ?? ""
                                    .toString(),
                                description: "${cartDiscountList![index]
                                ["discount_value"]}${discountType!} Discount",
                                image: "assets/offeratcart.png",
                                onPressed: _isApplied ? null : _onApplyButtonPressed,
                                isApplied: _isApplied, // Pass the isApplied value to OfferCard
                              ),
                            ),
                        ],
                      )
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget getCartList(int index) {
    var image = UrlConstants.base + cartList![index]["image"].toString();
    int quantity = cartList![index]["quantity"];
    int price = cartList![index]["price"];
    int totalAmount = quantity * price;
    return CartTile(
      itemName: cartList![index]["product"].toString(),
      imagePath: image,
      onPressedLess: () {
        decrementQty(
          cartList![index]["id"].toString(),
        );
      },
      quantity: cartList![index]["quantity"].toString(),
      onPressedAdd: () {
        incrementQty(
          cartList![index]["id"].toString(),
        );
      },
      totalPrice: totalAmount.toString(),
      onPressed: () {
        removeFromCart(
          cartList![index]["id"].toString(),
        );
      },
    );
  }
}
