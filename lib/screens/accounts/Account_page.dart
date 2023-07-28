import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meatoz/screens/accounts/AccountsCustomCard.dart';
import 'package:meatoz/screens/accounts/profile_pages.dart';
import 'package:meatoz/screens/wishlist/wishlist_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/Alertbox_text.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';
import 'Add_address.dart';
import 'FAQ_page.dart';
import '../Login_page.dart';
import '../Orders_page.dart';
import 'Subscription_plans.dart';
import 'Settings.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  String? base = "https://meatoz.in/basicapi/public/";
  String? UID;
  String? datas;
  Map? responseData;
  List? dataList;
  int index = 0;
  bool isLoggedIn = false;

  Map? referal;
  List? referalList;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
      isLoggedIn = UID != null;
    });
    Apicall();
  }

  Future<void> Apicall() async {
    try {
      var response = await ApiHelper().post(endpoint: "common/profile", body: {
        "id": UID,
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          datas = response.toString();
          responseData = jsonDecode(response);
          dataList = responseData?["data"];
          print(responseData.toString());
        });
      } else {
        debugPrint('api failed:');
      }
    } catch (err) {
      debugPrint('An error occurred: $err');
    }
  }

  Future<void> ApiReferal() async {
    try {
      var response =
          await ApiHelper().post(endpoint: "refer/getReferralCode", body: {
        "id": UID,
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          datas = response.toString();
          referal = jsonDecode(response);
          referalList = referal?["reffercode"];
          print(responseData.toString());
        });
      } else {
        debugPrint('api failed:');
      }
    } catch (err) {
      debugPrint('An error occurred: $err');
    }
  }

  void openGmail() async {
    final url = "mailto:meatozhelp&support@gmail.com?subject=&body=";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),gapPadding: 20
            ),
            title: Text("Open Gmail"),
            content: Text("Are you sure"),
            actions: [
              TextButton(
                child:  AlertText(text: 'No',),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child:  AlertText(text: 'Yes',),
                onPressed: () {
                  launch(
                      "mailto:meatozhelp&support@gmail.com?subject=  &body=  ");
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var image = base! + (dataList?[index]["image"] ?? "").toString();
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "ACCOUNT",
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
        child: isLoggedIn
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Profile();
                        }),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.teal.shade800,
                                  Colors.teal.shade900,
                                ])),
                        height: 100,
                        child: Center(
                          child: dataList == null
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        '',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    title: Text(
                                      '',
                                      style: TextStyle(fontSize: 35),
                                    ),
                                    subtitle: Text(''),
                                  ),
                                )
                              : ListTile(
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(image),
                                  ),
                                  title: Text(
                                    dataList![index]["first_name"].toString(),
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  subtitle: Text(
                                    dataList![index]["email"].toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    AccountCustomTile(
                      title: "Add Address",
                      icon: Icons.add_home_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return AddAddress();
                        }),
                      ),
                    ),
                    Divider(),
                    AccountCustomTile(
                      title: "My Wishlist",
                      icon: Icons.favorite_border_sharp,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Wishlist();
                        }),
                      ),
                    ),
                    Divider(),
                    AccountCustomTile(
                      title: "My Orders",
                      icon: Icons.shopping_bag_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return MyOrders();
                        }),
                      ),
                    ),
                    Divider(),
                    AccountCustomTile(
                      title: "Subscription",
                      icon: Icons.local_offer_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Subscription();
                        }),
                      ),
                    ),
                    Divider(),
                    AccountCustomTile(
                      title: "Settings",
                      icon: Icons.settings_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return Settings();
                        }),
                      ),
                    ),
                    Divider(),
                    AccountCustomTile(
                      title: "Help & Support",
                      icon: Icons.help_outline_rounded,
                      onTap: () {
                        openGmail();
                      },
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Share.share(
                            "www.meatoz.in/Register/USR93",
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 25,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Invite a friend",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return FAQ();
                                }),
                              ),
                              icon: Icon(
                                Icons.help_outline_rounded,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/logo1.png",
                      height: 80,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
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
                      child: Text("Please LogIn"),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
