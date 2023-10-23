import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meatoz/screens/placeOrder/place_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/appbar_text.dart';
import '../../Components/text_widget.dart';
import '../../Config/api_helper.dart';
import '../../theme/colors.dart';
import '../accounts/add_address.dart';
import '../accounts/faq_page.dart';

class SetectAddress extends StatefulWidget {
  const SetectAddress({Key? key}) : super(key: key);

  @override
  State<SetectAddress> createState() => _SetectAddressState();
}

class _SetectAddressState extends State<SetectAddress> {
  String? uID;
  Map? address;
  List? addressList;

  Map? offerList;
  Map? finalOfferList;

  String? totalAmount;

  bool isLoading = true;

  ///CartList
  Map? cartList;
  List? finalCartList;
  List? cartDiscountList;
  List? cartDiscountAppliedList;

  // int discountAmount = 0;
  // double discountAmount1 = 0;
  // String? discountAmountTotal;

  double subtotal = 0;
  double subtotal1 = 0;

  String? subTotalForApi;
  int? firstPurchaseAmount;

  apiForCart() async {
    if (uID != null) {
      var response = await ApiHelper().post(endpoint: "cart/get", body: {
        "userid": uID,
      }).catchError((err) {});

      setState(() {
        isLoading = false;
      });

      if (response != null) {
        setState(() {
          debugPrint('cart page successful:');
          cartList = jsonDecode(response);
          finalCartList = cartList!["cart"];
          cartDiscountAppliedList = cartList!["cartAppliedDiscounts"];
          print(response);

          if (finalCartList != null && finalCartList!.isNotEmpty) {
            for (int i = 0; i < finalCartList!.length; i++) {
              int price =
                  finalCartList![i]["price"] * finalCartList![i]["quantity"];
              subtotal1 = subtotal1 + price;
            }
          }
          print(subtotal1);
          subTotalForApi = subtotal1.toString();
          firstPurchaseOffer();
        });
      } else {
        debugPrint('api failed:');
      }
    }
  }

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
    apiForCart();
  }

  firstPurchaseOffer() async {
    var response = await ApiHelper().post(
      endpoint: "discount/getFirstPurchaseOffer",
      body: {
        "user_id": uID,
        "total_amount": subTotalForApi.toString(),
      },
    ).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('first purchase api successful:');
        offerList = jsonDecode(response);
        finalOfferList = offerList!["firstPurchaseOffer"];
        print(finalOfferList);

        firstPurchaseAmount = finalOfferList?["discountAmount"] ?? 0;
        print(firstPurchaseAmount!);
      });
    } else {
      debugPrint('api failed:');
    }
  }

  void showCustomSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[400],
        duration: Duration(seconds: 5),
        content: Column(
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
        title: AppText(
          text: "Select your Address",
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return FAQ(
                        section: "edit_address",
                      );
                    }),
                  ),
              icon: Icon(Icons.help_outline_rounded))
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return AddAddress();
              }),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(ColorT.themeColor),
            shadowColor: Colors.teal[300],
            minimumSize: Size.fromHeight(50),
          ),
          child: Text("Add New Address"),
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
            ])),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            (addressList == null && isLoading)
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
                      TextConst(
                        text: "Your Order will be shipped to this address",
                      ),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            addressList == null ? 0 : addressList?.length,
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // Show a dialog with CircularProgressIndicator
            return AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Color(ColorT.themeColor),
                  ),
                ],
              ),
            );
          },
        );
        // Set a timer
        Timer(Duration(seconds: 3), () {
          // After 3 seconds, navigate to PlaceOrder
          Navigator.pop(context); // Close the dialog
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceOrder(
                firstPurchase: firstPurchaseAmount!.toInt(),
                id: addressList![index]["id"].toString(),
                pinCode: addressList![index]["pincode"].toString(),
              ),
            ),
          );
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         PlaceOrder(
        //           firstPurchase: firstPurchaseAmount!.toInt(),
        //           id: addressList![index]["id"].toString(),
        //           pinCode: addressList![index]["pincode"].toString(),
        //         ),
        //   ),
        // );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                addressList![index]["address"].toString(),
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 5),
              TextConst(text: addressList![index]["phone"].toString()),
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
