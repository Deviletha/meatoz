import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';
import '../../theme/colors.dart';
import '../accounts/faq_page.dart';
import 'Orderdetails.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  String? uID;
  String? orderID;
  Map? order;
  Map? order1;
  List? orderList;

  bool isButtonVisible = true;

  Map? orderReturn;
  Map? returnList;
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
      print(uID);
    });
    getMyOrders();
  }

  cancelOrderApi() async {
    var response = await ApiHelper().post(endpoint: "Orders/cancel", body: {
      "orderId": orderID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cancel api successful:');
        orderReturn = jsonDecode(response);
        returnList = orderReturn!["data"];
        Fluttertoast.showToast(
          msg: "order cancelled successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        getMyOrders();
        // isButtonVisible = false;
      });
    } else {
      debugPrint('api failed:');
    }
  }

  getMyOrders() async {
    var response =
        await ApiHelper().post(endpoint: "common/getMyOrders", body: {
      "userid": uID,
      "offset": "0",
      "pageLimit": "10",
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('order details api successful:');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "My Orders",
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return FAQ(
                    section: "orders",
                  );
                }),
              ), icon: Icon(Icons.help_outline_rounded))
        ],
      ),
      body: orderList == null || orderList!.isEmpty
          ? Container(
        color: Colors.white,
            child: Center(
        child: Lottie.asset(
              "assets/emptyOrder.json",
              height: 300,
              repeat: true),
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
        child:  ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: orderList == null ? 0 : orderList?.length,
          itemBuilder: (context, index) => getOrderList(index),
        ),
      ),
    );
  }

  Widget getOrderList(int index) {

    bool isOrderCancelled = orderList![index]["status_note"].toString().toLowerCase() == "cancelled";
    var image = UrlConstants.base + orderList![index]["image"].toString();
    var price = "₹ ${orderList![index]["total"]}";
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
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
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
                    Positioned(
                      right: 3,
                      top: 8,
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: orderList![index]["status_note"] == "Cancelled"
                              ? Colors.red.shade300
                              : Colors.green.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            orderList![index]["status_note"].toString(),
                          ),
                        ),
                      ),

                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                orderList == null
                    ? Text("null data")
                    : Text(
                        orderList![index]["cartName"].toString(),
                        style:  TextStyle(fontSize:15,),textScaleFactor: 1.2,
                  textAlign: TextAlign.center,
                      ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          price,
                          style:  TextStyle(
                              fontSize: 14,
                              color: Color(ColorT.themeColor)),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Amount Paid: ₹ ${orderList![index]["amount_paid"]}",
                          style:  TextStyle(
                              fontSize: 14,
                              color: Color(ColorT.themeColor)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          orderList![index]["address"].toString(),
                          // style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          orderList![index]["date"].toString(),
                          // style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (!isOrderCancelled && isButtonVisible)
                      ElevatedButton(
                        onPressed: () {
                          orderID = orderList![index]["id"].toString();
                          print(orderID);
                          if (!isOrderCancelled) {
                            cancelOrderApi();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[300],
                          shadowColor: Colors.red[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text("Cancel",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
