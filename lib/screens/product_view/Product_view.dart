import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meatoz/screens/product_view/widget/productCard.dart';
import 'package:meatoz/screens/product_view/widget/relatedItemsCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/alertbox_text.dart';
import '../../Components/title_widget.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../registration/Login_page.dart';
import '../splash_bottomNav/BottomNavBar.dart';

class ProductView extends StatefulWidget {
  final String productName;
  final String noOfPiece;
  final String serveCapacity;
  final String url;
  final String description;
  final String amount;
  final String actualPrice;
  final String id;
  final String combinationId;
  final String pSize;
  final int position;
  final String recipe;
  final String stock;

  const ProductView(
      {Key? key,
      required this.productName,
      required this.url,
      required this.description,
      required this.amount,
      required this.id,
      required this.combinationId,
      required this.pSize,
      required this.position,
      required this.stock,
      required this.recipe,
      required this.noOfPiece,
      required this.serveCapacity,
      required this.actualPrice})
      : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  ///ProductList
  String? data;
  Map? productList;
  Map? productList1;
  List? finalProductList;
  List? relatedProductList;

  bool isLoading = true;

  int index = 0;

  String? uID;
  String? productID;
  String? productName;
  String? offerPrice;
  String? pSize;
  String? combinationId;

  @override
  void initState() {
    checkUser();
    apiForAllProducts();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
  }

  addToCart(String prID, String prName, String prPrice, String pSize,
      String combID) async {
    var response = await ApiHelper().post(endpoint: "cart/add", body: {
      "userid": uID,
      "productid": prID,
      "product": prName,
      "price": prPrice,
      "quantity": "1",
      "psize": pSize,
      "combination_id": combID
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cart page successful:');

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
      var stock = widget.stock.toString();
      bool isStockAvailable = int.parse(stock) > 0;

      if (isStockAvailable) {
        var response = await ApiHelper().post(endpoint: "cart/add", body: {
          "userid": uID,
          "productid": widget.id.toString(),
          "product": widget.productName.toString(),
          "price": widget.amount.toString(),
          "quantity": "1",
          "psize": widget.pSize.toString(),
          "combination_id": widget.combinationId.toString()
        }).catchError((err) {});

        if (response != null) {
          setState(() {
            debugPrint('cart page successful:');

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
      } else {
        Fluttertoast.showToast(
          msg: "Product is out of stock!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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

  apiForAllProducts() async {
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
        productList = jsonDecode(response);
        productList1 = productList!["pagination"];
        finalProductList = productList1!["pageData"];
        relatedProductList =
            finalProductList![widget.position]["relatedProduct"];
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
          text: widget.productName,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      BottomNav()), // Replace with your cart page
            );
          },
          icon: Icon(Iconsax.arrow_left),
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
        child: Column(
          children: [
            ProductViewTile(
              actualPrice: widget.actualPrice,
                noOfPiece: widget.noOfPiece,
                servingCapacity: widget.serveCapacity,
                itemName: widget.productName.toString(),
                imagePath: widget.url,
                onPressed: () {
                  checkLoggedIn(context);
                },
                price: widget.amount,
                description: widget.description.toString()),

            Heading(
              text: "Related Products",
            ),
            isLoading
                ? CircularProgressIndicator(
              color: Color(ColorT.themeColor),
            )
            // Shimmer.fromColors(
            //         baseColor: Colors.grey[300]!,
            //         highlightColor: Colors.grey[100]!,
            //         child: CarouselSlider.builder(
            //           itemCount: relatedProductList == null
            //               ? 0
            //               : relatedProductList?.length,
            //           itemBuilder: (context, index, realIndex) {
            //             return getProducts(index);
            //           },
            //           options: CarouselOptions(
            //             height: 290,
            //             aspectRatio: 15 / 6,
            //             viewportFraction: .65,
            //             initialPage: 1,
            //             enableInfiniteScroll: false,
            //             reverse: false,
            //             autoPlay: true,
            //             enlargeCenterPage: false,
            //             autoPlayInterval: Duration(seconds: 3),
            //             autoPlayAnimationDuration: Duration(milliseconds: 800),
            //             autoPlayCurve: Curves.fastOutSlowIn,
            //             onPageChanged: (index, reason) {},
            //             scrollDirection: Axis.horizontal,
            //           ),
            //         ),
            //       )
                : CarouselSlider.builder(
                    itemCount: relatedProductList == null
                        ? 0
                        : relatedProductList?.length,
                    itemBuilder: (context, index, realIndex) {
                      return getProducts(index);
                    },
                    options: CarouselOptions(
                      height: 290,
                      aspectRatio: 15 / 6,
                      viewportFraction: .55,
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
    if (relatedProductList == null || relatedProductList![index] == null) {
      return Container();
    }
    var image = UrlConstants.base +
        (relatedProductList![index]["image"] ?? "").toString();
    var price = "₹${relatedProductList![index]["offerPrice"] ?? ""}";
    var actualPrice = "₹${relatedProductList![index]["totalPrice"] ?? ""}";

    var stock = relatedProductList![index]["stock"];
    bool isStockAvailable = stock != null && int.parse(stock.toString()) > 0;

    return RelatedItemTile(
      actualPrice: actualPrice,
      itemName: relatedProductList![index]["name"].toString(),
      imagePath: image,
      onPressed: () {
        if (isStockAvailable) {
          productID = relatedProductList![index]["productID"].toString();
          productName = relatedProductList![index]["name"].toString();
          offerPrice = relatedProductList![index]["offerPrice"].toString();
          pSize = relatedProductList![index]["size_attribute_name"].toString();
          combinationId =
              relatedProductList![index]["combinationid"].toString();
          addToCart(
              productID!, productName!, offerPrice!, pSize!, combinationId!);
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
      price: price,
    );
  }
}
