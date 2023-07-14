import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../Config/ApiHelper.dart';
import '../constants/Title_widget.dart';
import '../constants/appbar_text.dart';
import '../constants/text_widget.dart';
import 'Notification_page.dart';
import 'Orderdetails.dart';
import 'Product_view.dart';
import 'Search Page.dart';
import 'category_view.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? UID;

  bool isLoading = false;
  bool isLoadingCategories = true; // Track API loading state

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
      print(UID);
    });
    getMyOrders();
  }

  String? base = "https://meatoz.in/basicapi/public/";

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

  ///PopularProductList
  Map? popularlist;
  Map? popularlist1;
  List? Finalpopularlist;
  int index = 0;

  getMyOrders() async {
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      isLoading = true;
    });

    var response = await ApiHelper().post(endpoint: "categories", body: {

    }).catchError((err) {});

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
    setState(() {
      isLoading = true;
    });

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

      });
    } else {
      debugPrint('api failed:');

    }
  }

  ApiforPopularProducts() async {
    setState(() {
      isLoading = true;
    });

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

  addTowishtist(String id, String combination) async {
    var response = await ApiHelper().post(endpoint: "wishList/add", body: {
      "userid": UID,
      "productid": id,
      "combination": combination
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('addwishlist api successful:');
        data = response.toString();
        productlist = jsonDecode(response);
        productlist1 = productlist!["pagination"];
        Finalproductlist = productlist1!["pageData"];

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
    ApiForCategory().then((_) {
      setState(() {
        isLoadingCategories = false;
      });
    });
    ApiforAllProducts();
    ApiforPopularProducts();
    getMyOrders();
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: AppText(text:
          "MEATOZ",
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[900],
        elevation: 10,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(
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
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
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
                    padding:  EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: Colors.teal.shade900)
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text( "Search..."),
                        Icon(Icons.search)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        Container(
          child: isLoading
              ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1, // Set a fixed count for shimmer effect
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
              Heading(text: "Recent Orders"),
              if (orderList != null && orderList!.isNotEmpty)
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderList!.length,
                  itemBuilder: (context, index) => getOrderList(index),
                ),
            ],
          ),

        ),
           Heading(text: "Category"),
          Container(
            child: isLoadingCategories
                ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CarouselSlider.builder(
                itemCount:
                5, // Set a fixed count for shimmer effect
                itemBuilder: (context, index, realIndex) {
                  return getCategoryRow(index);
                },
                options: CarouselOptions(
                    height: 300,
                    aspectRatio: 15 / 6,
                    viewportFraction: .6,
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
              itemCount: categorylist == null ? 0 : categorylist?.length,
              itemBuilder: (context, index, realIndex) {
                return getCategoryRow(index);
              },
              options: CarouselOptions(
                height: 300,
                aspectRatio: 15 / 6,
                viewportFraction: .6,
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
          Heading(text: "Popular Items"),
          Container(
            child: isLoading
                ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: .95,
                ),
                itemCount: 8, // Set a fixed count for shimmer effect
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: .95,
              ),
              itemCount: Finalpopularlist == null ? 0 : Finalpopularlist?.length,
              itemBuilder: (context, index) => getPopularRow(index),
            ),
          ),

          Heading(text: "Top Picks For You"),
          Container(
              child: isLoadingCategories
                  ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CarouselSlider.builder(
                  itemCount: categorylist == null ? 0 : categorylist?.length,
                  itemBuilder: (context, index, realIndex) {
                    return getCategoryRow(index);
                  },
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 15 / 6,
                    viewportFraction: .8,
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
                itemCount:
                categorylist == null ? 0 : categorylist?.length,
                itemBuilder: (context, index, realIndex) {
                  return getCategoryImage(index);
                },
                options: CarouselOptions(
                  height: 200,
                  aspectRatio: 15 / 6,
                  viewportFraction: .8,
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
              )),
          Heading(text: "All Items"),
          Container(
            child: isLoading
                ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: 10, // Set a fixed count for shimmer effect
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
                : ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: Finalproductlist == null ? 0 : Finalproductlist?.length,
              itemBuilder: (context, index) => getProducts(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget getPopularRow(int index) {

    var image = base! + (Finalpopularlist![index]["image"] ?? "" ).toString();
    var itemName = (Finalpopularlist![index]["combinationName"] ?? "").toString();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(
              id: Finalpopularlist![index]["id"].toString(),
              productname: Finalpopularlist![index]["combinationName"].toString(),
              url: image,
              description: Finalpopularlist![index]["description"].toString(),
              amount: Finalpopularlist![index]["combinationPrice"].toString(),
              combinationId: Finalpopularlist![index]["combinationId"].toString(),
              quantity: Finalpopularlist![index]["quantity"].toString(),
              category: Finalpopularlist![index]["category"].toString(),
              psize: Finalpopularlist![index]["combinationSize"].toString(),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(clipBehavior: Clip.antiAlias,decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(360),color: Colors.white
          ),
            width: 60,
            height: 50,
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
            height: 3,
          ),
          Text(
            itemName,style: TextStyle(
            fontSize: 12,color: Colors.black
          ),
          ),
        ],
      ),
    );
  }


  Widget getCategoryImage(int index) {
    if (categorylist == null) {
      return Container();
    }
    var image = base! + categorylist![index]["image"];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Category_View(
                  url: image,
                  itemname: categorylist![index]["name"].toString(),
                  description: categorylist![index]["description"].toString(),
                  price: categorylist![index]["price"].toString(),
                  id: categorylist![index]["id"],
                ),
          ),
        );
      },
      child: Container(
        height: 200,
        width: 330,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image:
            DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
      ),
    );
  }

  Widget getCategoryRow(int index) {
      if (categorylist == null) {
        return Container(); // Handle the case when categorylist is null
      }
    var image = base! + categorylist![index]["image"];
    var itemName = categorylist![index]["name"].toString();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Category_View(
                  url: image,
                  itemname: categorylist![index]["name"].toString(),
                  description: categorylist![index]["description"].toString(),
                  price: categorylist![index]["price"].toString(),
                  id: categorylist![index]["id"],
                ),
          ),
        );
      },
      child: Container(
        height: 300,
        width: 250,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
            image:
            DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: TextConst(text:
                itemName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getProducts(int index) {
    if (Finalproductlist == null || Finalproductlist![index] == null) {
      return Container();
    }

    var image = base! + (Finalproductlist![index]["image"] ?? "").toString();
    var price = "₹" + (Finalproductlist![index]["combinationPrice"] ?? "").toString();
    var PID = (Finalproductlist![index]["id"] ?? "").toString();
    var CombID = (Finalproductlist![index]["combinationId"] ?? "").toString();

    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductView(
                id: PID,
                productname: Finalproductlist![index]["combinationName"].toString(),
                url: image,
                description: Finalproductlist![index]["description"].toString(),
                amount: price,
                combinationId: CombID,
                quantity: Finalproductlist![index]["quantity"].toString(),
                category: Finalproductlist![index]["category"].toString(),
                psize: Finalproductlist![index]["combinationSize"].toString(),
              ),
            ),
          );
        },
        title: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(60),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/noItem.png"),
                            ),
                          ),
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Finalproductlist == null
                          ? Text("null data")
                          : TextConst(text: Finalproductlist![index]["combinationName"].toString()),
                      SizedBox(
                        height: 10,
                      ),
                      TextConst(text: Finalproductlist![index]["description"].toString()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            addTowishtist(PID, CombID);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[900],
            shadowColor: Colors.teal[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
          child: Icon(Icons.favorite_sharp),
        ),
      ),
    );
  }

  Widget getOrderList(int index) {
    var image = base! + orderList![index]["image"].toString();
    return Card(
        color: Colors.grey.shade50,
        child: InkWell(
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(40), // Image radius
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            orderList == null
                              ? Text("null data")
                              : TextConst(text:"Order Placed",
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextConst(text:
                              orderList![index]["cartName"].toString(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
