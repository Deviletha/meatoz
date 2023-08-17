import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meatoz/screens/homepage/AllProducts/Product_tile.dart';
import 'package:meatoz/screens/homepage/Category/CategoryWidget.dart';
import 'package:meatoz/screens/homepage/DealofTheDay/dealoftheday_card.dart';
import 'package:meatoz/screens/homepage/Order/OrderListtile.dart';
import 'package:meatoz/screens/homepage/OurProducts/CardWidget.dart';
import 'package:meatoz/screens/homepage/PopularItems/poularcard.dart';
import 'package:meatoz/screens/homepage/TopPicks/TopPicks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/Title_widget.dart';
import '../../Config/ApiHelper.dart';
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
  String? WID="NO";
  List<String> WISHLISTIDs = [];

  bool isLoading = true;
  bool isLoadingProducts = true;

  // Track API loading state

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
    });
    getMyOrders();
  }

  Future<void> check(String id,String  PID) async {

    if(WID=="NO"|| WID==null){
      addwisH(id,"YES");
      addTowishtist(PID, id,context);
    }
    else{
      addwisH(id, "NO");
    }
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      WID = prefs.getString(id)!;

    });

  }

  addwisH(String wid,String v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      wid, v );
  }

  String? base = "https://meatoz.in/basicapi/public/";

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

  getMyOrders() async {

    var response =
        await ApiHelper().post(endpoint: "common/getMyOrders", body: {
      "userid": UID,
      "offset": "0",
      "pageLimit": "1",
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get address api successful:');
        order = jsonDecode(response);
        order1 = order!["data"];
        orderList = order1!["pageData"];
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
          "pageLimit": "10"
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
          "pageLimit": "10"
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


  Future<void> addTowishtist(String id, String combination, BuildContext context) async {
    if (UID == null) {
      // User is not logged in, show Snackbar and navigate to login page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
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
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add-wishlist api successful:');
        data = response.toString();
        productlist = jsonDecode(response);
        if (productlist != null) {
          productlist1 = productlist!["pagination"];
          if (productlist1 != null) {
            Finalproductlist = productlist1!["pageData"];
          }
        }

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


  @override
  void initState() {
    ApiforPopularProducts().then((_) {
      setState(() {
        isLoadingProducts = false;
      });
    });
    ApiForCategory();
    ApiforBanner();
    ApiforAllProducts();
    apiForDealofTheDAy();
    apiForOurProducts();
    checkUser();
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
                          children: [
                            Text(
                              "Type product name to search items",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            Icon(Icons.search)
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
                child: isLoading
                    ? Center(child: CircularProgressIndicator(color: Colors.teal[900],))
                // Shimmer.fromColors(
                //         baseColor: Colors.grey[300]!,
                //         highlightColor: Colors.grey[100]!,
                //         child: CarouselSlider.builder(
                //           itemCount:
                //               BannerList == null ? 0 : BannerList?.length,
                //           itemBuilder: (context, index, realIndex) {
                //             return getBanner(index);
                //           },
                //           options: CarouselOptions(
                //             height: 125,
                //             aspectRatio: 15 / 6,
                //             viewportFraction: .8,
                //             initialPage: 0,
                //             enableInfiniteScroll: true,
                //             reverse: false,
                //             autoPlay: false,
                //             enlargeCenterPage: true,
                //             autoPlayInterval: Duration(seconds: 3),
                //             autoPlayAnimationDuration:
                //                 Duration(milliseconds: 800),
                //             autoPlayCurve: Curves.fastOutSlowIn,
                //             onPageChanged: (index, reason) {},
                //             scrollDirection: Axis.horizontal,
                //           ),
                //         ),
                //       )
                    : CarouselSlider.builder(
                        itemCount: BannerList == null ? 0 : BannerList?.length,
                        itemBuilder: (context, index, realIndex) {
                          return getBanner(index);
                        },
                        options: CarouselOptions(
                          height: 125,
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
                child: isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: CarouselSlider.builder(
                          itemCount:
                              categorylist == null ? 0 : categorylist?.length,
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
                        itemCount:
                            categorylist == null ? 0 : categorylist?.length,
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
                      )),
            Heading(text: "Deal of The Day"),
            Container(
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CarouselSlider.builder(
                        itemCount: 5, // Set a fixed count for shimmer effect
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
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) {},
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    )
                  : CarouselSlider.builder(
                      itemCount: dealOfTheDayList == null
                          ? 0
                          : dealOfTheDayList?.length,
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
              child: isLoadingProducts
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CarouselSlider.builder(
                        itemCount: 5, // Set a fixed count for shimmer effect
                        itemBuilder: (context, index, realIndex) {
                          return getPopularRow(index);
                        },
                        options: CarouselOptions(
                          height: 300,
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
                        height: 300,
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
    var image = base! + (Finalpopularlist![index]["image"] ?? "").toString();
    var itemName =
        (Finalpopularlist![index]["combinationName"] ?? "").toString();
    return PopularCard(
        ImagePath: image,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
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
    var image = base! + (categorylist![index]["image"] ?? "").toString();

    return TopPicksCard(
      ImagePath: image,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Category_View(
              url: image,
              itemname: categorylist![index]["name"].toString(),
              description: categorylist![index]["description"].toString(),
              price: categorylist![index]["price"].toString(),
              id: categorylist![index]["id"],
            ),
          ),
        );
      },
    );
  }

  Widget getBanner(int index) {
    if (BannerList == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(color: Colors.teal[900],),
        ),
      );
    }
    var image = base! + BannerList![index]["image"];

    return Container(
      height: 200,
      width: 330,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image:
              DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
    );
  }

  Widget getCategoryRow(int index) {
    if (categorylist == null) {
      return Container(); // Handle the case when categorylist is null
    }
    var image = base! + (categorylist![index]["image"] ?? "").toString();
    var itemName = categorylist![index]["name"].toString();

    return CategoryCard(
      ItemName: itemName,
      ImagePath: image,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Category_View(
              url: image,
              itemname: categorylist![index]["name"].toString(),
              description: categorylist![index]["description"].toString(),
              price: categorylist![index]["price"].toString(),
              id: categorylist![index]["id"],
            ),
          ),
        );
      },
    );
  }

  Widget getProducts(int index) {

    if (Finalproductlist == null || Finalproductlist![index] == null) {
      return Container();
    }
    var image = base! + (Finalproductlist![index]["image"] ?? "").toString();
    var price = "₹${Finalproductlist![index]["totalPrice"] ?? ""}";
    var offerPrice = "₹${Finalproductlist![index]["offerPrice"] ?? ""}";
    var PID = (Finalproductlist![index]["id"] ?? "").toString();
    var CombID = (Finalproductlist![index]["combinationId"] ?? "").toString();

    return ProductTile(
      ItemName: Finalproductlist![index]["combinationName"].toString(),
      ImagePath: image,
      onPressed: () {
        check(CombID,PID);

        } ,
      TotalPrice: price,
      OfferPrice: offerPrice,
      Description: Finalproductlist![index]["description"].toString(),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(
              stock: Finalproductlist![index]["stock"].toString(),
              recipe: Finalproductlist![index]["hint"].toString(),
              position: index,
              id: PID,
              productname:
                  Finalproductlist![index]["combinationName"].toString(),
              url: image,
              description: Finalproductlist![index]["description"].toString(),
              amount: Finalproductlist![index]["offerPrice"].toString(),
              combinationId: CombID,
              psize: Finalproductlist![index]["size_attribute_name"].toString(),
            ),
          ),
        );
      }, combinationId: CombID,
    );
  }

  Widget getOrderList(int index) {
    var image = base! + orderList![index]["image"].toString();
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

  Widget getDealOfTheDay(int index) {
    if (dealOfTheDayList == null || dealOfTheDayList![index] == null) {
      return Container();
    }
    var image = base! + (dealOfTheDayList![index]["image"] ?? "").toString();
    var price = "₹${dealOfTheDayList![index]["totalPrice"] ?? ""}";
    var offerPrice = "₹${dealOfTheDayList![index]["offerPrice"] ?? ""}";
    var PID = (dealOfTheDayList![index]["id"] ?? "").toString();
    var CombID = (dealOfTheDayList![index]["combinationId"] ?? "").toString();

    return DealOfTheDayCard(
        combinationId: CombID,
        ItemName: dealOfTheDayList![index]["name"].toString(),
        ImagePath: image,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
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
        onPressed: () {
          check(CombID,PID);
        },
        TotalPrice: price,
        OfferPrice: offerPrice,
        Description: dealOfTheDayList![index]["description"].toString());
  }

  Widget getOurProducts(int index) {
    if (ourProductList == null || ourProductList![index] == null) {
      return Container();
    }
    var image = base! + (ourProductList![index]["image"] ?? "").toString();
    var price = "₹${ourProductList![index]["totalPrice"] ?? ""}";
    var offerPrice = "₹${ourProductList![index]["offerPrice"] ?? ""}";
    var PID = (ourProductList![index]["id"] ?? "").toString();
    var CombID = (ourProductList![index]["combinationId"] ?? "").toString();

    return OurProductCard(
        ItemName: ourProductList![index]["name"].toString(),
        ImagePath: image,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
                stock: ourProductList![index]["stock"].toString(),
                  recipe: "Recipe not available for this item",
                  position: index,
                  id: PID,
                  productname: ourProductList![index]["name"].toString(),
                  url: image,
                  description: ourProductList![index]["description"].toString(),
                  amount: ourProductList![index]["offerPrice"].toString(),
                  combinationId: CombID,
                  psize: ourProductList![index]["size_attribute_name"].toString(),
              ),
            ),
          );
        },
        onPressed: () {
          check(CombID,PID);
        },
        TotalPrice: price,
        combinationId: CombID,
        OfferPrice: offerPrice,
        Description: ourProductList![index]["description"].toString());
  }
}
