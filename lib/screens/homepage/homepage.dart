import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meatoz/screens/homepage/Category/CategoryWidget.dart';
import 'package:meatoz/screens/homepage/Order/OrderListtile.dart';
import 'package:meatoz/screens/homepage/PopularItems/poularcard.dart';
import 'package:meatoz/screens/homepage/TopPicks/TopPicks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/description_homepage.dart';
import '../../Components/title_widget.dart';
import '../../Components/text_widget.dart';
import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../cartpage/Cart_page.dart';
import '../registration/Login_page.dart';
import '../orders/Orderdetails.dart';
import '../product_view/Product_view.dart';
import 'Search Page.dart';
import '../category_view/category_view.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? uID;
  bool isLoading = true;

  // bool isLoadingProducts = true;

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
    getMyOrders();
    wishListGet();
    apiForCart();
  }

  ///BannerList
  Map? banner;
  List? bannerList;

  ///Our Product List
  Map? products;
  List? ourProductList;

  ///Deal of the Day List
  Map? deal;
  List? dealOfTheDayList;

  ///OrderList
  Map? order;
  Map? order1;
  List? orderList;

  ///CategoryList
  List? categoryList;

  ///ProductList
  String? data;
  Map? productList;
  Map? productList1;
  List? finalProductList;
  List? relatedProductList;

  ///PopularProductList
  Map? popularList;
  Map? popularList1;
  List? finalPopularList;
  int index = 0;

  ///CartList
  Map? cList;
  List? cartList;

  ///WishlistItemsList
  Map? prList;
  Map? prList1;
  List? finalPrList;

  Future<void> wishListGet() async {
    var response = await ApiHelper().post(endpoint: "wishList/get", body: {
      "userid": uID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('wishlist api successful:');
        prList = jsonDecode(response);
        prList1 = prList!["pagination"];
        finalPrList = prList1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  Future<void> getMyOrders() async {
    var response =
        await ApiHelper().post(endpoint: "common/getMyOrders", body: {
      "userid": uID,
      "offset": "0",
      "pageLimit": "1",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get my orders api successful:');
        order = jsonDecode(response);
        order1 = order!["data"];
        dynamic pageData = order1!["pageData"]; // Declare pageData as dynamic
        if (pageData is List<dynamic>) {
          orderList = pageData;
        } else {
          // Handle the case where pageData is not a List
          orderList = []; // Set it to an empty list or handle it accordingly
        }
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForCategory() async {
    var response = await ApiHelper()
        .post(endpoint: "categories", body: {}).catchError((err) {});

    setState(() {
      Timer(const Duration(seconds: 3), () {
        isLoading = false;
      });
    });
    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        categoryList = jsonDecode(response);
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForAllProducts() async {
    var response =
        await ApiHelper().post(endpoint: "products/ByCombination", body: {
      "offset": "0",
      "pageLimit": "50",
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
        relatedProductList = finalProductList![0]["relatedProduct"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForBanner() async {
    var response = await ApiHelper()
        .post(endpoint: "banner/getOfferBanner", body: {}).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('Banner api successful:');
        data = response.toString();
        banner = jsonDecode(response);
        bannerList = banner!["banner"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForOurProducts() async {
    var response = await ApiHelper().post(
        endpoint: "product/ourProductLimit",
        body: {
          "table": "products",
          "offset": "0",
          "pageLimit": "20"
        }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('Our Products api successful:');
        data = response.toString();
        products = jsonDecode(response);
        ourProductList = products!["OurProducts"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForDealOfTheDAy() async {
    var response = await ApiHelper().post(
        endpoint: "product/dealOfTheDayLimit",
        body: {
          "table": "products",
          "offset": "0",
          "pageLimit": "20"
        }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('Deal of the day api successful:');
        data = response.toString();
        deal = jsonDecode(response);
        dealOfTheDayList = deal!["dealProducts"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForPopularProducts() async {
    var response =
        await ApiHelper().post(endpoint: "products/ByCombination", body: {
      "offset": "0",
      "pageLimit": "8",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        data = response.toString();
        popularList = jsonDecode(response);
        popularList1 = popularList!["pagination"];
        finalPopularList = popularList1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  Future<void> addToWishList(String id, String combination, String amount,
      BuildContext context) async {
    if (uID == null) {
      // User is not logged in, show Snack bar and navigate to login page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Please log in to add to wishlist.'),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Log In'),
              ),
            ],
          ),
        ),
      );
      return;
    }

    var response = await ApiHelper().post(endpoint: "wishList/add", body: {
      "userid": uID,
      "productid": id,
      "combination": combination,
      "amount": amount,
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add-wishlist api successful:');

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

  removeFromWishList(String id) async {
    var response =
        await ApiHelper().post(endpoint: "wishList/removeByCombination", body: {
      "userid": uID,
      "product_id": id,
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add-wishlist api successful:');

        Fluttertoast.showToast(
          msg: "Removed from Wishlist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('Remove wishlist failed:');
    }
  }

  apiForCart() async {
    var response = await ApiHelper().post(endpoint: "cart/get", body: {
      "userid": uID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('cartpage successful:');
        cList = jsonDecode(response);
        cartList = cList!["cart"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  void initState() {
    setState(() {
      apiForPopularProducts();
      apiForCategory();
      apiForBanner();
      apiForAllProducts();
      apiForDealOfTheDAy();
      apiForOurProducts();
      checkUser();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Image.asset(
          "assets/logo1.png",
          height: 36,
          color: Colors.white,
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () => Navigator.push(context, MaterialPageRoute(
        //         builder: (context) {
        //           return Notifications();
        //         },
        //       )),
        //       icon: Icon(
        //         Icons.notifications_outlined,
        //         color: Colors.white,
        //       )),
        //   SizedBox(
        //     width: 15,
        //   ),
        // ],
      ),
      bottomSheet: Visibility(
        visible:  cartList != null &&
            cartList!.isNotEmpty,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CartPage()), // Replace with your cart page
            );
          },
          child: Container(
            decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.srcATop, // Example blend mode
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color(ColorT.lightGreen),
                  Color(ColorT.themeColor),
                ],
              ),
            ),
            height: 60,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 10, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your cart items",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Row(
                    children: [
                      Text("View Cart",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        color: Colors.white,
                        height: 20,
                        width: 1,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Iconsax.shopping_bag,
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
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
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Color(ColorT.themeColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Search();
                        }),
                      ),
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Colors.grey.shade100)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "Type product name to search items",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            Icon(
                              Iconsax.search_normal_1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                )
              ),
                child: bannerList != null && bannerList!.isNotEmpty
                    ? isLoading
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: CarouselSlider.builder(
                              itemCount:
                                  bannerList == null ? 0 : bannerList?.length,
                              itemBuilder: (context, index, realIndex) {
                                return getBanner(index);
                              },
                              options: CarouselOptions(
                                height: 125,
                                aspectRatio: 15 / 6,
                                viewportFraction: .8,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: false,
                                enlargeCenterPage: true,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                onPageChanged: (index, reason) {},
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          )
                        : CarouselSlider.builder(
                            itemCount:
                                bannerList == null ? 0 : bannerList?.length,
                            itemBuilder: (context, index, realIndex) {
                              return getBanner(index);
                            },
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height / 6,
                              aspectRatio: 15 / 6,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              enlargeCenterPage: false,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              onPageChanged: (index, reason) {},
                              scrollDirection: Axis.horizontal,
                            ),
                          )
                    : Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: CarouselSlider.builder(
                          itemCount:
                              bannerList == null ? 0 : bannerList?.length,
                          itemBuilder: (context, index, realIndex) {
                            return getBanner(index);
                          },
                          options: CarouselOptions(
                            height: 125,
                            aspectRatio: 15 / 6,
                            viewportFraction: .8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            onPageChanged: (index, reason) {},
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              1, // Set a fixed count for the shimmer effect
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              height: 100, // Adjust the height as needed
                            );
                          },
                        ),
                      )
                    : Column(
                        children: [
                          Visibility(
                            visible: orderList != null && orderList!.isNotEmpty,
                            child: Column(
                              children: [
                                Heading(text: "Recent Orders"),
                                ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: orderList?.length ?? 0,
                                  itemBuilder: (context, index) =>
                                      getOrderList(index),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: uID == null,
                            child: SizedBox(),
                          ),
                        ],
                      ),
              ),
            ),
            Heading(text: "Category"),
            Container(
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: .95,
                        ),
                        itemCount: 8,
                        // Set a fixed count for shimmer effect
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(360),
                            ),
                          );
                        },
                      ),
                    )
                  : GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: .95,
                      ),
                      itemCount:
                          categoryList == null ? 0 : categoryList?.length,
                      itemBuilder: (context, index) => getCategoryRow(index),
                    ),
            ),
            Heading(text: "Top Picks For You"),
            Container(
              child: categoryList != null && categoryList!.isNotEmpty
                  ? isLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CarouselSlider.builder(
                            itemCount: categoryList!.length,
                            itemBuilder: (context, index, realIndex) {
                              return getCategoryImage(index);
                            },
                            options: CarouselOptions(
                              height: 180,
                              aspectRatio: 15 / 6,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              onPageChanged: (index, reason) {},
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        )
                      : CarouselSlider.builder(
                          itemCount: categoryList!.length,
                          itemBuilder: (context, index, realIndex) {
                            return getCategoryImage(index);
                          },
                          options: CarouselOptions(
                            height: 180,
                            aspectRatio: 15 / 6,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            enlargeCenterPage: false,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            onPageChanged: (index, reason) {},
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                  : SizedBox(),
            ),
            Heading(text: "Deal of The Day"),
            Container(
              child: dealOfTheDayList != null && dealOfTheDayList!.isNotEmpty
                  ? CarouselSlider.builder(
                      itemCount: dealOfTheDayList!.length,
                      itemBuilder: (context, index, realIndex) {
                        return getDealOfTheDay(index);
                      },
                      options: CarouselOptions(
                        height: 250,
                        aspectRatio: 15 / 6,
                        viewportFraction: .50,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    )
                  : Center(
                      child: Text('No deals available'),
                    ),
            ),
            Heading(text: "Our Products"),
            Container(
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CarouselSlider.builder(
                        itemCount: 5, // Set a fixed count for shimmer effect
                        itemBuilder: (context, index, realIndex) {
                          return getOurProducts(index);
                        },
                        options: CarouselOptions(
                          height: 250,
                          aspectRatio: 15 / 6,
                          viewportFraction: .50,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: false,
                          enlargeCenterPage: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) {},
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    )
                  : CarouselSlider.builder(
                      itemCount:
                          ourProductList == null ? 0 : ourProductList?.length,
                      itemBuilder: (context, index, realIndex) {
                        return getOurProducts(index);
                      },
                      options: CarouselOptions(
                        height: 250,
                        aspectRatio: 15 / 6,
                        viewportFraction: .50,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
            ),
            Heading(text: "Popular Items"),
            Container(
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CarouselSlider.builder(
                        itemCount: 5, // Set a fixed count for shimmer effect
                        itemBuilder: (context, index, realIndex) {
                          return getPopularRow(index);
                        },
                        options: CarouselOptions(
                          height: MediaQuery.of(context).size.height / 2.5,
                          aspectRatio: 15 / 6,
                          viewportFraction: .58,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) {},
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    )
                  : CarouselSlider.builder(
                      itemCount: finalPopularList == null
                          ? 0
                          : finalPopularList?.length,
                      itemBuilder: (context, index, realIndex) {
                        return getPopularRow(index);
                      },
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 2.5,
                        aspectRatio: 15 / 6,
                        viewportFraction: .7,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
            ),
            Heading(text: "Today's Featured"),
            Container(
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: GridView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .85,
                        ),
                        itemCount: 8,
                        // Set a fixed count for shimmer effect
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          );
                        },
                      ),
                    )
                  : GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .85,
                      ),
                      itemCount: finalProductList == null
                          ? 0
                          : finalProductList?.length,
                      itemBuilder: (context, index) => getProducts(index),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPopularRow(int index) {
    if (finalPopularList == null || finalPopularList![index] == null) {
      return Container();
    }
    var image = UrlConstants.base +
        (finalPopularList![index]["image"] ?? "").toString();
    var itemName =
        (finalPopularList![index]["combinationName"] ?? "").toString();
    return PopularCard(
        imagePath: image,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
                serveCapacity:
                    finalPopularList![index]["serving_cupacity"].toString(),
                noOfPiece: finalPopularList![index]["no_of_piece"].toString(),
                stock: finalPopularList![index]["stock"].toString(),
                recipe: finalPopularList![index]["hint"].toString(),
                position: index,
                id: finalPopularList![index]["id"].toString(),
                productName:
                    finalPopularList![index]["combinationName"].toString(),
                url: image,
                description: finalPopularList![index]["description"].toString(),
                amount: finalPopularList![index]["offerPrice"].toString(),
                combinationId:
                    finalPopularList![index]["combinationId"].toString(),
                pSize:
                    finalPopularList![index]["size_attribute_name"].toString(),
              ),
            ),
          );
        },
        itemName: itemName);
  }

  Widget getCategoryImage(int index) {
    if (categoryList == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(),
      );
    }
    var image =
        UrlConstants.base + (categoryList![index]["image"] ?? "").toString();

    return TopPicksCard(
      imagePath: image,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryView(
              itemName: categoryList![index]["name"].toString(),
              id: categoryList![index]["id"],
            ),
          ),
        );
      },
    );
  }

  Widget getBanner(int index) {
    if (bannerList == null || bannerList!.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.teal[900],
        ),
      );
    }
    var image = UrlConstants.base + bannerList![index]["image"];

    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width / 1.05,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image:
              DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
    );
  }

  Widget getOrderList(int index) {
    var image = UrlConstants.base + orderList![index]["image"].toString();
    return OrderCard(
      cartName: orderList![index]["cartName"].toString(),
      imagePath: image,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetails(
              id: orderList![index]["id"].toString(),
            ),
          ),
        );
      },
    );
  }

  Widget getCategoryRow(int index) {
    if (categoryList == null) {
      return Container(); // Handle the case when category-list is null
    }
    var image =
        UrlConstants.base + (categoryList![index]["image"] ?? "").toString();
    var itemName = categoryList![index]["name"].toString();

    return CategoryCard(
      itemName: itemName,
      imagePath: image,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryView(
              // url: image,
              itemName: categoryList![index]["name"].toString(),
              // description: categoryList![index]["description"].toString(),
              // price: categoryList![index]["price"].toString(),
              id: categoryList![index]["id"],
            ),
          ),
        );
      },
    );
  }

  Widget getProducts(int index1) {
    if (finalProductList == null || finalProductList![index1] == null) {
      return Container();
    }
    var image = UrlConstants.base +
        (finalProductList![index1]["image"] ?? "").toString();
    var price = "₹${finalProductList![index1]["totalPrice"] ?? ""}";
    var offerPrice = (finalProductList![index1]["offerPrice"] ?? "").toString();
    var pId = (finalProductList![index1]["id"] ?? "").toString();
    var combID = (finalProductList![index1]["combinationId"] ?? "").toString();

    bool isInWishlist = finalPrList != null &&
        finalPrList!.any((item) => item['combinationId'].toString() == combID);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300, width: 1)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductView(
                  serveCapacity:
                      finalProductList![index]["serving_cupacity"].toString(),
                  noOfPiece: finalProductList![index]["no_of_piece"].toString(),
                  stock: finalProductList![index1]["stock"].toString(),
                  recipe: finalProductList![index1]["hint"].toString(),
                  position: index1,
                  id: pId,
                  productName:
                      finalProductList![index1]["combinationName"].toString(),
                  url: image,
                  description:
                      finalProductList![index1]["description"].toString(),
                  amount: finalProductList![index1]["offerPrice"].toString(),
                  combinationId: combID,
                  pSize: finalProductList![index1]["size_attribute_name"]
                      .toString(),
                ),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                // Image border// Image radius
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
                width: 15,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextConst(
                      text: finalProductList![index1]["combinationName"]
                          .toString(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextDescriptionHome(
                        text:
                            finalProductList![index1]["description"].toString(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationStyle: TextDecorationStyle.solid,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "₹$offerPrice",
                              // WID,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.teal.shade800,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                            color: isInWishlist ? Colors.red : Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            if (isInWishlist) {
                              removeFromWishList(combID);
                              wishListGet();
                            } else {
                              addToWishList(pId, combID, offerPrice, context);
                              wishListGet();
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDealOfTheDay(int index) {
    if (dealOfTheDayList == null || dealOfTheDayList![index] == null) {
      return Container();
    }
    var image = UrlConstants.base +
        (dealOfTheDayList![index]["image"] ?? "").toString();
    var price = "₹${dealOfTheDayList![index]["totalPrice"] ?? ""}";
    var offerPrice = (dealOfTheDayList![index]["offerPrice"] ?? "").toString();
    var pId = (dealOfTheDayList![index]["id"] ?? "").toString();
    var combID = (dealOfTheDayList![index]["combinationId"] ?? "").toString();

    bool isInWishlist = finalPrList != null &&
        finalPrList!.any((item) => item['combinationId'].toString() == combID);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.teal.shade50, width: 1)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductView(
                  serveCapacity:
                      dealOfTheDayList![index]["serving_cupacity"].toString(),
                  noOfPiece: dealOfTheDayList![index]["no_of_piece"].toString(),
                  stock: dealOfTheDayList![index]["stock"].toString(),
                  recipe: "Recipe not available for this product",
                  position: index,
                  id: pId,
                  productName: dealOfTheDayList![index]["name"].toString(),
                  url: image,
                  description:
                      dealOfTheDayList![index]["description"].toString(),
                  amount: dealOfTheDayList![index]["offerPrice"].toString(),
                  combinationId: combID,
                  pSize: dealOfTheDayList![index]["size_attribute_name"]
                      .toString(),
                ),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                // Image border// Image radius
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
                width: 15,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationStyle: TextDecorationStyle.solid,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "₹$offerPrice",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.teal.shade800,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          icon: Icon(
                            isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                            color: isInWishlist ? Colors.red : Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            if (isInWishlist) {
                              // The item is in the wishlist, you may want to remove it.
                              removeFromWishList(combID);
                              wishListGet();
                            } else {
                              // The item is not in the wishlist, you may want to add it.
                              addToWishList(pId, combID, offerPrice, context);
                              wishListGet();
                            }
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextConst(
                      text: dealOfTheDayList![index]["name"].toString(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextDescriptionHome(
                        text:
                            dealOfTheDayList![index]["description"].toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getOurProducts(int index2) {
    if (ourProductList == null || ourProductList![index2] == null) {
      return Container();
    }
    var image =
        UrlConstants.base + (ourProductList![index2]["image"] ?? "").toString();
    var price = "₹${ourProductList![index2]["totalPrice"] ?? ""}";
    var offerPrice = (ourProductList![index2]["offerPrice"] ?? "").toString();
    var pId = (ourProductList![index2]["id"] ?? "").toString();
    var combID = (ourProductList![index2]["combinationId"] ?? "").toString();

    bool isInWishlist = finalPrList != null &&
        finalPrList!.any((item) => item['combinationId'].toString() == combID);

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.teal.shade50, width: 1)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductView(
                  noOfPiece: ourProductList![index2]["no_of_piece"].toString(),
                  serveCapacity:
                      ourProductList![index2]["serving_cupacity"].toString(),
                  stock: ourProductList![index2]["stock"].toString(),
                  recipe: "Recipe not available for this item",
                  position: index2,
                  id: pId,
                  productName: ourProductList![index2]["name"].toString(),
                  url: image,
                  description:
                      ourProductList![index2]["description"].toString(),
                  amount: ourProductList![index2]["offerPrice"].toString(),
                  combinationId: combID,
                  pSize:
                      ourProductList![index2]["size_attribute_name"].toString(),
                ),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                // Image border// Image radius
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
                width: 15,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextConst(
                      text: ourProductList![index2]["name"].toString(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: TextDescriptionHome(
                        text: ourProductList![index2]["description"].toString(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            decorationStyle: TextDecorationStyle.solid,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "₹$offerPrice",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.teal.shade800,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          icon: Icon(
                            isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                            color: isInWishlist ? Colors.red : Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            if (isInWishlist) {
                              removeFromWishList(combID);
                              wishListGet();
                            } else {
                              // The item is not in the wishlist, you may want to add it.
                              addToWishList(pId, combID, offerPrice, context);
                              wishListGet();
                            }
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
