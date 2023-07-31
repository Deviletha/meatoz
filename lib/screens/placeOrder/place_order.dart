import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meatoz/screens/placeOrder/subscription_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/Amount_Row.dart';
import '../../Components/CustomRow.dart';
import '../../Components/Title_widget.dart';
import '../../Components/text_widget.dart';
import '../../Config/ApiHelper.dart';
import '../orders/Orders_page.dart';
import '../accounts/Subscription_plans.dart';

class PlaceOrder extends StatefulWidget {
  final String id;

  const PlaceOrder({Key? key, required this.id}) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  bool isContactless = false;
  String? UID;
  int index = 0;

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
  String? SHIPPINGCHARGE;
  String? PACKINGCHARGE;
  String? SUBTOTAL;
  String? GRANDTOTAL;
   int GRNDAMNT = 0;
  String? WALLET_AMOUNT_VALUE;

  double WALLET_AMOUNT = 0;
  double WALLET_AMOUNT_L = 0;

  Map? list;
  List? genralList;

  ///CartList
  Map? clist;
  List? CartList;

  ///WalletAmountList
  Map? wallet;
  List? walletList;

  double subtotal = 0;
  double subtotal1 = 0;

  Map? plan;
  List? planList;
  double subscriptionPlanAmount = 0;

  final tipController = TextEditingController();
  final noteController = TextEditingController();

  int? selectedTodaySlotIndex;
  int? selectedTomorrowSlotIndex;

  bool isTodaySlotsVisible = true;
  bool isTomorrowSlotsVisible = true;
  bool isLoading = false;
  bool isLoadOrder = false;

  @override
  void initState() {
    checkUser();
    deliverySlotApi();
    setVisibilityFlags();
    apiForCart();
    generalDetailsApi();
    apiForWalletAmount();
    apiForCheckplan();
    super.initState();
  }

