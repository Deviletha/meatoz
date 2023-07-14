import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/ApiHelper.dart';
import '../constants/appbar_text.dart';
import '../constants/text_widget.dart';
import 'Login_page.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  String? UID;
  bool isLoading = true;
  bool isLoggedIn = false;
  GlobalKey<RefreshIndicatorState> refreshKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    setState(() {
      isLoggedIn = UID != null;
      print(UID);
    });
    if (isLoggedIn) {
      APIcall();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String? base = "https://meatoz.in/basicapi/public/";
  var WID;
  Map? wslist;
  List? WsList;

  Map? prlist;
  Map? prlist1;
  List? Prlist;
  int index = 0;

  Future<void> APIcall() async {
    setState(() {
      isLoading = true;
    });

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

      });
    } else {
      debugPrint('api failed:');

    }
  }

  Future<void> removeFromWishtist(String id) async {
    var response = await ApiHelper().post(endpoint: "wishList/remove", body: {
      "id": id,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('Remove api successful:');
        prlist = jsonDecode(response);
        wslist = prlist!["pagination"];
        WsList = wslist!["pageData"];

        Fluttertoast.showToast(
          msg: "Removed product",
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

  Future<void> refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    await APIcall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText(text: "WISHLIST",),
      backgroundColor: Colors.teal[900],
        elevation: 10,
        centerTitle: true,
      ),
      body: isLoggedIn
          ? isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Prlist == null || Prlist!.isEmpty
          ? Center(
        child: Image.asset("assets/wishlist-empty.jpg"),
      )
          : RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshPage,
        child: ListView.builder(
          itemCount: Prlist == null ? 0 : Prlist?.length ?? 0,
          itemBuilder: (context, index) => getWishlist(index),
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/img_1.png"),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage())
                );
              },style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[900],
                shadowColor: Colors.teal[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                )),
              child: Text(
                "Please LogIn",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getWishlist(int index) {
    var image = base! + Prlist![index]["image"];
    var price = "₹ " + Prlist![index]["combinationPrice"].toString();
    WID = Prlist![index]["wishlistId"].toString();
    return Card(
      child: ListTile(
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
                      borderRadius: BorderRadius.circular(20), // Image border
                      child: SizedBox.fromSize(
                        size: Size.fromRadius(60), // Image radius
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
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Prlist == null
                            ? Text("null data")
                            : TextConst(text:
                          Prlist![index]["name"].toString(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextConst(text:
                          Prlist![index]["description"].toString(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
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
          trailing: TextButton(
            onPressed: () {
              removeFromWishtist(WID);
            },
            child: Text(
              "Remove",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}
