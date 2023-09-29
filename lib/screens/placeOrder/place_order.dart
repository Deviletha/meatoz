import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meatoz/screens/placeOrder/widget/offer_card.dart';
import 'package:meatoz/screens/placeOrder/widget/subscription_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/Amount_Row.dart';
import '../../Components/CustomRow.dart';
import '../../Components/Title_widget.dart';
import '../../Components/text_widget.dart';
import '../../Config/ApiHelper.dart';
import '../orders/Orders_page.dart';

class PlaceOrder extends StatefulWidget {
  final String id;
  final String picode;

  const PlaceOrder({
    Key? key,
    required this.id,
    required this.picode,
  }) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  bool isContactless = false;
  String? CONTACTLESS;
  String? UID;
  int index = 0;

  final couponController = TextEditingController();

  ///OrderList
  Map? order;
  Map? orderlist;
  List? FinalOrderlist;

  ///Delivery slot List
  Map? slot;
  Map? slotlist;
  List? todaySlotList;
  List? tomorrowSlotList;

  ///General data's list
  String? SLOTID;
  String? SLOTDATE;
  String? SHIPPINGCHARGE;
  String? PACKINGCHARGE;
  String? SUBTOTAL;
  String? CARTTOTAL;
  String? GRANDTOTAL;
  String? WALLET_AMOUNT_VALUE;
  String? DISCOUNTID;
  String? PRODUCTID;
  String? SUBTOTALFIRSTPURCHASE;

  int GRNDAMNT = 0;
  int DSCOUNTAMOUNT = 0;
  int NETPAYABLEAFTERDISCOUNT = 0;
  double WALLET_AMOUNT = 0;
  double WALLET_AMOUNT_L = 0;

  String? expressDeliveryAvailable;
  String? expressDeliveryStatus;

  Map? list;
  List? genralList;

  ///CartList
  Map? clist;
  List? CartList;
  List? cartDiscountList;

  ///DiscountList
  Map? discount;
  Map? discountList;

  ///FirstPurchaseDiscountList
  Map? firstPurchase;
  Map? finalFirstPurchase;

  ///WalletAmountList
  Map? wallet;
  List? walletList;

  ///Pin codeList
  Map? pincode;
  List? pincodeList;

  double subtotal = 0;
  double subtotal1 = 0;

  late double subtotalfrmfirstpuchase;

  int discountAmount = 0;

  Map? plan;
  List? planList;
  double subscriptionPlanAmount = 0;
  bool isExpressDeliverySelected = false;

  final tipController = TextEditingController();
  final noteController = TextEditingController();

  int? selectedTodaySlotIndex;
  int? selectedTomorrowSlotIndex;

  bool isTodaySlotsVisible = true;
  bool isTomorrowSlotsVisible = true;
  bool isLoading = true;
  bool hidePlaceOrderButton = false;


  checkPincode() async {
    var response = await ApiHelper().post(
      endpoint: "postal/checkAvailabilityAtCheckout",
      body: {
        "userid": UID,
        "pincode": widget.picode,
      },
    ).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('check pin code api successful:');
        pincode = json.decode(response);
        pincodeList = pincode!["orderData"];
        print(pincodeList);

        discountAmount = pincodeList![0]["first_purchase_discount"];
        print(discountAmount);
        // apiForCart();

        int pincodeAvailability = pincodeList![0]["pincode_availability"];
        if (pincodeAvailability == 0) {
          hidePlaceOrderButton = true;
          showCustomSnackBar(context);
        }

        expressDeliveryAvailable =
            pincodeList![0]["express_delivery_available"];

        if (expressDeliveryAvailable == "available") {
          int expressDelivery = pincodeList![0]["express_delivery"];
          if (expressDelivery == 1) {
            expressDeliveryStatus = "available";
          } else {
            expressDeliveryStatus = "not available";
          }
        } else {
          expressDeliveryStatus = "not available";
        }
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

  // @override
  // void dispose() {
  //   couponController.dispose();
  //   tipController.dispose();
  //   noteController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    checkUser();
    setVisibilityFlags();
    super.initState();
  }

