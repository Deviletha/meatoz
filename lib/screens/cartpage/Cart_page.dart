import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meatoz/screens/cartpage/CartCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/Title_widget.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';
import '../placeOrder/widget/offer_card.dart';
import '../registration/Login_page.dart';
import '../placeOrder/Select_address.dart';

class Cart_page extends StatefulWidget {
  const Cart_page({Key? key}) : super(key: key);

  @override
  State<Cart_page> createState() => _Cart_pageState();
}

class _Cart_pageState extends State<Cart_page> {
  ///CartList
  Map? clist;
  List? CartList;
  List? cartDiscountList;
  int index = 0;
  var CID;
  String? UID;
  bool isLoading = true;
  bool isLoggedIn = true;

  String? discountType;
  String? DISCOUNTID;
  String? PRODUCTID;

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
        "user_id": UID,
        "discount_id": DISCOUNTID,
        "product_id": PRODUCTID
      },
    ).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (responseDiscount != null) {
      setState(() {
        debugPrint('Apply discount api successful:');
        print("apply discount response: " + responseDiscount);

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
    UID = prefs.getString("UID");
    setState(() {
      isLoggedIn = UID != null;
    });
    if (isLoggedIn) {
      APIforCart();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  APIforCart() async {
    var response = await ApiHelper().post(endpoint: "cart/get", body: {
      "userid": UID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        clist = jsonDecode(response);
        CartList = clist!["cart"];
        cartDiscountList = clist!["cartDiscountsData"];

        if (cartDiscountList != null && cartDiscountList!.isNotEmpty) {
          String discountBy = cartDiscountList![index]["discount_by"];
          if (discountBy == "percentage") {
            discountType = "%";
          } else if (discountBy == "amount") {
            discountType = "/-";
          }
        }
        if (CartList != null && CartList!.isNotEmpty) {
          if (cartDiscountList != null && cartDiscountList!.isNotEmpty) {
            PRODUCTID = cartDiscountList![index]["productID"].toString();
            DISCOUNTID = cartDiscountList![index]["id"].toString();
          } else {
            DISCOUNTID = "0";
          }
        }
        print(DISCOUNTID);
        print(PRODUCTID);

      });
    } else {
      debugPrint('api failed:');
    }
  }

  incrementQty(
    String cartID,
  ) async {
    var response = await ApiHelper().post(endpoint: "cart/increment", body: {
      "userid": "93",
      "cart_id": cartID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        clist = jsonDecode(response);
      });
      APIforCart();
    } else {
      debugPrint('api failed:');
    }
  }

  decrementQty(String cartId) async {
    var response = await ApiHelper().post(endpoint: "cart/decrement", body: {
      "userid": UID,
      "cart_id": cartId,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        clist = jsonDecode(response);
      });
      APIforCart();
    } else {
      debugPrint('api failed:');
    }
  }

  removeFromCart(String cartID) async {
    var response = await ApiHelper().post(endpoint: "cart/remove", body: {
      "userid": UID,
      "cart_id": cartID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        clist = jsonDecode(response);

        Fluttertoast.showToast(
          msg: "Item Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
      APIforCart();
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
                : CartList == null || CartList!.isEmpty
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
                                  "${CartList!.length} Items in Cart",
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
                            itemCount: CartList == null ? 0 : CartList?.length ?? 0,
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
    var image = UrlConstants.base + CartList![index]["image"].toString();
    int quantity = CartList![index]["quantity"];
    int price = CartList![index]["price"];
    int totalamount = quantity * price;
    return CartTile(
      ItemName: CartList![index]["product"].toString(),
      ImagePath: image,
      onPressedLess: () {
        decrementQty(
          CartList![index]["id"].toString(),
        );
      },
      Quantity: CartList![index]["quantity"].toString(),
      onPressedAdd: () {
        incrementQty(
          CartList![index]["id"].toString(),
        );
      },
      TotalPrice: totalamount.toString(),
      onPressed: () {
        removeFromCart(
          CartList![index]["id"].toString(),
        );
      },
    );
  }
}
