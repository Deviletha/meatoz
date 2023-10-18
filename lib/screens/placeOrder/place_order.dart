import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meatoz/screens/placeOrder/widget/appliedoffercard.dart';
import 'package:meatoz/screens/placeOrder/widget/offer_card.dart';
import 'package:meatoz/screens/placeOrder/widget/subscription_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/amount_row.dart';
import '../../Components/custom_row.dart';
import '../../Components/title_widget.dart';
import '../../Components/text_widget.dart';
import '../../Config/api_helper.dart';
import '../../theme/colors.dart';
import '../orders/Orders_page.dart';

class PlaceOrder extends StatefulWidget {
  final String id;
  final String pinCode;

  const PlaceOrder({
    Key? key,
    required this.id,
    required this.pinCode,
  }) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  bool isContactless = false;
  String? contactLess;
  String? uID;
  int index = 0;

  final couponController = TextEditingController();

  // ///OrderList
  // Map? order;
  // Map? orderList;
  // List? FinalOrderList;

  ///Delivery slot List
  Map? slot;
  Map? slotList;
  List? todaySlotList;
  List? tomorrowSlotList;

  ///General data's list
  String? slotId;
  String? slotDate;
  String? shipCharge;
  String? totalShippingCharge;
  String? packingCharge;
  String? subTotal;
  String? subTotalForApi;
  String? grandTotal;
  String? discountId;
  String? subTotalFirstPurchase;

  int grandAmount = 0;
  double discountAmount1 = 0;
  String? discountAmountTotal;
  double netPayableAfterDiscount = 0;
  double walletAmount = 0;
  double walletAmountL = 0;

  String? expressDeliveryAvailable;
  String? expressDeliveryStatus;

  Map? list;
  List? generalList;

  ///CartList
  Map? cartList;
  List? finalCartList;
  List? cartDiscountList;
  List? cartDiscountAppliedList;

  String? cartId;

  String? discountType;
  String? discountType1;

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
  Map? pinCode;
  List? pinCodeList;

  double subtotal = 0;
  double subtotal1 = 0;

  late double subtotalFromFirstPurchase;

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


  Map? sub1;
  List? subDetailList;

