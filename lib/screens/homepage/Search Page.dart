import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meatoz/Components/discriptiontext.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../product_view/Product_view.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  String? uID;
  Map? search;
  Map? search1;
  List? searchList;
  String? searchKeyword;

  int index = 0;
  bool isLoading = true;

  Map? prList;
  Map? prList1;
  List? finalPrList;

  removeFromWishList(String id) async {
    var response =
        await ApiHelper().post(endpoint: "wishList/removeByCombination", body: {
      "userid": uID,
      "product_id": id,
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add-wishlist api successful:');
        // print("remove" + response);
        wishListGet();
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

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });

    wishListGet();
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  addToWishList(String id, String combId, String amount) async {
    var response = await ApiHelper().post(endpoint: "wishList/add", body: {
      "userid": uID,
      "productid": id,
      "combination": combId,
      "amount": amount
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('add wishlist api successful:');

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

  void _performSearch() async {
    setState(() {
      searchKeyword = _searchController.text.trim();
    });

    var response = await ApiHelper().post(endpoint: "common/allSearch", body: {
      "key": searchKeyword,
      "offset": "0",
      "pageLimit": "10",
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('search successful:');
        search = jsonDecode(response);
        search1 = search!["data"];
        searchList = search1!["pageData"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            text: "Search Items",
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.teal[900],
                ),
              )
            : Container(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Type product name to search items',
                            prefixIcon: IconButton(
                              icon: Icon(
                                Iconsax.close_square,
                              ),
                              onPressed: () => _searchController.clear(),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Iconsax.search_normal_1,
                              ),
                              onPressed: _performSearch,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: searchList == null ? 0 : searchList?.length,
                      itemBuilder: (context, index) => getSearchList(index),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget getSearchList(int index) {
    var image = UrlConstants.base + searchList![index]["image"].toString();
    var price = searchList![index]["offerPrice"].toString();
    var pId = searchList![index]["id"].toString();
    var combId = searchList![index]["combinationId"].toString();

    bool isInWishlist = finalPrList != null &&
        finalPrList!.any((item) => item['combinationId'].toString() == combId);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(
                noOfPiece: searchList![index]["no_of_piece"].toString(),
                serveCapacity:
                searchList![index]["serving_cupacity"].toString(),
                stock: searchList![index]["stock"].toString(),
                recipe: searchList![index]["hint"].toString(),
                position: index,
                id: searchList![index]["id"].toString(),
                productName: searchList![index]["name"].toString(),
                url: image,
                description: searchList![index]["description"].toString(),
                amount: price,
                combinationId: searchList![index]["id"].toString(),
                pSize: "0"),
          ),
        );
      },
      child: Card(
          color: Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      height: 70,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: Size.fromRadius(40), // Image radius
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
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "₹$price",
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:  Color(ColorT.themeColor),),
                        ),
                        IconButton(
                          icon: Icon(
                            isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                            color: isInWishlist ? Colors.red : Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            if (isInWishlist) {
                              removeFromWishList(combId);
                              wishListGet();
                            } else {
                              // The item is not in the wishlist, you may want to add it.
                              addToWishList(pId, combId, price);
                              wishListGet();
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      searchList == null
                          ? Text("null data")
                          : Text(
                        searchList![index]["name"].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      TextDescription(text:
                        searchList![index]["description"].toString(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
