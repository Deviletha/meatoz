import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meatoz/screens/placeOrder/place_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/appbar_text.dart';
import '../../Components/text_widget.dart';
import '../../Config/ApiHelper.dart';


class SetectAddress extends StatefulWidget {
  const SetectAddress({Key? key}) : super(key: key);

  @override
  State<SetectAddress> createState() => _SetectAddressState();
}

class _SetectAddressState extends State<SetectAddress> {
  String? UID;
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
    });
    getUserAddress();
  }

  // checkPincode(String pin, int position) async {
  //   var response = await ApiHelper().post(
  //     endpoint: "postal/checkAvailabilityAtCheckout",
  //     body: {
  //       "userid": UID,
  //       "pincode": pin,
  //     },
  //   ).catchError((err) {});
  //   if (response != null) {
  //     setState(() {
  //       debugPrint('check pin code api successful:');
  //       pincode = jsonDecode(response);
  //       pincodeList = pincode!["orderData"];
  //       int pincodeAvailability = pincodeList![position]["pincode_availability"];
  //       if (pincodeAvailability == 0) {
  //         showCustomSnackBar(context);
  //       }
  //       String expressDeliveryStatus = pincodeList![position]["express_delivery_available"];
  //       print("Express Delivery Status: $expressDeliveryStatus");
  //     });
  //   } else {
  //     debugPrint('api failed:');
  //   }
  // }


  void showCustomSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 5),
        content: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Delivery is not available in this pincode.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Please use another address.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
        title: AppText(text:
        "Select your Address",
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
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
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
                TextConst(text:
                "Your Order will be shipped to this address",
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
      ),
    );
  }

  Widget getAddressRow(int index) {
    if (Addresslist == null || Addresslist!.isEmpty) {
      return Container(); // Return an empty container or another widget when Addresslist is null or empty.
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlaceOrder(
                  id: Addresslist![index]["id"].toString(),
                  picode: Addresslist![index]["pincode"].toString(),
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
              TextConst(text: Addresslist![index]["address"].toString()),
              SizedBox(height: 5),
              Text(
                Addresslist![index]["phone"].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 5),
              TextConst(text: Addresslist![index]["city"].toString()),
              SizedBox(height: 5),
              TextConst(text: Addresslist![index]["pincode"].toString()),
              SizedBox(height: 5),
              TextConst(text: Addresslist![index]["state"].toString()),
            ],
          ),
        ),
      ),
    );
  }
}