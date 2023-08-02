import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';


class OrderDetails extends StatefulWidget {
  final String id;

  const OrderDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final TextEditingController reasonController = TextEditingController();
  String? base = "https://meatoz.in/basicapi/public/";
  String? UID;
  Map? order;
  Map? order1;
  List? orderList;


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

  getMyOrders() async {
    var response =
    await ApiHelper().post(endpoint: "common/getOrderDetails", body: {
      "orderid": widget.id,
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
        title: AppText(text:
          "ORDER HISTORY",
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
                ])
        ),
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
    var image = base! + orderList![index]["image"].toString();
    var price = "₹ " + orderList![index]["price"].toString();
    return Card(
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width:150,
                height: 100,
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
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  orderList == null
                      ? Text("null data")
                      : Text(
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
                    orderList![index]["product"].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    orderList![index]["address"].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
