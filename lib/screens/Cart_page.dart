import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/constants/appbar_text.dart';
import 'package:meatoz/constants/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/ApiHelper.dart';
import 'Login_page.dart';
import 'Select_address.dart';

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
  ///CartIncrementList
  Map? incrlist;
  Map? FinalIncrementList;
  ///CartDecrementList
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
        incrlist = jsonDecode(response);
        FinalIncrementList = incrlist!["cart"];

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
        incrlist = jsonDecode(response);
        FinalIncrementList = incrlist!["cart"];

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
        title: AppText(text: "MY CART",),
        backgroundColor: Colors.teal[900],
        elevation: 10,
        centerTitle: true,
      ),
      body: isLoggedIn
          ? isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Container(
            child: ListView(
              children: [
                Card(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("${CartList!.length} Items in Cart",style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold
                      ),),
                      ElevatedButton(onPressed: () => Navigator.push(
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
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .65,
        ),
        itemCount: CartList?.length ?? 0,
        itemBuilder: (context, index) => getCartList(index),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
      ),
              ],
            ),
          )
          : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("assets/img_1.png"),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage())
                );
              },style: ElevatedButton.styleFrom(
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
    );
  }

  Widget getCartList(int index) {
    var image = base! + CartList![index]["image"];
    int quantity = CartList![index]["quantity"];
    int price = CartList![index]["price"];
    int totalamount = quantity * price;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  size: Size.fromRadius(71), // Image radius
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            CartList == null
                ? Text("null data")
                : TextConst(text:
                    CartList![index]["product"].toString(),
                  ),
            SizedBox(
              height: 10,
            ),
            Text(
              totalamount.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      decrementQty(
                        FinalIncrementList![index]["id"].toString(),
                      );
                    },
                    icon: Icon(Icons.remove_circle_outline_rounded)),
                TextButton(
                    onPressed: () {},
                    child: TextConst(text:
                      CartList![index]["quantity"].toString(),
                    )),
                IconButton(
                    onPressed: () {
                      incrementQty(
                        FinalIncrementList![index]["id"].toString(),
                      );
                    },
                    icon: Icon(Icons.add_circle_outline_rounded)),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  removeFromCart(
                    CartList![index]["id"].toString(),
                  );
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
                  "Remove Item",
                ))
          ],
        ),
      ),
    );
  }
}
