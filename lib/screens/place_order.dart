import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../Components/Amount_Row.dart';
import '../Components/CustomRow.dart';
import '../Components/Title_widget.dart';
import '../Components/text_widget.dart';
import '../Config/ApiHelper.dart';
import 'Orders_page.dart';
import 'Subscription_plans.dart';

class PlaceOrder extends StatefulWidget {
  final String id;

  const PlaceOrder({Key? key, required this.id}) : super(key: key);

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  String? SLOTID;
  String? UID;
  String? SHIPPINGCHARGE;
  String? PACKINGCHARGE;
  String? SUBTOTAL;
  String? GRANDTOTAL;
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
  Map? list;
  List? genralList;
  ///CartList
  Map? clist;
  List? CartList;

  final tipController = TextEditingController();
  final noteController = TextEditingController();

  bool isTodaySlotsVisible = true;
  bool isTomorrowSlotsVisible = true;
  bool isLoading = false;

  @override
  void initState() {
    checkUser();
    deliverySlotApi();
    setVisibilityFlags();
    generalDetailsApi();
    apiForCart();
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
        print("cart items"+ response);

        int subtotal = 0;
        if (CartList != null && CartList!.isNotEmpty) {
          for (int i = 0; i < CartList!.length; i++) {
            int price = CartList![i]["price"];
            subtotal = subtotal+price;
          }
        }
        SUBTOTAL = subtotal.toString();
        // print("Total${SUBTOTAL!}");
      });
    } else {
      debugPrint('api failed:');
    }
  }



  deliverySlotApi() async {
    setState(() {
      isLoading = true;
    });

    var response =
    await ApiHelper().post(endpoint: "deliverySlot/get", body: {}).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('slot api successful:');
        slot = jsonDecode(response);
        slotlist = slot!["slots"];
        todaySlotList = slotlist!["today"];
        tomorrowSlotList = slotlist!["tomorrow"];

        Fluttertoast.showToast(
          msg: "slot selected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
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
    var response =
    await ApiHelper().post(endpoint: "generalInfo/get", body: {}).catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('general detailsapi successful:');
        list = jsonDecode(response);
        genralList = list!["general_info"];
        SHIPPINGCHARGE = genralList![index]["delivery_charge"].toString();
        PACKINGCHARGE = genralList![index]["packing_charge"].toString();

        Fluttertoast.showToast(
          msg: "shipping charge",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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
      isLoading = true;
    });

    var response = await ApiHelper().post(endpoint: "cart/placeOrder", body: {
      "id": UID,
      "address": widget.id,
      "delivery_time": SLOTID,
      "totalAmount": "",
      "amount": "",
      "discountAmount": "0",
      "shippingCharge": SHIPPINGCHARGE,
      "walletAppliedAmounts": "",
      "paymentType": "",
      "contactless": "",
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
          child: CircularProgressIndicator(color: Colors.teal[900],),
        ),
      );
    }
    GRANDTOTAL = (int.parse(SUBTOTAL!) + int.parse(PACKINGCHARGE!) + int.parse(SHIPPINGCHARGE!)).toString();
    print("granttotl"+GRANDTOTAL!);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body:  isLoading
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      Heading(text: "SUBSCRIPTION"),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Subscription();
                          }),
                        ),
                        child: Container(
                          height: 85,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Colors.blue.shade200,
                                    Colors.blue.shade100,
                                    Colors.green.shade50,
                                  ])),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  [
                                Image.asset("assets/logo_short.png", height: 50,alignment: Alignment.centerLeft,
                                  color: Colors.white,),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                       Text(
                                        "Meatoz Subscription Plan",
                                        style: TextStyle(
                                            fontSize: 18,fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        "Subscription plan details",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextConst(
                                  text: "Know More",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Heading(text: "BILL SUMMARY"),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children:  [
                            AmountRow(text: "Subtotal", subtext: "Rs.${SUBTOTAL!}",),
                            CustomRow(text: "Delivery Charges", subtext: "Rs.0"),
                            CustomRow(text: "Packing Charges", subtext: "Rs.${PACKINGCHARGE!}"),
                            CustomRow(text: "Shipping Charges", subtext: "Rs.${SHIPPINGCHARGE!}"),
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
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextConst(text: "Contactless Delivery "),
                                IconButton(onPressed: (){}, icon: Icon(Icons.check_box_outline_blank_outlined))
                              ],
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 35, right: 35, top: 20),
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
                              padding:
                              const EdgeInsets.only(left: 35, right: 35, top: 20),
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
                            ElevatedButton(
                              onPressed: () {
                                PlaceOrderApi();
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
    return InkWell(
      onTap: () {
        SLOTID = todaySlotList![index]["id"].toString();
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          color: Colors.green.shade100,
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
    return InkWell(
      onTap: () {
        SLOTID = tomorrowSlotList![index]["id"].toString();
      },
      child: Card(
        color: Colors.green.shade100,
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
