import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meatoz/screens/placeOrder/place_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/appbar_text.dart';
import '../../Components/text_widget.dart';
import '../../Config/api_helper.dart';


class SetectAddress extends StatefulWidget {
  const SetectAddress({Key? key}) : super(key: key);

  @override
  State<SetectAddress> createState() => _SetectAddressState();
}

class _SetectAddressState extends State<SetectAddress> {
  String? uID;
  Map? address;
  List? addressList;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
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
            children: const [
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
      "userid": uID,
    }).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('get address api successful:');
        address = jsonDecode(response);
        addressList = address!["status"];
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
            addressList == null
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
                  itemCount: addressList == null ? 0 : addressList?.length,
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
    if (addressList == null || addressList!.isEmpty) {
      return Container(); // Return an empty container or another widget when Addresslist is null or empty.
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlaceOrder(
                  id: addressList![index]["id"].toString(),
                  pinCode: addressList![index]["pincode"].toString(),
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
              TextConst(text: addressList![index]["address"].toString()),
              SizedBox(height: 5),
              Text(
                addressList![index]["phone"].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 5),
              TextConst(text: addressList![index]["city"].toString()),
              SizedBox(height: 5),
              TextConst(text: addressList![index]["pincode"].toString()),
              SizedBox(height: 5),
              TextConst(text: addressList![index]["state"].toString()),
            ],
          ),
        ),
      ),
    );
  }
}