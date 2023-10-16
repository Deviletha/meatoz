import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/alertbox_text.dart';
import '../../Components/text_widget.dart';
import '../../Config/api_helper.dart';
import '../../theme/colors.dart';
import 'faq_page.dart';


class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  List images = [
    "assets/basiclogo.png",
    "assets/standardlogo.png",
    "assets/premiumlogo.png"
  ];

  List planColors = [
    Colors.green.shade50,
    Colors.indigo.shade50,
    Colors.pink.shade50,
  ];

  String? uID;
  Map? sub;
  List? subscriptionList;

  Map? subscription;

  Map? sub1;
  List? subDetailList;

  bool isLoading = true;

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
    getSubscriptionPlan();
  }

  apiForSubscription() async {

    var response = await ApiHelper()
        .post(endpoint: "subscriptionPlan/get", body: {}).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('Subscription plan api successful:');
        sub = jsonDecode(response);
        subscriptionList = sub!["plans"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

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

  chooseSubscriptionPlan(String planId, String paymentType) async {

    if (subscriptionList != null ) {
      var response = await ApiHelper().post(
          endpoint: "subscriptionPlan/subcription",
          body: {
            "userid": uID,
            "plan_id": planId,
            "type": paymentType,
          }
      ).catchError((err) {});

      setState(() {
        isLoading = false;
      });

      if (response != null) {
        setState(() {
          debugPrint('Subscription plan api successful:');
          subscription = jsonDecode(response);

        });

        // Refresh the subscription details
        getSubscriptionPlan();
      } else {
        debugPrint('api failed:');
      }
    } else {
      if (kDebugMode) {
        print("Invalid index or SubscriptionList is null.");
      }
    }
  }
  void _showPlanConfirmationDialog(BuildContext context, String planId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Plan"),
          content: Text(
            "If you choose unpaid, the amount will add to your next order's bill.",
          ),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     // Perform the action for Paid option
            //     chooseSubscriptionPlan(planId, "Paid");
            //     Navigator.pop(context); // Close the dialog
            //   },
            //   child:  AlertText(text: 'Paid')
            // ),
            TextButton(
              onPressed: () {
                // Perform the action for Unpaid option
                chooseSubscriptionPlan(planId, "Unpaid");
                Navigator.pop(context); // Close the dialog
              },
              child:  AlertText(text: 'Unpaid')
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    checkUser();
    apiForSubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: AppText(
      //     text: "Subscription",
      //   ),
      //   actions: [
      //     IconButton(onPressed: () => Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) {
      //                 return FAQ(
      //                   section: "subcription_plans",
      //                 );
      //               }),
      //             ), icon: Icon(Icons.help_outline_rounded))
      //   ],
      // ),
      bottomNavigationBar: Container(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/logo1.png", height: 30,alignment: Alignment.centerLeft,
            color: Colors.grey.shade700,),
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
              height: 15,
            ),
            Text(
              '''
  Unlock all
  premium features''',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            IconButton(
              alignment: Alignment.centerRight,
                onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return FAQ(
                  section: "subcription_plans",
                );
              }),
            ), icon: Icon(Icons.help_outline_rounded, size: 30,)),
            Text(
              '''
   Choose the subscription among the top one and enjoy 
   all the premium features
             ''',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
            Visibility(
              visible: subDetailList != null && subDetailList!.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: const [
                        Color(ColorT.subscriptionCard1),
                        Color(ColorT.subscriptionCard),
                        Color(ColorT.subscriptionCard),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isLoading
                                ? CircularProgressIndicator()
                                : Text(
                              subDetailList == null || subDetailList!.isEmpty
                                  ? 'Loading...'
                                  : "${subDetailList![0]["head"]} Plan",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              subDetailList == null || subDetailList!.isEmpty
                                  ? 'Loading...'
                                  : "Expires on ${subDetailList![0]["to_date"]}".toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextConst(
                              text: "Activated",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CarouselSlider.builder(
                        itemCount: 5, // Set a fixed count for shimmer effect
                        itemBuilder: (context, index, realIndex) {
                          return getSubscription(index);
                        },
                        options: CarouselOptions(
                          height: 420,
                          aspectRatio: 15 / 6,
                          viewportFraction: .75,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: false,
                          enlargeCenterPage: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, reason) {},
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    )
                  : CarouselSlider.builder(
                      itemCount: subscriptionList == null
                          ? 0
                          : subscriptionList?.length,
                      itemBuilder: (context, index, realIndex) {
                        return getSubscription(index);
                      },
                      options: CarouselOptions(
                        height: 420,
                        aspectRatio: 15 / 6,
                        viewportFraction: .75,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSubscription(int index1) {


    if (subscriptionList == null) {
      return Container();
    }
    final bool isPlanActivated =
        subDetailList != null &&
            subDetailList!.isNotEmpty &&
            subDetailList![0]["planID"].toString() == subscriptionList![index1]["id"].toString();


    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.shade500,blurRadius: 3,),],
          // border: Border.all(color: Colors.grey.shade800, width: 1),
        ),
        height: 400,
        width: 330,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 360,
              height: 150,
              decoration: BoxDecoration(
                  color: planColors[index1],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Image.asset(images[index1]),
            ),
            Container(
              height: 208,
              width: 360,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        subscriptionList![index1]["head"].toString(),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      subscriptionList![index1]["description"].toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "Features",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      "✔️ No of Orders - ${subscriptionList![index1]["no_of_orders"] ??" "}",
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "✔️ Duration - ${subscriptionList![index1]["plan_duration"] ?? " "}Month",
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "✔️ CashBack - ${subscriptionList![index1]["cashback_percentage"] ??" "}%",
                      style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Rs.${subscriptionList![index1]["amount"] ?? ""}",
                      style: TextStyle(fontSize: 18,),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 40,
              width: 360,
              decoration: BoxDecoration(
                color: isPlanActivated &&
                    subDetailList![0]["planID"].toString() == subscriptionList![index1]["id"].toString()
                    ? Colors.grey.shade900 // Disabled color
                    : Colors.grey.shade700,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: TextButton(
                onPressed: isPlanActivated &&
                    subDetailList![0]["planID"].toString() == subscriptionList![index1]["id"].toString()
                    ? null // Disable the button if plan is activated
                    : () {
                  _showPlanConfirmationDialog(
                    context,
                    subscriptionList![index1]["id"].toString(),
                  );
                },
                child: Text(
                  isPlanActivated &&
                      subDetailList![0]["planID"].toString() == subscriptionList![index1]["id"].toString()
                      ? "Plan Activated"
                      : "Choose Plan",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