  void setVisibilityFlags() {
    if (todaySlotList == null || todaySlotList!.isEmpty) {
      isTodaySlotsVisible = false;
      isTomorrowSlotsVisible = true;
    }
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
      print(UID);
    });
    apiForCart();
  }

  apiForCart() async {
    setState(() {
      isLoading = true;
    });

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

        if (CartList != null && CartList!.isNotEmpty) {
          for (int i = 0; i < CartList!.length; i++) {
            int price = CartList![i]["price"];
            subtotal1 = subtotal1 + price;
          }
        }

        subtotal = subtotal1 - WALLET_AMOUNT;
        SUBTOTAL = subtotal.toString();
      });
    } else {
      debugPrint('api failed:');
    }
  }

  apiForWalletAmount() async {
    setState(() {
      isLoading = true;
    });
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
        WALLET_AMOUNT_L = walletList![index]["wallet_amount"].toDouble();
        // Initialize the WALLET_AMOUNT to the maximum available value initially
        WALLET_AMOUNT = WALLET_AMOUNT_L;
      });
    } else {
      debugPrint('wallet api failed:');
    }
  }

  apiForCheckplan() async {
    setState(() {
      isLoading = true;
    });

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
    setState(() {
      isLoading = true;
    });

    var response = await ApiHelper()
        .post(endpoint: "deliverySlot/get", body: {}).catchError((err) {});
    if (response != null) {
      apiForWalletAmount();
      setState(() {
        debugPrint('slot api successful:');
        slot = jsonDecode(response);
        slotlist = slot!["slots"];
        todaySlotList = slotlist!["today"];
        tomorrowSlotList = slotlist!["tomorrow"];
        print("slotid" + SLOTID!);
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
    setState(() {
      isLoading = true;
    });

    var response = await ApiHelper().post(endpoint: "generalInfo/get", body: {}).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('general detailsapi successful:');
        list = jsonDecode(response);
        genralList = list!["general_info"];
        SHIPPINGCHARGE = genralList![index]["delivery_charge"].toString();
        PACKINGCHARGE = genralList![index]["packing_charge"].toString();
        double AMOUNT = int.parse(PACKINGCHARGE!) +int.parse(SHIPPINGCHARGE!)+ subtotal;
        GRANDTOTAL = AMOUNT.toString();
        print("AMOUNT = "+AMOUNT.toString());
        // generalDetailsApi();
      });
    } else {
      debugPrint('api failed:');
    }
    setState(() {
      isLoading = false;
    });
  }


  PlaceOrderApi() async {
    setState(() {
      isLoadOrder = true;
    });

    var response = await ApiHelper().post(endpoint: "cart/addCODOrder", body: {
      "id": UID,
      "address": widget.id,
      "delivery_time": SLOTID,
      "totalAmount": SUBTOTAL,
      "amount": GRANDTOTAL,
      "discountAmount": "0",
      "shippingCharge": SHIPPINGCHARGE,
      "paymentType": "COD",
      "contactless": isContactless.toString(),
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
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyOrders(),
        ),
      );
    } else {
      debugPrint('place order api failed:');
    }

    setState(() {
      isLoadOrder = false;
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
        backgroundColor: Colors.grey.shade200,
        body: isLoading
            ? ShimmerLoading() // Replace CircularProgressIndicator with ShimmerLoading
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
                child: isLoading
                    ? ShimmerLoading()
                    : ListView(
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
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
                                                  icon: Icon(
                                                      isTomorrowSlotsVisible
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
                                                itemCount: tomorrowSlotList ==
                                                        null
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
                                  Heading(text: "WALLET BALANCE"),
                                  Container(
                                    height: 170,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding:  EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          walletList == null
                                              ? Text("0")
                                              : Text(
                                                  "Wallet Amount Rs."+WALLET_AMOUNT_L.toString(),
                                                  textAlign: TextAlign.start,
                                                ),
                                          SizedBox(height: 20),
                                          Text(
                                            "Adjust Wallet Amount:"+WALLET_AMOUNT.toInt().toString(),
                                            textAlign: TextAlign.start,
                                          ),
                                          Slider(
                                            value: WALLET_AMOUNT,
                                            min: 0,
                                            max: WALLET_AMOUNT_L,
                                            onChanged: (double value) {
                                              setState(() {
                                                WALLET_AMOUNT = WALLET_AMOUNT_L - value;
                                                double AMOUNT = subtotal + double.parse(PACKINGCHARGE!) + double.parse(SHIPPINGCHARGE!) - WALLET_AMOUNT;
                                                GRNDAMNT = AMOUNT.toInt();
                                                GRANDTOTAL = GRNDAMNT.toString();
                                                print(WALLET_AMOUNT_L);
                                                print("CHECK AMOUNT = " + WALLET_AMOUNT.toInt().toString());
                                                print("GRAND TOTAL = " + GRANDTOTAL.toString());
                                              });
                                            },
                                          ),
                                          // ElevatedButton(
                                          //   onPressed: () {
                                          //     CartList?.clear();
                                          //     apiForCart();
                                          //     generalDetailsApi();
                                          //     Fluttertoast.showToast(
                                          //       msg: "Selected Wallet Amount:",
                                          //       toastLength: Toast.LENGTH_SHORT,
                                          //       gravity: ToastGravity.SNACKBAR,
                                          //       timeInSecForIosWeb: 1,
                                          //       textColor: Colors.white,
                                          //       fontSize: 16.0,
                                          //     );
                                          //   },
                                          //   style: ElevatedButton.styleFrom(
                                          //     backgroundColor: Colors.teal[900],
                                          //     shadowColor: Colors.teal[300],
                                          //     shape: RoundedRectangleBorder(
                                          //       borderRadius: BorderRadius.only(
                                          //         bottomRight:
                                          //             Radius.circular(10),
                                          //         topLeft: Radius.circular(10),
                                          //       ),
                                          //     ),
                                          //   ),
                                          //   child: Text("Apply"),
                                          // ),
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
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      children: [
                                         AmountRow(text: "Subtotal", subtext: "Rs.${SUBTOTAL!}",),
                                        CustomRow(
                                            text: "Delivery Charges",
                                            subtext: "Rs.0"),
                                        CustomRow(
                                            text: "Packing Charges",
                                            subtext: "Rs.${PACKINGCHARGE!}"),
                                        CustomRow(
                                            text: "Shipping Charges",
                                            subtext: "Rs.${SHIPPINGCHARGE!}"),
                                        CustomRow(text: "Grand Total", subtext: "Rs.${GRANDTOTAL!}"),
                                        Divider(thickness: 2),
                                        AmountRow(text: "Net Payable", subtext: "Rs.${GRANDTOTAL!}")

                                      ],
                                    ),
                                  ),
                                  Heading(text: "SAVINGS CORNER"),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextConst(
                                                text: "Contactless Delivery"),
                                            Checkbox(
                                              value: isContactless,
                                              onChanged: (value) {
                                                setState(() {
                                                  isContactless = value!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 35, right: 35, top: 20),
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
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 35, right: 35, top: 20),
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
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            PlaceOrderApi();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal[900],
                                            shadowColor: Colors.teal[300],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                          child: Text("Place Order"),
                                        ),
                                      ],
                                    ),
                                  )
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
        SLOTID = todaySlotList![index]["id"].toString();
        selectedTodaySlotIndex = index;
        print("SLOTID" + todaySlotList![index]["id"].toString());
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
      child: Card(
        color: isSelected ? Colors.red.shade100 : Colors.green.shade100,
        child: Center(
          child: InkWell(
            onTap: () {
              SLOTID = tomorrowSlotList![index]["id"].toString();
              print("SLOTID" + tomorrowSlotList![index]["id"].toString());
            },
            child: Text(
              tomorrowSlotList![index]["slot"].toString(),
            ),
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
