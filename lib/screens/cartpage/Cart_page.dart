import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/Title_widget.dart';
import '../../Components/appbar_text.dart';
import '../../Components/text_widget.dart';
import '../../Config/ApiHelper.dart';
import '../Login_page.dart';
import '../Select_address.dart';

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
        title: AppText(text: "MY CART",),
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
            : CartList == null || CartList!.isEmpty
            ? Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.network(
                "https://lottie.host/32c20b57-b386-4604-bdcb-5bc24906185d/0a3h1oSkk5.json",
                height: 300,
                repeat: false
              ),
              Heading(text: "Empty Cart")
            ],
          ),
        )
            : ListView(
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
            )
            : Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("assets/logo1.png",height: 80,),
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
      ),
    );
  }

  Widget getCartList(int index) {
    var image = base! + CartList![index]["image"].toString();
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
              "₹$totalamount",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      decrementQty(
                        CartList![index]["id"].toString(),
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
                        CartList![index]["id"].toString(),
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
                    backgroundColor: Colors.red[900],
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