  // bool _isApplied = false;
  //
  // void _onApplyButtonPressed() {
  //   // Call the apiForDiscounts() function here or perform any other actions
  //   apiForDiscounts();
  //   // Update the state to toggle the button text
  //   setState(() {
  //     _isApplied = true;
  //   });
  // }

  void setVisibilityFlags() {
    if (todaySlotList == null || todaySlotList!.isEmpty) {
      isTodaySlotsVisible = true;
      isTomorrowSlotsVisible = true;
    }
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
    });
    deliverySlotApi();
    setVisibilityFlags();
    generalDetailsApi();
    apiForWalletAmount();
    apiForCheckplan();
    checkPincode();
    apiForCart();
  }

  apiForCart() async {
    if (UID != null) {
      var response = await ApiHelper().post(endpoint: "cart/get", body: {
        "userid": UID,
      }).catchError((err) {});

      setState(() {
        isLoading = false;
      });

      if (response != null) {
        setState(() {
          debugPrint('cartpage successful:');
          clist = jsonDecode(response);
          CartList = clist!["cart"];
          cartDiscountList = clist!["cartDiscountForAllProduct"];

          if (CartList != null && CartList!.isNotEmpty) {
            if (cartDiscountList != null && cartDiscountList!.isNotEmpty) {
              DISCOUNTID = cartDiscountList![index]["id"].toString();
            } else {
              DISCOUNTID = "0";
            }
            PRODUCTID = CartList![index]["product_id"].toString();
          }
          if (CartList != null && CartList!.isNotEmpty) {
            for (int i = 0; i < CartList!.length; i++) {
              int price = CartList![i]["price"];
              subtotal1 = subtotal1 + price;
            }
          }

          subtotalfrmfirstpuchase = discountAmount.toDouble();
          print(subtotalfrmfirstpuchase);
          SUBTOTALFIRSTPURCHASE = subtotalfrmfirstpuchase.toString();
          subtotal = subtotal1 - WALLET_AMOUNT - subtotalfrmfirstpuchase;
          SUBTOTAL = subtotal.toString();

          if (subtotalfrmfirstpuchase != 0) {
            Fluttertoast.showToast(
              msg:
                  "First Purchase Offer Discount Applied Rs. $subtotalfrmfirstpuchase",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          }
        });
      } else {
        debugPrint('api failed:');
      }
    }
  }

  apiForDiscounts() async {
    var responseDiscount = await ApiHelper().post(
        endpoint: "discount/applyDiscountAtCart",
        body: {
          "user_id": UID,
          "discount_id": DISCOUNTID,
          "product_id": PRODUCTID
        }).catchError((err) {});

    setState(() {
      isLoading = false;
    });
    if (responseDiscount != null) {
      setState(() {
        debugPrint('Apply discount api successful:');
        discount = jsonDecode(responseDiscount);
        discountList = discount!["discountAmount"];

        DSCOUNTAMOUNT = discountList!["discountAmount"].toInt();
        print("dscnt amt$DSCOUNTAMOUNT");

        NETPAYABLEAFTERDISCOUNT = GRNDAMNT - DSCOUNTAMOUNT;
        print("netpayable after discount$NETPAYABLEAFTERDISCOUNT");
        GRANDTOTAL = NETPAYABLEAFTERDISCOUNT.toString();
      });
    } else {
      debugPrint('discount api failed:');
    }
  }

  // apiForFirstPurchaseOffer() async {
  //   var response = await ApiHelper().post(
  //     endpoint: "discount/getFirstPurchaseOffer",
  //     body: {
  //       "user_id": UID,
  //       "total_amount": subtotal1.toString(),
  //     },
  //   ).catchError((err) {});
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  //
  //   if (response != null) {
  //     setState(() {
  //       debugPrint('Apply first purchase api successful:');
  //       firstPurchase = json.decode(response);
  //       finalFirstPurchase = firstPurchase!["firstPurchaseOffer"];
  //       print(response);
  //
  //       bool status = finalFirstPurchase!["status"];
  //       if (status) {
  //         discountAmount = finalFirstPurchase!["discountAmount"];
  //         print(discountAmount);
  //         subtotalfrmfirstpuchase = (subtotal2 - discountAmount);
  //         SUBTOTALFIRSTPURCHASE = subtotalfrmfirstpuchase.toString();
  //         print("subtotal after first purchase offer: ${SUBTOTALFIRSTPURCHASE!}");
  //       }
  //     });
  //   } else {
  //     debugPrint('first purchase api failed:');
  //   }
  // }

  apiForWalletAmount() async {
    var responseWallet = await ApiHelper().post(endpoint: "wallet", body: {
      "userid": UID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });
    if (responseWallet != null) {
      setState(() {
        debugPrint('Wallet successful:');
        wallet = jsonDecode(responseWallet);
        walletList = wallet!["walletAmount"];

        if (walletList != null && walletList!.isNotEmpty) {
          WALLET_AMOUNT_L = walletList![index]["wallet_amount"].toDouble();
          WALLET_AMOUNT = WALLET_AMOUNT_L;
        }
        print("API Response: $responseWallet");
      });
    } else {
      debugPrint('wallet api failed:');
    }
  }

  apiForCheckplan() async {
    var response =
        await ApiHelper().post(endpoint: "subscriptionPlan/PaidOrNot", body: {
      "userid": UID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('Plan check api successful:');
        plan = jsonDecode(response);
        planList = plan!["planDetails"];
        print("plan amount " + response);

        // Check if the plan is unpaid and store the plan amount in the variable.
        if (planList != null &&
            planList!.isNotEmpty &&
            planList![0]["paid_status"] == "Unpaid") {
          subscriptionPlanAmount =
              double.parse(planList![0]["amount"].toString());
        } else {
          subscriptionPlanAmount = 0;
        }
      });
    } else {
      debugPrint('api failed:');
    }
  }

  deliverySlotApi() async {
    var response = await ApiHelper()
        .post(endpoint: "deliverySlot/get", body: {}).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('slot api successful:');
        slot = jsonDecode(response);
        slotlist = slot!["slots"];
        todaySlotList = slotlist?["today"]; // Add null check
        tomorrowSlotList = slotlist?["tomorrow"];

        todaySlotList = slotlist?["today"] ?? [];
        tomorrowSlotList = slotlist?["tomorrow"] ?? [];
        // Add null check
        // print("slotid" + SLOTID!);
        // print("slotdate" + SLOTDATE!);
      });
    } else {
      apiForWalletAmount();
      debugPrint('api failed:');
    }

    setState(() {
      isLoading = false;
    });
  }

  generalDetailsApi() async {
    var response = await ApiHelper()
        .post(endpoint: "generalInfo/get", body: {}).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('general detailsapi successful:');
        list = jsonDecode(response);
        genralList = list!["general_info"];
        SHIPPINGCHARGE =
            genralList![index]["delivery_charge"]?.toString() ?? "0";
        PACKINGCHARGE = genralList![index]["packing_charge"]?.toString() ?? "0";

        double expressDeliveryCharge = 0.0;

        if (isExpressDeliverySelected && genralList != null) {
          expressDeliveryCharge = double.parse(
              genralList![index]["express_delivery_charge"].toString());
        }

        double AMOUNT = subtotal +
            double.parse(PACKINGCHARGE!) +
            double.parse(SHIPPINGCHARGE!) +
            expressDeliveryCharge -
            WALLET_AMOUNT;

        GRNDAMNT = AMOUNT.toInt();
        GRANDTOTAL = GRNDAMNT.toString() ?? "0";
      });
    } else {
      debugPrint('api failed:');
    }
    setState(() {
      isLoading = false;
    });
  }

  PlaceOrderApi() async {
    var response = await ApiHelper().post(endpoint: "cart/addCODOrder", body: {
      "id": UID,
      "address": widget.id,
      "delivery_time": isExpressDeliverySelected ? "express_delivery" : SLOTID,
      "delivery_date": SLOTDATE,
      "totalAmount": SUBTOTAL,
      "amount": GRANDTOTAL,
      "discountAmount": "0",
      "shippingCharge": SHIPPINGCHARGE,
      "paymentType": "COD",
      "contactless": CONTACTLESS.toString(),
      "delivery_note": noteController.text,
      "tip": tipController.text,
      "paid": "1",
      "subscriptionPlanAmount": subscriptionPlanAmount.toString(),
      "walletAppliedAmounts": WALLET_AMOUNT.toString()
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('place order api successful:');
        order = jsonDecode(response);
      });
      // Show the toast message
      Fluttertoast.showToast(
        msg: "Order Placed Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      debugPrint('place order api failed:');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (CartList == null || CartList![index] == null) {
      return Container(
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
            ],
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.teal[900],
          ),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            "assets/logo1.png",
            height: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        body: isLoading
            ? CircularProgressIndicator()
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
                    ],
                  ),
                ),
                child: ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Heading(text: "DELIVERY TIME SLOT"),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("Today"),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isTodaySlotsVisible =
                                                    !isTodaySlotsVisible;
                                              });
                                            },
                                            icon: Icon(isTodaySlotsVisible
                                                ? Icons.minimize
                                                : Icons.add),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: isTodaySlotsVisible,
                                        child: GridView.builder(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 3.4,
                                          ),
                                          itemCount: todaySlotList == null
                                              ? 0
                                              : todaySlotList?.length,
                                          itemBuilder: (context, index) =>
                                              getTodaySlot(index),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Tomorrow",
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isTomorrowSlotsVisible =
                                                    !isTomorrowSlotsVisible;
                                              });
                                            },
                                            icon: Icon(isTomorrowSlotsVisible
                                                ? Icons.minimize
                                                : Icons.add),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: isTomorrowSlotsVisible,
                                        child: GridView.builder(
                                          physics: ScrollPhysics(),
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 4,
                                          ),
                                          itemCount: tomorrowSlotList == null
                                              ? 0
                                              : tomorrowSlotList?.length,
                                          itemBuilder: (context, index) =>
                                              getTomorrowSlot(index),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            if (expressDeliveryStatus == "available")
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: CheckboxListTile(
                                  title: TextConst(text: "Express Delivery"),
                                  value: isExpressDeliverySelected,
                                  onChanged: (value) {
                                    setState(() {
                                      isExpressDeliverySelected = value!;
                                      generalDetailsApi();
                                    });
                                  },
                                ),
                              ),
                            if (expressDeliveryStatus == "not available")
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "Express delivery is not available.",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Heading(text: "WALLET BALANCE"),
                            Container(
                              height: 170,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    walletList == null
                                        ? Text("0")
                                        : Text(
                                            "Wallet Amount Rs.$WALLET_AMOUNT_L",
                                            textAlign: TextAlign.start,
                                          ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Applied Amount:${WALLET_AMOUNT.toInt()}",
                                      textAlign: TextAlign.start,
                                    ),
                                    Slider(
                                      mouseCursor: MouseCursor.uncontrolled,
                                      activeColor: Colors.teal[900],
                                      inactiveColor: Colors.teal[500],
                                      value: WALLET_AMOUNT,
                                      min: 0,
                                      max: WALLET_AMOUNT_L,
                                      onChanged: (double value) {
                                        setState(() {
                                          // Ensure that WALLET_AMOUNT does not exceed WALLET_AMOUNT_L
                                          WALLET_AMOUNT =
                                              value.clamp(0, WALLET_AMOUNT_L);
                                          // Calculate the new GRANDTOTAL and update other values accordingly
                                          double AMOUNT = subtotal +
                                              double.parse(PACKINGCHARGE!) +
                                              double.parse(SHIPPINGCHARGE!) -
                                              WALLET_AMOUNT;
                                          GRNDAMNT = AMOUNT.toInt();
                                          GRANDTOTAL = GRNDAMNT.toString();
                                          print(
                                              "CHECK AMOUNT = ${WALLET_AMOUNT.toInt()}");
                                          print("GRAND TOTAL = $GRANDTOTAL");
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Heading(text: "SUBSCRIPTION"),
                            MeatosPlan(),
                            Heading(text: "BILL SUMMARY"),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  AmountRow(
                                    text: "Subtotal",
                                    subtext: "Rs.${SUBTOTAL!}",
                                  ),
                                  CustomRow(
                                    text: "Delivery Charges",
                                    subtext: "Rs.0",
                                  ),
                                  CustomRow(
                                    text: "Packing Charges",
                                    subtext: "Rs.${SHIPPINGCHARGE ?? '0'}",
                                  ),
                                  CustomRow(
                                    text: "Packing Charges",
                                    subtext:
                                        "Rs.${PACKINGCHARGE ?? '0'}", // Add null check
                                  ),
                                  CustomRow(
                                    text: "First time Purchase Offer Discount",
                                    subtext: "Rs.${SUBTOTALFIRSTPURCHASE ?? '0'}",
                                  ),
                                  if (isExpressDeliverySelected &&
                                      genralList != null)
                                    CustomRow(
                                      text: "Express Delivery Charge",
                                      subtext:
                                          "Rs.${genralList![index]["express_delivery_charge"]}",
                                    ),
                                  CustomRow(
                                    text: "Grand Total",
                                    subtext:
                                        "Rs.${GRANDTOTAL ?? '0'}", // Add null check
                                  ),
                                  Divider(thickness: 2),
                                  AmountRow(
                                    text: "Net Payable",
                                    subtext: "Rs.${GRANDTOTAL ?? '0'}",
                                  ),
                                ],
                              ),
                            ),
                            Heading(text: "SAVINGS CORNER"),
                            SizedBox(
                              height: 10,
                            ),

                            // OfferCard(
                            //   title: cartDiscountList![index]["title"] ?? ""
                            //       .toString(),
                            //   description: cartDiscountList![index]
                            //   ["description"]
                            //       .toString(),
                            //   image: "assets/offer.png",
                            //   onPressed: _isApplied ? null : _onApplyButtonPressed,
                            //   isApplied: _isApplied, // Pass the isApplied value to OfferCard
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextConst(text: "Contactless Delivery"),
                                      Checkbox(
                                        activeColor: Colors.teal[900],
                                        focusColor: Colors.red,
                                        shape: CircleBorder(eccentricity: .8),
                                        value: isContactless,
                                        onChanged: (value) {
                                          setState(() {
                                            isContactless = value!;
                                            CONTACTLESS = value
                                                ? "Contactless_Delivery"
                                                : "";
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 35,
                                      right: 35,
                                    ),
                                    child: TextFormField(
                                      controller: tipController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Tip (if any)",
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
                                    padding: const EdgeInsets.only(
                                        left: 35,
                                        right: 35,
                                        top: 20,
                                        bottom: 20),
                                    child: TextFormField(
                                      controller: noteController,
                                      decoration: InputDecoration(
                                        labelText: "Enter Delivery Note",
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
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child:ElevatedButton(
                                onPressed: hidePlaceOrderButton ? null : () async {
                                  await PlaceOrderApi();
                                  // Wait for 3 seconds before navigating to MyOrders
                                  await Future.delayed(Duration(seconds: 1));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyOrders(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal[900],
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget getTodaySlot(int index) {
    final bool isSelected = selectedTodaySlotIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          SLOTID = todaySlotList![index]["id"].toString();
          SLOTDATE = todaySlotList![index]["today"].toString();
          selectedTodaySlotIndex = index;
          print("SLOTID" + todaySlotList![index]["id"].toString());
          print("SLOTDate" + todaySlotList![index]["today"].toString());
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          color: isSelected ? Colors.red.shade100 : Colors.green.shade100,
          child: Center(
            child: Text(
              todaySlotList![index]["slot"].toString(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTomorrowSlot(int index) {
    final bool isSelected = selectedTomorrowSlotIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          SLOTID = tomorrowSlotList![index]["id"].toString();
          SLOTDATE = tomorrowSlotList![index]["tomorrow"].toString();
          selectedTomorrowSlotIndex = index;
          print("SLOTID" + tomorrowSlotList![index]["id"].toString());
          print("SLOTDate" + tomorrowSlotList![index]["tomorrow"].toString());
        });
      },
      child: Card(
        color: isSelected ? Colors.red.shade100 : Colors.green.shade100,
        child: Center(
          child: Text(
            tomorrowSlotList![index]["slot"].toString(),
          ),
        ),
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
