import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/ApiHelper.dart';
import '../constants/appbar_text.dart';
import '../constants/text_widget.dart';
import 'Login_page.dart';

class ProductView extends StatefulWidget {
  final String productname;
  final String url;
  final String description;
  final String amount;
  final String id;
  final String combinationId;
  final String quantity;
  final String category;
  final String psize;

  ProductView(
      {Key? key,
      required this.productname,
      required this.url,
      required this.description,
      required this.amount,
      required this.id,
      required this.combinationId,
      required this.quantity,
      required this.category,
      required this.psize})
      : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {

  int index = 0;
  Map? clist;
  List? CartList;
  String? UID;

  @override
  void initState() {
    checkUser();
    super.initState();
  }
  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
  }

  APIforCart() async {
    var response = await ApiHelper().post(endpoint: "cart/add", body: {
      "userid": UID,
      "productid": widget.id.toString(),
      "product": widget.productname.toString(),
      "price": widget.amount.toString(),
      "quantity": "1",
      "tax": "tax",
      "category": widget.category.toString(),
      "size": "size",
      "psize": widget.psize.toString(),
      "pcolor": "pcolor",
      "combination": widget.combinationId.toString()
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

  Future<void> checkLoggedIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginId = prefs.getString('UID');

    if (loginId != null && loginId.isNotEmpty) {
      // User is logged in, proceed with adding to cart
      APIforCart();
    } else {
      // User is not logged in, navigate to LoginPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.teal[900],
      appBar: AppBar(
        title: AppText( text: widget.productname,),
        backgroundColor: Colors.teal[900],
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          color: Colors.blueGrey[100]
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(clipBehavior: Clip.antiAlias,
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(color: Colors.white,
                  borderRadius: BorderRadius.circular(15),),// Image border// Image radius
                    child: CachedNetworkImage(
                      imageUrl: widget.url,
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
              ),
              TextConst(text:
                widget.amount.toString(),
              ),
              SizedBox(
                height: 15,
              ),
              TextConst(text:
                widget.productname.toString(),
              ),
              SizedBox(
                height: 15,
              ),
              TextConst(text:
                widget.description.toString(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  onPressed: () {
                    checkLoggedIn(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[900],
                      shadowColor: Colors.teal[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                      )),
                  child: Text("Add to Cart"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
