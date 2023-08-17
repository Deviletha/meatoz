import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/Alertbox_text.dart';
import '../../Components/appbar_text.dart';
import '../../Components/text_widget.dart';
import '../../Config/ApiHelper.dart';
import 'FAQ_page.dart';


class Subscription extends StatefulWidget {
  Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  List images = [
    "assets/basiclogo.png",
    "assets/standardlogo.png",
    "assets/premiumlogo.png"
  ];

  List plancolors = [
    Colors.purple.shade50,
    Colors.blue.shade50,
    Colors.green.shade100
  ];

  String? PLANID;
  String? UID;
  Map? sub;
  List? SubscriptionList;
  Map? Subscription;

  Map? sub1;
  List? SubdetailList;
  String? base = "https://meatoz.in/basicapi/public/";

  bool isLoading = true;

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
      print(UID);
    });
    getSubscriptionplan();
  }

  apiforSubscription() async {

    var response = await ApiHelper()
        .post(endpoint: "subscriptionPlan/get", body: {}).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('Subscription plan api successful:');
        sub = jsonDecode(response);
        SubscriptionList = sub!["plans"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  getSubscriptionplan() async {

    var response = await ApiHelper().post(
        endpoint: "subscriptionPlan/getUserPlan",
        body: {"userid": UID}).catchError((err) {});

    setState(() {
      isLoading = false;
    });
    if (response != null) {
      setState(() {
        debugPrint('Subscription detail api successful:');
        sub1 = jsonDecode(response);
        SubdetailList = sub1!["planDetails"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  chooseSubscriptionPlan(String planId, String paymentType) async {

    if (SubscriptionList != null ) {
      var response = await ApiHelper().post(
          endpoint: "subscriptionPlan/subcription",
          body: {
            "userid": UID,
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
          Subscription = jsonDecode(response);
          print("plan id" + response);
        });

        // Refresh the subscription details
        getSubscriptionplan();
      } else {
        debugPrint('api failed:');
      }
    } else {
      print("Invalid index or SubscriptionList is null.");
    }
  }
  void _showPlanConfirmationDialog(BuildContext context, String planId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),gapPadding: 20
          ),
          title: Text("Choose Plan"),
          content: Text(
            "If you choose unpaid, the amount will add to your next order's bill.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Perform the action for Paid option
                chooseSubscriptionPlan(planId, "Paid");
                Navigator.pop(context); // Close the dialog
              },
              child:  AlertText(text: 'Paid')
            ),
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
    apiforSubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "SUBCRIPTION",
        ),
        actions: [
          IconButton(onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return FAQ(
                        section: "subcription_plans",
                      );
                    }),
                  ), icon: Icon(Icons.help_outline_rounded))
        ],
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
              height: 8,
            ),
            Text(
              '''
  Unlock all
  premium features''',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text(
              '''
              
   Choose the subscription among the top one 
   and enjoy all the premium features
             ''',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Container(
                height: 80,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isLoading
                              ? CircularProgressIndicator()
                              : Text(
                                  SubdetailList == null
                                      ? 'Loading...'
                                      : "${SubdetailList![0]["head"]} Plan",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold
                                  ),
                                ),
                          Text(
                            SubdetailList == null
                                ? 'Loading...'
                                : SubdetailList![0]["to_date"].toString(),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      TextConst(
                        text: "Activated",
                      ),
                    ],
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
                          viewportFraction: .65,
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
                      itemCount: SubscriptionList == null
                          ? 0
                          : SubscriptionList?.length,
                      itemBuilder: (context, index, realIndex) {
                        return getSubscription(index);
                      },
                      options: CarouselOptions(
                        height: 420,
                        aspectRatio: 15 / 6,
                        viewportFraction: .65,
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
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 10),
              child: Image.asset("assets/logo1.png", height: 30,alignment: Alignment.centerLeft,
              color: Colors.grey.shade700,),
            )
          ],
        ),
      ),
    );
  }

  Widget getSubscription(int index1) {
    if (SubscriptionList == null) {
      return Container();
    }
    final bool isPlanActivated =
        SubdetailList != null &&
            SubdetailList!.isNotEmpty &&
            SubdetailList![0]["plan_id"].toString() == SubscriptionList![index1]["id"].toString();

    print("Plan ID: ${SubscriptionList![index1]["id"]}");
    print("Activated Plan ID: ${SubdetailList![0]["plan_id"]}");
    print("isPlanActivated: $isPlanActivated");

    // PLANID = SubscriptionList![index1]["id"].toString();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade800, width: 1),
        ),
        height: 400,
        width: 330,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 330,
              height: 120,
              decoration: BoxDecoration(
                  color: plancolors[index1],
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Image.asset(images[index1]),
            ),
            Container(
              height: 238,
              width: 330,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        SubscriptionList![index1]["head"].toString(),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      SubscriptionList![index1]["description"].toString(),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(
                        "Features",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      "No of Orders - ${SubscriptionList![index1]["no_of_orders"]}",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Duration - ${SubscriptionList![index1]["plan_duration"]}Month",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "CashBack - ${SubscriptionList![index1]["cashback_percentage"]}%",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Rs.${SubscriptionList![index1]["amount"]}",
                      style: TextStyle(fontSize: 20, color: Colors.teal[900]),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 40,
              width: 330,
              decoration: BoxDecoration(
                color: isPlanActivated &&
                    SubdetailList![0]["plan_id"] == SubscriptionList![index1]["id"].toString()
                    ? Colors.grey[400] // Disabled color
                    : Colors.grey[800],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: TextButton(
                onPressed: isPlanActivated &&
                    SubdetailList![0]["plan_id"] == SubscriptionList![index1]["id"].toString()
                    ? null // Disable the button if plan is activated
                    : () {
                  _showPlanConfirmationDialog(
                    context,
                    SubscriptionList![index1]["id"].toString(),
                  );
                },
                child: Text(
                  isPlanActivated &&
                      SubdetailList![0]["plan_id"] == SubscriptionList![index1]["id"].toString()
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
