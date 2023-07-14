import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/ApiHelper.dart';
import 'Product_view.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? base = "https://meatoz.in/basicapi/public/";
  String? UID;
  Map? search;
  Map? search1;
  List? searchlist;
  String? searchKeyword;
  Map? productlist;
  Map? productlist1;
  List? Finalproductlist;
  int index = 0;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  addTowishtist(
    String id,
      String Comid
  ) async {
    var response = await ApiHelper().post(endpoint: "wishList/add", body: {
      "userid": UID,
      "productid": id,
      "combination": Comid
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('addwishlist api successful:');
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
        searchlist = search1!["pageData"];
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
          title: Text(
            "Search Items",
            style: TextStyle(color: Colors.teal[900]),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _performSearch,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
            Container(
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchlist == null ? 0 : searchlist?.length,
                itemBuilder: (context, index) => getSearchList(index),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getSearchList(int index) {
    var image = base! + searchlist![index]["image"].toString();
    var price = "₹" + searchlist![index]["price"].toString();
    var PID =  searchlist![index]["id"].toString();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductView(
                id: searchlist![index]["id"].toString(),
                productname: searchlist![index]["name"].toString(),
                url: image,
                description: searchlist![index]["description"].toString(),
                amount: price,
                combinationId: searchlist![index]["id"].toString(),
                quantity: searchlist![index]["quantity"].toString(),
                category: searchlist![index]["categories"].toString(),
                psize: "0"),
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
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      searchlist == null
                          ? Text("null data")
                          : Text(
                              searchlist![index]["name"].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        searchlist![index]["description"].toString(),
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            addTowishtist(
                             PID,PID
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shadowColor: Colors.teal[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              )),
                          child: Icon(
                            Icons.favorite_outlined,
                            color: Colors.white,
                          ))
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
