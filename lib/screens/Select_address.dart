import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meatoz/screens/place_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../Config/ApiHelper.dart';

class SetectAddress extends StatefulWidget {
  const SetectAddress({Key? key}) : super(key: key);

  @override
  State<SetectAddress> createState() => _SetectAddressState();
}

class _SetectAddressState extends State<SetectAddress> {
  String? UID;
  int index = 0;
  Map? address;
  List? Addresslist;

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
    getUserAddress();
  }

  getUserAddress() async {
    var response = await ApiHelper().post(endpoint: "user/getAddress", body: {
      "userid": UID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('get address api successful:');
        address = jsonDecode(response);
        Addresslist = address!["status"];

      });
    } else {
      debugPrint('api failed:');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select your Address",
          style: TextStyle(
            color: Colors.teal[900],
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Addresslist == null
              ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.white,
                ),
              ],
            ),
          )
              : Column(
            children: [
              Text(
                "Your Order will be shipped to this address",
                style: TextStyle(fontSize: 15),
              ),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: Addresslist == null ? 0 : Addresslist?.length,
                itemBuilder: (context, index) => getAddressRow(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getAddressRow(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceOrder(
              id: Addresslist![index]["id"].toString(),
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Addresslist == null
                  ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
              )
                  : Text(
                Addresslist![index]["address"].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                Addresslist![index]["phone"].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 5),
              Text(
                Addresslist![index]["city"].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                Addresslist![index]["pincode"].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                Addresslist![index]["state"].toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
