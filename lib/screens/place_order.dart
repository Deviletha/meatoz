import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/ApiHelper.dart';
import 'Orders_page.dart';

class PlaceOrder extends StatefulWidget {
  final String id;

  const PlaceOrder({Key? key, required this.id}) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  String? UID;
  Map? order;
  Map? orderlist;
  List? FinalOrderlist;

  final tipController = TextEditingController();
  final noteController = TextEditingController();

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
  }

  PlaceOrderApi() async {
    var response = await ApiHelper().post(endpoint: "cart/placeOrder", body: {
      "id": UID,
      "address": widget.id,
      "amount": " ",
      "paid": "1",
      "latitude": "1234",
      "longitude": "1234",
      "delivery_note": noteController.text,
      "tip": tipController.text
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('place order api successful:');
        order = jsonDecode(response);
        orderlist = order!["data"];
        FinalOrderlist = orderlist!["pageData"];

        Fluttertoast.showToast(
          msg: "Order Placed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      );Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyOrders(),
        ),
      );
    } else {
      debugPrint('place order api failed:');

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: TextFormField(
                  controller: tipController,
                  decoration: InputDecoration(
                    labelText: "Tip (if any)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'tip';
                    } else {
                      return null;
                    }
                  },
                  textInputAction: TextInputAction.done,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: "Enter Delivery Note",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter delivery note';
                    } else {
                      return null;
                    }
                  },
                  textInputAction: TextInputAction.done,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  PlaceOrderApi();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shadowColor: Colors.teal[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                ),
                child: Text("Place Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
