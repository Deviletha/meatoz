import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/ApiHelper.dart';
import '../constants/appbar_text.dart';
import '../constants/text_widget.dart';

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

  List<dynamic>? wscategorylist;
  bool isLoading = false;
  String? UID;
  String? data;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
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
        title: AppText(text:
          widget.itemname,
        ),
        backgroundColor: Colors.teal[900],
        elevation: 10,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Center(
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
    );
  }

  Widget getCatView(int index) {
    var image = base! + FinalClist![index]["image"].toString();
    var PID = FinalClist![index]["id"].toString();
    var CombID = FinalClist![index]["combinationId"].toString();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey[100], borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(clipBehavior: Clip.antiAlias,decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),color: Colors.white
              ),
                width: double.infinity,
                height: 150,
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
                height: 15,
              ),TextConst(
                text: FinalClist == null
                    ? 'Loading...'
                    : FinalClist![index]["name"].toString(),
              ),
              SizedBox(
                height: 15,
              ),
              TextConst(text:
                FinalClist == null
                    ? 'Loading...'
                    : FinalClist![index]["totalPrice"].toString(),
              ),
              SizedBox(
                height: 15,
              ),
              TextConst(text:
                FinalClist == null
                    ? 'Loading...'
                    : FinalClist![index]["description"].toString(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    addTowishtist(PID, CombID);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[900],
                    shadowColor: Colors.teal[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Icon(Icons.favorite_sharp),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