  getSubscriptionPlan() async {
    var response = await ApiHelper().post(
        endpoint: "subscriptionPlan/getUserPlan",
        body: {"userid": uID}).catchError((err) {});

    setState(() {
      isLoading = false;
    });
    if (response != null) {
      setState(() {
        debugPrint('Subscription detail api successful:');
        sub1 = jsonDecode(response);
        subDetailList = sub1!["planDetails"];

      });
    } else {
      debugPrint('api failed:');
    }
  }
  checkPinCode() async {
    var response = await ApiHelper().post(
      endpoint: "postal/checkAvailabilityAtCheckout",
      body: {
        "userid": uID,
        "pincode": widget.pinCode,
      },
    ).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('check pin code api successful:');
        pinCode = json.decode(response);
        pinCodeList = pinCode!["orderData"];
        // print(pinCodeList);

        discountAmount = pinCodeList![0]["first_purchase_discount"];
        // print(discountAmount);

        int pinCodeAvailability = pinCodeList![0]["pincode_availability"];
        if (pinCodeAvailability == 0) {
          hidePlaceOrderButton = true;
          showCustomSnackBar(context);
        }

        expressDeliveryAvailable =
        pinCodeList![0]["express_delivery_available"];

        if (expressDeliveryAvailable == "available") {
          int expressDelivery = pinCodeList![0]["express_delivery"];
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
      debugPrint('pin code api failed:');
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

  @override
  void dispose() {
    couponController.dispose();
    tipController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    checkUser();
    setVisibilityFlags();
    super.initState();
  }

  bool _isApplied = false;

  void _onApplyButtonPressed() {
    // Call the apiForDiscounts() function here or perform any other actions
    apiForDiscounts();
    // Update the state to toggle the button text
    setState(() {
      _isApplied = true;
    });
  }

  void setVisibilityFlags() {
    if (todaySlotList == null || todaySlotList!.isEmpty) {
      isTodaySlotsVisible = true;
      isTomorrowSlotsVisible = true;
    }
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
    deliverySlotApi();
    setVisibilityFlags();
    generalDetailsApi();
    apiForWalletAmount();
    apiForCheckPlan();
    checkPinCode();
    getSubscriptionPlan();
    apiForCart();
  }

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
          cartDiscountList = cartList!["cartDiscountForAllProduct"];
          cartDiscountAppliedList = cartList!["cartAppliedDiscounts"];


          if (cartDiscountAppliedList != null && cartDiscountAppliedList!.isNotEmpty) {
            cartId = cartDiscountAppliedList![0]["cartID"].toString();
            discountAmount1 = cartDiscountAppliedList![0]["discountAmount"].toDouble();
            // print("discount amount: $discountAmount1");
            discountAmountTotal  = discountAmount1.toString();

          }

          if (cartDiscountList != null && cartDiscountList!.isNotEmpty) {
            String discountBy = cartDiscountList![index]["discount_by"];
            if (discountBy == "percentage") {
              discountType = "%";
            } else if (discountBy == "amount") {
              discountType = "/-";
            }
          }

          if (finalCartList != null && finalCartList!.isNotEmpty) {
            if (cartDiscountList != null && cartDiscountList!.isNotEmpty) {
              discountId = cartDiscountList![index]["id"].toString();
            } else {
              discountId = "0";
            }

          }


          if (finalCartList != null && finalCartList!.isNotEmpty) {
            for (int i = 0; i < finalCartList!.length; i++) {
              int price = finalCartList![i]["price"];
              subtotal1 = subtotal1 + price;
            }
          }

          subtotalFromFirstPurchase = discountAmount.toDouble();
          // print(subtotalFromFirstPurchase);
          subTotalFirstPurchase = subtotalFromFirstPurchase.toString();
          subtotal = subtotal1 - walletAmount - subtotalFromFirstPurchase;
          subTotal = subtotal.toString();
          subTotalForApi = subtotal1.toString();
          // print("sub total from cart: ${subTotalForApi!}");

          if (subtotalFromFirstPurchase != 0) {
            Fluttertoast.showToast(
              msg:
                  "First Purchase Offer Discount Applied Rs. $subtotalFromFirstPurchase",
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
        endpoint: "discount/applyDiscountAtCheckout",
        body: {
          "user_id": uID,
          "discount_id": discountId,
          "total_amount": subTotalForApi
        }).catchError((err) {});

    setState(() {
      isLoading = false;
    });
    if (responseDiscount != null) {
      setState(() {
        debugPrint('Apply discount api successful:');
        discount = jsonDecode(responseDiscount);
        discountList = discount!["discountAmount"];

        discountAmount1 = discountList!["discountAmount"].toDouble();
        // print("discount amount: $discountAmount1");
        discountAmountTotal  = discountAmount1.toString();


        netPayableAfterDiscount = (grandAmount - discountAmount1);
        // print("net payable after discount$netPayableAfterDiscount");
        grandTotal = netPayableAfterDiscount.toString();
        // print("discount response: "+responseDiscount);

        Fluttertoast.showToast(
          msg: "Discount Applied Amount Rs.$discountAmountTotal",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
        );

        Map<String, dynamic> responseData = json.decode(responseDiscount);

        if (responseData.containsKey('discountAmount')) {
          Map<String, dynamic> discountAmount = responseData['discountAmount'];

          if (discountAmount['status'] != null && discountAmount['status'] == false) {
            Fluttertoast.showToast(
              msg: "Offer is not available for you",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        }

      });
    } else {
      debugPrint('discount api failed:');
    }
  }

  apiForRemoveDiscount() async {
    var responseDiscount = await ApiHelper().post(
      endpoint: "cart/removeDiscountId",
      body: {
        "cart_id": cartId,
      },
    ).catchError((err) {});

    if (responseDiscount != null) {
      setState(() {
        debugPrint('remove discount api successful:');
        // print("remove discount response: " + responseDiscount);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceOrder(id: widget.id, pinCode: widget.pinCode,),
          ),
        );
        // Trigger a rebuild of the widget tree
        setState(() {});
      });
    } else {
      debugPrint('discount api failed:');
    }
  }


  apiForWalletAmount() async {
    var responseWallet = await ApiHelper().post(endpoint: "wallet", body: {
      "userid": uID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });
    if (responseWallet != null) {
      setState(() {
        debugPrint('Wallet api successful:');
        wallet = jsonDecode(responseWallet);
        walletList = wallet!["walletAmount"];

        if (walletList != null && walletList!.isNotEmpty) {
          walletAmountL = walletList![index]["wallet_amount"].toDouble();
          walletAmount = walletAmountL;
        }
        // print("API Response: $responseWallet");
      });
    } else {
      debugPrint('wallet api failed:');
    }
  }

  apiForCheckPlan() async {
    var response =
        await ApiHelper().post(endpoint: "subscriptionPlan/PaidOrNot", body: {
      "userid": uID,
    }).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('Plan check api successful:');
        plan = jsonDecode(response);
        planList = plan!["planDetails"];
        // print("plan amount " + response);

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
        slotList = slot!["slots"];
        todaySlotList = slotList?["today"]; // Add null check
        tomorrowSlotList = slotList?["tomorrow"];

        todaySlotList = slotList?["today"] ?? [];
        tomorrowSlotList = slotList?["tomorrow"] ?? [];

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
    var response = await ApiHelper().post(endpoint: "generalInfo/get", body: {}).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('general details api successful:');
        list = jsonDecode(response);
        generalList = list!["general_info"];

        // Check if subDetailList is not empty and set packingCharge and shipCharge to "0"
        if (subDetailList != null && subDetailList!.isNotEmpty) {
          shipCharge = "0";
          packingCharge = "0";
        }

        shipCharge ??= generalList![index]["delivery_charge"]?.toString() ?? "0";
        packingCharge ??= generalList![index]["packing_charge"]?.toString() ?? "0";

        int shippingCharge = 0;

        shippingCharge = int.parse(shipCharge!);

        double expressDeliveryCharge = 0.0;

        if (isExpressDeliverySelected && generalList != null) {
          expressDeliveryCharge = double.parse(
              generalList![index]["express_delivery_charge"].toString());
        }

        double finalShippingCharge = shippingCharge + expressDeliveryCharge;

        totalShippingCharge = finalShippingCharge.toString();
        // print("total shipping charge : ${totalShippingCharge!}");

        double amount = subtotal +
            double.parse(packingCharge!) +
            double.parse(shipCharge!) +
            subscriptionPlanAmount +
            expressDeliveryCharge -
            discountAmount1 -
            walletAmount;

        grandAmount = amount.toInt();
        grandTotal = grandAmount.toString() ;
      });
    } else {
      debugPrint('api failed:');
    }
    setState(() {
      isLoading = false;
    });
  }

  placeOrderApi() async {
    var response = await ApiHelper().post(endpoint: "cart/addCODOrder", body: {
      "id": uID.toString(),
      "address": widget.id.toString(),
      "delivery_time": isExpressDeliverySelected ? "express_delivery" : slotId.toString(),
      "delivery_date": isExpressDeliverySelected ? DateTime.now().toString() : slotDate.toString(),
      "totalAmount": subTotalForApi.toString(),
      "amount": grandTotal.toString(),
      "discountAmount": discountAmount1.toString(),
      "shippingCharge": totalShippingCharge.toString(),
      "paymentType": "COD",
      "contactless": contactLess.toString(),
      "delivery_note": noteController.text.toString(),
      "tip": tipController.text.toString(),
      "paid": "1",
      "subscriptionPlanAmount": subscriptionPlanAmount.toString(),
      "walletAppliedAmounts": walletAmount.toString()
    }).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('place order api successful:');
        // print( "place order api response: " + response);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyOrders(),
          ),
        );
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
      // print(response);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (finalCartList == null || finalCartList![index] == null) {
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
            color: Color(ColorT.themeColor)
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
            ? CircularProgressIndicator(
          color: Color(ColorT.themeColor),
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
                                            crossAxisCount: 3,
                                            childAspectRatio: 4,
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
                                  activeColor: Color(ColorT.themeColor),
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
                                            "Wallet Amount Rs.$walletAmountL",
                                            textAlign: TextAlign.start,
                                          ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Applied Amount:${walletAmount.toInt()}",
                                      textAlign: TextAlign.start,
                                    ),
                                    Slider(
                                      mouseCursor: MouseCursor.uncontrolled,
                                      activeColor: Color(ColorT.themeColor),
                                      inactiveColor: Colors.teal[500],
                                      value: walletAmount,
                                      min: 0,
                                      max: walletAmountL,
                                      onChanged: (double value) {
                                        setState(() {
                                          // Ensure that WALLET_AMOUNT does not exceed WALLET_AMOUNT_L
                                          walletAmount =
                                              value.clamp(0, walletAmountL);
                                          // Calculate the new GrandTotal and update other values accordingly
                                          double amount = subtotal +
                                              double.parse(packingCharge!) +
                                              double.parse(shipCharge!) -
                                              walletAmount;
                                          grandAmount = amount.toInt();
                                          grandTotal = grandAmount.toString();
                                          // print("CHECK AMOUNT = ${walletAmount.toInt()}");
                                          // print("GRAND TOTAL = $grandTotal");
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Heading(text: "SUBSCRIPTION"),
                            MeatozPlan(),
                            Heading(text: "BILL SUMMARY"),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  AmountRow(
                                    text: "Subtotal",
                                    subtext: "Rs.${subTotalForApi ?? "0"}" ,
                                  ),
                                  CustomRow(
                                    text: "Delivery Charges",
                                    subtext: "Rs.${shipCharge ?? '0'}",
                                  ),
                                  // CustomRow(
                                  //   text: "Packing Charges",
                                  //   subtext:
                                  //       "Rs.${packingCharge ?? '0'}", // Add null check
                                  // ),

                                  if (isExpressDeliverySelected &&
                                      generalList != null)
                                    CustomRow(
                                      text: "Express Delivery Charge",
                                      subtext:
                                          "Rs.${generalList![index]["express_delivery_charge"]}",
                                    ),
                                  if (planList != null &&
                                      planList!.isNotEmpty &&
                                      planList![0]["paid_status"] == "Unpaid")
                                    CustomRow(
                                      text: "Subscription Plan Amount",
                                      subtext:
                                      "Rs.$subscriptionPlanAmount",
                                    ),
                                  if (cartDiscountAppliedList != null &&
                                      cartDiscountAppliedList!.isNotEmpty)
                                    CustomRow(
                                      text: "Discount Applied Amount",
                                      subtext:
                                      "Rs.${discountAmountTotal ?? '0'}",
                                    ),
                                  CustomRow(
                                    text: "First time Purchase Discount",
                                    subtext: "Rs.${subTotalFirstPurchase ?? '0'}",
                                  ),
                                  CustomRow(
                                    text: "Grand Total",
                                    subtext:
                                        "Rs.${grandTotal ?? '0'}", // Add null check
                                  ),
                                  Divider(thickness: 2),
                                  AmountRow(
                                    text: "Net Payable",
                                    subtext: "Rs.${grandTotal ?? '0'}",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (cartDiscountAppliedList != null &&
                                cartDiscountAppliedList!.isNotEmpty)
                              Column(
                                children: [
                                  Heading(text: "APPLIED DISCOUNTS"),
                                  AppliedOfferCard(
                                    title: cartDiscountAppliedList![index]["cartProductName"] ?? ""
                                        .toString(),
                                    description: "Rs. ${cartDiscountAppliedList![index]
                                    ["discountAmount"]}",
                                    image: "assets/offeratcart.png",
                                    onPressed: (){
                                      apiForRemoveDiscount();
                                    }
                                  ),
                                ],
                              ),
                            SizedBox(
                              height: 15,
                            ),
                            if (cartDiscountList != null &&
                                cartDiscountList!.isNotEmpty &&
                                // cartDiscountAppliedList == null &&
                                cartDiscountAppliedList!.isEmpty &&
                                cartDiscountList![0]["discountAvailable"] == 1)
                            Column(
                              children: [
                                Heading(text: "AVAILABLE DISCOUNTS"),
                                OfferCard(
                                  title: cartDiscountList![index]["title"] ?? ""
                                      .toString(),
                                  description: "${cartDiscountList![index]
                                  ["discount_value"]}${discountType!} Discount",
                                  image: "assets/offer1.png",
                                  onPressed: _isApplied ? null : _onApplyButtonPressed,
                                  isApplied: _isApplied, // Pass the isApplied value to OfferCard
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                children: [
                                  CheckboxListTile(
                                    activeColor: Color(ColorT.themeColor),
                                    title: TextConst(text: "Contactless Delivery"),
                                    value: isContactless,
                                    onChanged: (value) {
                                      setState(() {
                                        isContactless = value!;
                                        contactLess = value
                                            ? "Contactless_Delivery"
                                            : "";
                                      });
                                    },
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
                                      textInputAction: TextInputAction.next,
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
                                  await placeOrderApi();
                                  // Wait for 3 seconds before navigating to MyOrders
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(ColorT.themeColor),
                                  shadowColor: Colors.teal[300],
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
          slotId = todaySlotList![index]["id"].toString();
          slotDate = todaySlotList![index]["today"].toString();
          selectedTodaySlotIndex = index;
          // print("slotId${todaySlotList![index]["id"]}");
          // print("slotDate${todaySlotList![index]["today"]}");
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(15)),
    color: isSelected ? Colors.red.shade300 : Colors.grey.shade800,),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Center(
              child: Text(
                todaySlotList![index]["slot"].toString(),
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
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
          slotId = tomorrowSlotList![index]["id"].toString();
          slotDate = tomorrowSlotList![index]["tomorrow"].toString();
          selectedTomorrowSlotIndex = index;
          // print("slotId: {tomorrowSlotList![index]["id"]}");
          // print("slotDate: {tomorrowSlotList![index]["tomorrow"]}");
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: isSelected ? Colors.red.shade300 : Colors.grey.shade800,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Text(
                tomorrowSlotList![index]["slot"].toString(),
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

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
