import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';
import '../accounts/FAQ_page.dart';
import 'Orderdetails.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  String? base = "https://meatoz.in/basicapi/public/";
  String? UID;
  String? ORDERID;
  Map? order;
  Map? order1;
  List? orderList;

  bool isButtonVisible = true;

  Map? Orderreturn;
  Map? returnlist;
  final TextEditingController reasonController = TextEditingController();

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
      print(UID);
    });
    getMyOrders();
  }

  CancelOrderApi() async {
    var response = await ApiHelper().post(endpoint: "Orders/cancel", body: {
      "orderId": ORDERID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('cancel api successful:');
        Orderreturn = jsonDecode(response);
        returnlist = Orderreturn!["data"];
        Fluttertoast.showToast(
          msg: "order cancelled successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // isButtonVisible = false;
      });
    } else {
      debugPrint('api failed:');
    }
  }

  getMyOrders() async {
    var response =
        await ApiHelper().post(endpoint: "common/getMyOrders", body: {
      "userid": UID,
      "offset": "0",
      "pageLimit": "10",
    }).catchError((err) {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "MY ORDERS",
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
        child: ListView.builder(
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
    var image = base! + orderList![index]["image"].toString();
    var price = "₹ " + orderList![index]["total"].toString();
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
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.green.shade300,
                            borderRadius: BorderRadius.circular(10)),
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
                        style: const TextStyle(fontWeight: FontWeight.bold),textScaleFactor: 1.2,
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
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green),
                        ),
                        Text(
                          "Amount Paid: ₹ " +
                              orderList![index]["amount_paid"].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          orderList![index]["address"].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          orderList![index]["date"].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (!isOrderCancelled && isButtonVisible)
                      ElevatedButton(
                        onPressed: () {
                          ORDERID = orderList![index]["id"].toString();
                          print(ORDERID);
                          if (!isOrderCancelled) {
                            CancelOrderApi();
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
