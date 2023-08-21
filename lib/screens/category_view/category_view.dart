import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meatoz/screens/category_view/categoryCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';

class Category_View extends StatefulWidget {
  final String itemname;
  final String description;
  final String price;
  final String url;
  final int id;

  const Category_View({
    Key? key,
    required this.itemname,
    required this.description,
    required this.price,
    required this.url,
    required this.id,
  }) : super(key: key);

  @override
  State<Category_View> createState() => _Category_ViewState();
}

class _Category_ViewState extends State<Category_View> {
  String? base = "https://meatoz.in/basicapi/public/";

  Map? prcategorylist;
  List? FinalClist;
  int index = 0;
  Map? clist;
  List? CartList;
  String? PRODUCTID;
  String? PRODUCTNAME;
  String? PRICE;
  String? PSIZE;
  String? COMBINATIONID;

  List<dynamic>? wscategorylist;
  bool isLoading = false;
  String? UID;
  String? data;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
  }

  addTowishtist(String id, String combination) async {
    var response = await ApiHelper().post(
      endpoint: "wishList/add",
      body: {
        "userid": UID,
        "productid": id,
        "combination": combination,
      },
    ).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('addwishlist api successful:');
        data = response.toString();
        wscategorylist = jsonDecode(data!) as List<dynamic>?;

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

  addToCart(String PrID, String PrName, String PrPrice, String Psize,
      String CombID) async {
    var response = await ApiHelper().post(endpoint: "cart/add", body: {
      "userid": UID,
      "productid": PrID,
      "product": PrName,
      "price": PrPrice,
      "quantity": "1",
      "psize": Psize,
      "combination_id": CombID
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        clist = jsonDecode(response);
        CartList = clist!["cart"];

        Fluttertoast.showToast(
          msg: "Item added to Cart",
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

  ApiforProductsBycategory() async {
    var response = await ApiHelper().post(
      endpoint: "categories/getProducts",
      body: {
        "id": widget.id.toString(),
      },
    ).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        prcategorylist = jsonDecode(response);
        FinalClist = prcategorylist!["products"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  void initState() {
    super.initState();
    ApiforProductsBycategory();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: widget.itemname,
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: FinalClist?.length ?? 0,
                    itemBuilder: (context, index) => getCatView(index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCatView(int index) {
    var image = base! + FinalClist![index]["image"].toString();
    var PID = FinalClist![index]["id"].toString();
    var CombID = FinalClist![index]["combinationId"].toString();

    return CategoryViewTile(
        ItemName: FinalClist![index]["name"].toString(),
        ImagePath: image,
        onPressed: () {
          addTowishtist(PID, CombID);
        },
        onPressed1: () {
          PRODUCTID = FinalClist![index]["id"].toString();
          PRODUCTNAME = FinalClist![index]["name"].toString();
          PRICE = FinalClist![index]["offerPrice"].toString();
          COMBINATIONID = FinalClist![index]["combinationId"].toString();
          PSIZE = FinalClist![index]["size_attribute_name"].toString();
          addToCart(PRODUCTID!, PRODUCTNAME!, PRICE!, PSIZE!, COMBINATIONID!);
        },
        OfferPrice: FinalClist![index]["offerPrice"].toString(),
        Description: FinalClist![index]["description"].toString(),
        TotalPrice: FinalClist![index]["totalPrice"].toString());
  }
}
