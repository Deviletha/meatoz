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
import '../../Components/Title_widget.dart';
import '../../Components/text_widget.dart';
import '../../Config/ApiHelper.dart';
import '../../Config/image_url_const.dart';
import '../registration/Login_page.dart';
import 'Notification_page.dart';
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
  String? UID;
  bool isLoading = true;
  // bool isLoadingProducts = true;


  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
    });
    getMyOrders();
    wishListGet();
  }

  ///BannerList
  Map? banner;
  List? BannerList;

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
  List? categorylist;

  ///ProductList
  String? data;
  Map? productlist;
  Map? productlist1;
  List? Finalproductlist;
  List? RelatedPrdctList;

  ///PopularProductList
  Map? popularlist;
  Map? popularlist1;
  List? Finalpopularlist;
  int index = 0;


  Map? prlist;
  Map? prlist1;
  List? Prlist;

  Future<void> wishListGet() async {
    var response = await ApiHelper().post(endpoint: "wishList/get", body: {
      "userid": UID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('wishlist api successful:');
        prlist = jsonDecode(response);
        prlist1 = prlist!["pagination"];
        Prlist = prlist1!["pageData"];
        print(Prlist);
      });
    } else {
      debugPrint('api failed:');
    }
  }

  Future<void> getMyOrders() async {
    var response = await ApiHelper().post(endpoint: "common/getMyOrders", body: {
      "userid": UID,
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


  ApiForCategory() async {

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
        categorylist = jsonDecode(response);
      });
    } else {
      debugPrint('api failed:');
    }
  }

  ApiforAllProducts() async {

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
        productlist = jsonDecode(response);
        productlist1 = productlist!["pagination"];
        Finalproductlist = productlist1!["pageData"];
        RelatedPrdctList = Finalproductlist![0]["relatedProduct"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  ApiforBanner() async {

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
        BannerList = banner!["banner"];
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

  apiForDealofTheDAy() async {

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

  ApiforPopularProducts() async {

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
        popularlist = jsonDecode(response);
        popularlist1 = popularlist!["pagination"];
        Finalpopularlist = popularlist1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }


  Future<void> addTowishtist(String id, String combination, String amount, BuildContext context) async {
    if (UID == null) {
      // User is not logged in, show Snackbar and navigate to login page
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
      "userid": UID,
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
    var response = await ApiHelper().post(endpoint: "wishList/removeByCombination", body: {
      "userid": UID,
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

  @override
  void initState() {
    setState(() {
      ApiforPopularProducts();
      ApiForCategory();
      ApiforBanner();
      ApiforAllProducts();
      apiForDealofTheDAy();
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
          "assets/logo1.png", height: 36, color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Notifications();
                },
              )),
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              )),
          SizedBox(
            width: 15,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.teal[900],
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
                            Icon(Iconsax.search_normal_1,)
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
                child: BannerList != null && BannerList!.isNotEmpty ?
                isLoading
                    ?
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: CarouselSlider.builder(
                    itemCount:
                    BannerList == null ? 0 : BannerList?.length,
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
                  itemCount: BannerList == null ? 0 : BannerList?.length,
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
                ) : Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: CarouselSlider.builder(
                    itemCount:
                    BannerList == null ? 0 : BannerList?.length,
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
            ),
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
                    itemCount: 1, // Set a fixed count for the shimmer effect
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
                            itemBuilder: (context, index) => getOrderList(index),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: UID == null,
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
                  crossAxisCount: 4,
                  childAspectRatio: .95,
                ),
                itemCount:
                categorylist == null ? 0 : categorylist?.length,
                itemBuilder: (context, index) => getCategoryRow(index),
              ),
            ),
            Heading(text: "Top Picks For You"),
            Container(
              child: categorylist != null && categorylist!.isNotEmpty
                  ? isLoading
                  ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CarouselSlider.builder(
                  itemCount: categorylist!.length,
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
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    onPageChanged: (index, reason) {},
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              )
                  : CarouselSlider.builder(
                itemCount: categorylist!.length,
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
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                  height: 300,
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
                    height: 300,
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
                  height: 300,
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
                itemCount: Finalpopularlist == null
                    ? 0
                    : Finalpopularlist?.length,
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
                    childAspectRatio: .65,
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
                  childAspectRatio: .65,
                ),
                itemCount: Finalproductlist == null
                    ? 0
                    : Finalproductlist?.length,
                itemBuilder: (context, index) => getProducts(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getPopularRow(int index) {
    if (Finalpopularlist == null || Finalpopularlist![index] == null) {
      return Container();
    }
    var image = UrlConstants.base + (Finalpopularlist![index]["image"] ?? "").toString();
    var itemName =
    (Finalpopularlist![index]["combinationName"] ?? "").toString();
    return PopularCard(
        ImagePath: image,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
                serveCapacity: Finalpopularlist![index]["serving_cupacity"].toString(),
                noOfPiece: Finalpopularlist![index]["no_of_piece"].toString(),
                stock: Finalpopularlist![index]["stock"].toString(),
                recipe: Finalpopularlist![index]["hint"].toString(),
                position: index,
                id: Finalpopularlist![index]["id"].toString(),
                productname:
                Finalpopularlist![index]["combinationName"].toString(),
                url: image,
                description: Finalpopularlist![index]["description"].toString(),
                amount: Finalpopularlist![index]["offerPrice"].toString(),
                combinationId:
                Finalpopularlist![index]["combinationId"].toString(),
                psize: Finalpopularlist![index]["size_attribute_name"].toString(),
              ),
            ),
          );
        },
        ItemName: itemName);
  }

  Widget getCategoryImage(int index) {
    if (categorylist == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(),
      );
    }
    var image = UrlConstants.base + (categorylist![index]["image"] ?? "").toString();

    return TopPicksCard(
      ImagePath: image,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Category_View(
              // url: image,
              itemname: categorylist![index]["name"].toString(),
              // description: categorylist![index]["description"].toString(),
              // price: categorylist![index]["price"].toString(),
              id: categorylist![index]["id"],
            ),
          ),
        );
      },
    );
  }

  Widget getBanner(int index) {
    if (BannerList == null || BannerList!.isEmpty ) {
      return Center(
        child: CircularProgressIndicator(color: Colors.teal[900],),
      );
    }
    var image = UrlConstants.base + BannerList![index]["image"];

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
      CartName: orderList![index]["cartName"].toString(),
      ImagePath: image,
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
    if (categorylist == null) {
      return Container(); // Handle the case when categorylist is null
    }
    var image = UrlConstants.base + (categorylist![index]["image"] ?? "").toString();
    var itemName = categorylist![index]["name"].toString();

    return CategoryCard(
      ItemName: itemName,
      ImagePath: image,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Category_View(
              // url: image,
              itemname: categorylist![index]["name"].toString(),
              // description: categorylist![index]["description"].toString(),
              // price: categorylist![index]["price"].toString(),
              id: categorylist![index]["id"],
            ),
          ),
        );
      },
    );
  }

  Widget getProducts(int index1) {

    if (Finalproductlist == null || Finalproductlist![index1] == null) {
      return Container();
    }
    var image = UrlConstants.base + (Finalproductlist![index1]["image"] ?? "").toString();
    var price = "₹${Finalproductlist![index1]["totalPrice"] ?? ""}";
    var offerPrice = Finalproductlist![index1]["offerPrice"].toString() ?? "";
    var PID = (Finalproductlist![index1]["id"] ?? "").toString();
    var CombID = (Finalproductlist![index1]["combinationId"] ?? "").toString();

    bool isInWishlist = Prlist != null && Prlist!.any((item) => item['combinationId'].toString() == CombID);

    return
      Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductView(
                    serveCapacity: Finalpopularlist![index]["serving_cupacity"].toString(),
                    noOfPiece: Finalpopularlist![index]["no_of_piece"].toString(),
                    stock: Finalproductlist![index1]["stock"].toString(),
                    recipe: Finalproductlist![index1]["hint"].toString(),
                    position: index1,
                    id: PID,
                    productname:
                    Finalproductlist![index1]["combinationName"].toString(),
                    url: image,
                    description: Finalproductlist![index1]["description"].toString(),
                    amount: Finalproductlist![index1]["offerPrice"].toString(),
                    combinationId: CombID,
                    psize: Finalproductlist![index1]["size_attribute_name"].toString(),
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
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextConst(
                          text: Finalproductlist![index1]["combinationName"].toString(),),
                      SizedBox(
                        height: 10,
                      ),
                      Text(Finalproductlist![index1]["description"].toString(),
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.teal[900],
                              fontWeight: FontWeight.bold)),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(price,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "₹"+ offerPrice,
                            // WID,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                    color: isInWishlist ? Colors.red : Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    if (isInWishlist) {
                      removeFromWishList(CombID);
                      wishListGet();
                    } else {
                      addTowishtist(PID, CombID, offerPrice, context);
                      wishListGet();
                    }
                  },
                )
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
    var image = UrlConstants.base + (dealOfTheDayList![index]["image"] ?? "").toString();
    var price = "₹${dealOfTheDayList![index]["totalPrice"] ?? ""}";
    var offerPrice = (dealOfTheDayList![index]["offerPrice"] ?? "" ).toString() ;
    var PID = (dealOfTheDayList![index]["id"] ?? "").toString();
    var CombID = (dealOfTheDayList![index]["combinationId"] ?? "").toString();

    bool isInWishlist = Prlist != null && Prlist!.any((item) => item['combinationId'].toString() == CombID);


    return
      Padding(
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
                    serveCapacity: dealOfTheDayList![index]["serving_cupacity"].toString(),
                    noOfPiece: dealOfTheDayList![index]["no_of_piece"].toString(),
                    stock: dealOfTheDayList![index]["stock"].toString(),
                    recipe: "Recipe not available for this product",
                    position: index,
                    id: PID,
                    productname: dealOfTheDayList![index]["name"].toString(),
                    url: image,
                    description: dealOfTheDayList![index]["description"].toString(),
                    amount: dealOfTheDayList![index]["offerPrice"].toString(),
                    combinationId: CombID,
                    psize: dealOfTheDayList![index]["size_attribute_name"].toString(),
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  width: double.infinity,
                  height:MediaQuery.of(context).size.height / 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  // Image border// Image radius
                  child: CachedNetworkImage(
                    imageUrl: image,
                    placeholder: (context, url) =>
                        Container(
                          color: Colors.grey[300],
                        ),
                    errorWidget: (context, url, error) =>
                        Container(
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
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                           "₹$offerPrice",
                            style:  TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
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
                                removeFromWishList(CombID);
                                wishListGet();
                              } else {
                                // The item is not in the wishlist, you may want to add it.
                                addTowishtist(PID, CombID, offerPrice, context);
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
                          text: dealOfTheDayList![index]["name"].toString(),),
                      SizedBox(
                        height: 10,
                      ),
                      Text(dealOfTheDayList![index]["description"].toString(),
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.teal[900],
                              fontWeight: FontWeight.bold)),
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
    var image = UrlConstants.base + (ourProductList![index2]["image"] ?? "").toString();
    var price = "₹${ourProductList![index2]["totalPrice"] ?? ""}";
    var offerPrice = (ourProductList![index2]["offerPrice"]  ?? "").toString();
    var PID = (ourProductList![index2]["id"] ?? "").toString();
    var CombID = (ourProductList![index2]["combinationId"] ?? "").toString();

    bool isInWishlist = Prlist != null && Prlist!.any((item) => item['combinationId'].toString() == CombID);


    return
      Padding(
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
                    serveCapacity: ourProductList![index2]["serving_cupacity"].toString(),
                    stock: ourProductList![index2]["stock"].toString(),
                    recipe: "Recipe not available for this item",
                    position: index2,
                    id: PID,
                    productname: ourProductList![index2]["name"].toString(),
                    url: image,
                    description: ourProductList![index2]["description"].toString(),
                    amount: ourProductList![index2]["offerPrice"].toString(),
                    combinationId: CombID,
                    psize: ourProductList![index2]["size_attribute_name"].toString(),
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
                    placeholder: (context, url) =>
                        Container(
                          color: Colors.grey[300],
                        ),
                    errorWidget: (context, url, error) =>
                        Container(
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
                          text: ourProductList![index2]["name"].toString(),),
                      SizedBox(
                        height: 10,
                      ),
                      Text(ourProductList![index2]["description"].toString(),
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.teal[900],
                              fontWeight: FontWeight.bold)),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              decorationStyle: TextDecorationStyle.solid,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "₹$offerPrice",
                            style:  TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
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
                                removeFromWishList(CombID);
                                wishListGet();
                              } else {
                                // The item is not in the wishlist, you may want to add it.
                                addTowishtist(PID, CombID, offerPrice, context);
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