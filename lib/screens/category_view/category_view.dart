import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meatoz/screens/category_view/categoryCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';

// ignore: camel_case_types
class Category_View extends StatefulWidget {
  final String itemname;
  final int id;

  const Category_View({
    Key? key,
    required this.itemname,
    required this.id,
  }) : super(key: key);

  @override
  State<Category_View> createState() => _Category_ViewState();
}

class _Category_ViewState extends State<Category_View> {

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
  String? WID = "NO";

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
  }

  Future<void> check(String id, String PID) async {
    if (WID == "NO" || WID == null) {
      addwisH(id, "YES");
      addTowishtist(PID, id, context);
    } else {
      addwisH(id, "NO");
    }
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      WID = prefs.getString(id)!;
    });
  }

  addwisH(String wid, String v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(wid, v);
  }

  addTowishtist(String id, String combination, BuildContext context) async {
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
        // wscategorylist = jsonDecode(data!) as List?;

        print(response);

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
        // CartList = clist!["cart"];

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
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: FinalClist != null && FinalClist!.isNotEmpty
                    ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: FinalClist!.length,
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
    var image = UrlConstants.base + FinalClist![index1]["image"].toString();
    var PID = FinalClist![index1]["id"].toString();
    var CombID = FinalClist![index1]["combinationId"].toString();

    return CategoryViewTile(
      ItemName: FinalClist![index1]["name"].toString(),
      ImagePath: image,
      onPressed: () {
        check(CombID, PID);
      },
      onPressed1: () {
        PRODUCTID = FinalClist![index1]["id"].toString();
        PRODUCTNAME = FinalClist![index1]["name"].toString();
        PRICE = FinalClist![index1]["offerPrice"].toString();
        COMBINATIONID = FinalClist![index1]["combinationId"].toString();
        PSIZE = FinalClist![index1]["size_attribute_name"].toString();
        addToCart(PRODUCTID!, PRODUCTNAME!, PRICE!, PSIZE!, COMBINATIONID!);
      },
      OfferPrice: FinalClist![index1]["offerPrice"].toString(),
      Description: FinalClist![index1]["description"].toString(),
      TotalPrice: FinalClist![index1]["totalPrice"].toString(),
      combinationId: CombID,
    );
  }
}
