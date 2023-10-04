import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:meatoz/screens/product_view/widget/productCard.dart';
import 'package:meatoz/screens/product_view/widget/relatedItemsCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/Alertbox_text.dart';
import '../../Components/Title_widget.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';
import '../registration/Login_page.dart';

class ProductView extends StatefulWidget {
  final String productname;
  final String noOfPiece;
  final String serveCapacity;
  final String url;
  final String description;
  final String amount;
  final String id;
  final String combinationId;
  final String psize;
  final int position;
  final String recipe;
  final String stock;

  ProductView(
      {Key? key,
      required this.productname,
      required this.url,
      required this.description,
      required this.amount,
      required this.id,
      required this.combinationId,
      required this.psize,
      required this.position,
      required this.stock,
      required this.recipe, required this.noOfPiece, required this.serveCapacity})
      : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String? base = "https://meatoz.in/basicapi/public/";

  ///ProductList
  String? data;
  Map? productlist;
  Map? productlist1;
  List? Finalproductlist;
  List? RelatedPrdctList;

  bool isLoading = false;
  bool isLoadingProducts = true;

  int index = 0;
  Map? clist;
  List? CartList;
  String? UID;
  String? PRODUCTID;
  String? PRODUCTNAME;
  String? PRICE;
  String? PSIZE;
  String? COMBINATIONID;
  String? STOCK;

  @override
  void initState() {
    checkUser();
    ApiforAllProducts();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
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
        // clist = jsonDecode(response);
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


  Future<void> checkLoggedIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginId = prefs.getString('UID');

    if (loginId != null && loginId.isNotEmpty) {
      // User is logged in, proceed with adding to cart
      var response = await ApiHelper().post(endpoint: "cart/add", body: {
        "userid": UID,
        "productid": widget.id.toString(),
        "product": widget.productname.toString(),
        "price": widget.amount.toString(),
        "quantity": "1",
        "psize": widget.psize.toString(),
        "combination_id": widget.combinationId.toString()
      }).catchError((err) {});
      if (response != null) {
        setState(() {
          debugPrint('cartpage successful:');
          // clist = jsonDecode(response);
          // CartList = clist!["cart"];

          var stock = widget.stock.toString();
          bool isStockAvailable = int.parse(stock) > 0;

          if (isStockAvailable) {
            Fluttertoast.showToast(
                msg: "Item added to Cart",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            Fluttertoast.showToast(
                msg: "Product is out of stock!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        });
      } else {
        debugPrint('api failed:');
      }
    } else {
      // User is not logged in, navigate to LoginPage
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20), gapPadding: 20),
          elevation: 0,
          title: Text('Recipe'),
          content: Text(widget.recipe),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: AlertText(text: 'Close'),
            ),
          ],
        );
      },
    );
  }

  ApiforAllProducts() async {
    setState(() {
      isLoading = true;
    });

    var response =
        await ApiHelper().post(endpoint: "products/ByCombination", body: {
      "offset": "0",
      "pageLimit": "100",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        data = response.toString();
        productlist = jsonDecode(response);
        productlist1 = productlist!["pagination"];
        Finalproductlist = productlist1!["pageData"];
        RelatedPrdctList = Finalproductlist![widget.position]["relatedProduct"];
        print(RelatedPrdctList);
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: widget.productname,
        ),
        actions: [
          IconButton(
            onPressed: _showAlertDialog,
            icon: Icon(Icons.dining_outlined),
          ),
        ],
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
        child: ListView(
          children: [
            ProductViewTile(
                noOfPiece: widget.noOfPiece,
                servingCaapcity: widget.serveCapacity,
                ItemName: widget.productname.toString(),
                ImagePath: widget.url,
                onPressed: () {
                  checkLoggedIn(context);
                },
                Price: widget.amount,
                Description: widget.description.toString()),
            Heading(
              text: "Related Products",
            ),
            isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CarouselSlider.builder(
                      itemCount: RelatedPrdctList == null
                          ? 0
                          : RelatedPrdctList?.length,
                      itemBuilder: (context, index, realIndex) {
                        return getProducts(index);
                      },
                      options: CarouselOptions(
                        height: 230,
                        aspectRatio: 15 / 6,
                        viewportFraction: .45,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  )
                : CarouselSlider.builder(
                    itemCount:
                        RelatedPrdctList == null ? 0 : RelatedPrdctList?.length,
                    itemBuilder: (context, index, realIndex) {
                      return getProducts(index);
                    },
                    options: CarouselOptions(
                      height: 230,
                      aspectRatio: 15 / 6,
                      viewportFraction: .45,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      reverse: false,
                      autoPlay: true,
                      enlargeCenterPage: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      onPageChanged: (index, reason) {},
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget getProducts(int index) {
    if (RelatedPrdctList == null || RelatedPrdctList![index] == null) {
      return Container();
    }
    var image = base! + (RelatedPrdctList![index]["image"] ?? "").toString();
    var price = "₹${RelatedPrdctList![index]["offerPrice"] ?? ""}";

    var stock = RelatedPrdctList![index]["stock"];
    bool isStockAvailable = stock != null && int.parse(stock.toString()) > 0;

    return RelatedItemTile(
        ItemName: RelatedPrdctList![index]["name"].toString(),
        ImagePath: image,
        onPressed: () {
          if (isStockAvailable) {
            PRODUCTID = RelatedPrdctList![index]["productID"].toString();
            PRODUCTNAME = RelatedPrdctList![index]["name"].toString();
            PRICE = RelatedPrdctList![index]["offerPrice"].toString();
            PSIZE = RelatedPrdctList![index]["size_attribute_name"].toString();
            COMBINATIONID = RelatedPrdctList![index]["combinationid"].toString();
            addToCart(PRODUCTID!, PRODUCTNAME!, PRICE!, PSIZE!, COMBINATIONID!);
          } else {
            Fluttertoast.showToast(
                msg: "Product is out of stock!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.SNACKBAR,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        Price: price,
        );
  }
}
