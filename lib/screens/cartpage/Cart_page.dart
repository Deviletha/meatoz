import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meatoz/screens/cartpage/CartCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/Title_widget.dart';
import '../../Components/appbar_text.dart';
import '../../Components/text_widget.dart';
import '../../Config/ApiHelper.dart';
import '../registration/Login_page.dart';
import '../placeOrder/Select_address.dart';

class Cart_page extends StatefulWidget {
  const Cart_page({Key? key}) : super(key: key);

  @override
  State<Cart_page> createState() => _Cart_pageState();
}

class _Cart_pageState extends State<Cart_page> {
  String? base = "https://meatoz.in/basicapi/public/";

  ///CartList
  Map? clist;
  List? CartList;
  int index = 0;
  var CID;
  String? UID;
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
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
    setState(() {
      isLoading = true;
    });

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
        CartList = clist!["cart"];
      });
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
        CartList = clist!["cart"];
      });
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
        CartList = clist!["cart"];

        Fluttertoast.showToast(
          msg: "Item Removed",
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
                            Lottie.network(
                                "https://lottie.host/32c20b57-b386-4604-bdcb-5bc24906185d/0a3h1oSkk5.json",
                                height: 300,
                                repeat: false),
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
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(10)),
                                        )),
                                    child: Text("Place Order"))
                              ],
                            ),
                          ),
                          GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: .65,
                            ),
                            itemCount: CartList?.length ?? 0,
                            itemBuilder: (context, index) => getCartList(index),
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
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

  Widget getCartList(int index) {
    var image = base! + CartList![index]["image"].toString();
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
