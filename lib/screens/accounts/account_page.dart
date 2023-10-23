import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meatoz/Config/image_url_const.dart';
import 'package:meatoz/screens/accounts/wallet.dart';
import 'package:meatoz/screens/accounts/widgets/AccountsCustomCard.dart';
import 'package:meatoz/screens/accounts/address_page.dart';
import 'package:meatoz/screens/accounts/privacy_terms.dart';
import 'package:meatoz/screens/wishlist/wishlist_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/alertbox_text.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../theme/colors.dart';
import '../splash_bottomNav/bottom_nav_bar.dart';
import 'edit_profile.dart';
import 'faq_page.dart';
import '../registration/login_page.dart';
import '../orders/Orders_page.dart';
import 'subscription_plans.dart';
import 'Settings.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  String? uID;
  String? data;
  Map? responseData;
  List? dataList;
  int index = 0;
  bool isLoggedIn = true;
  bool isLoading = true;

  Map? referral;
  List? referralList;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");
    setState(() {
      isLoggedIn = uID != null;
    });
    if (isLoggedIn) {
      apiForProfile();
      apiForReferral();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> apiForProfile() async {
    try {
      var response = await ApiHelper().post(endpoint: "common/profile", body: {
        "id": uID,
      });
      setState(() {
        isLoading = false;
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          data = response.toString();
          responseData = jsonDecode(response);
          dataList = responseData?["data"];
        });
      } else {
        debugPrint('api failed:');
      }
    } catch (err) {
      debugPrint('An error occurred: $err');
    }
  }

  Future<void> apiForReferral() async {
    try {
      var response =
          await ApiHelper().post(endpoint: "refer/getReferralCode", body: {
        "userid": uID,
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          referral = json.decode(response);
          referralList = referral?["reffercode"];
          // print(response);
          // print(referralList);
        });
      } else {
        debugPrint('api failed:');
      }
    } catch (err) {
      debugPrint('An error occurred: $err');
    }
  }

  void openGmail() async {
    final url = "mailto:customercare@meatoz.in?subject=&body=";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // shape: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(20),gapPadding: 20
            // ),
            title: Text("Open Gmail"),
            content: Text("Are you sure"),
            actions: [
              TextButton(
                child: AlertText(
                  text: 'No',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: AlertText(
                  text: 'Yes',
                ),
                onPressed: () {
                  launch("mailto:customercare@meatoz.in?subject=  &body=  ");
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
    var image =
        UrlConstants.base + (dataList?[index]["image"] ?? "").toString();
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "Account",
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return BottomNav();
              }),
            );
          },
          icon: Icon(Iconsax.arrow_left),
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
            ? isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Colors.teal[900]),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChangeProfile();
                          })),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: const [
                                      Color(ColorT.lightGreen),
                                      Color(ColorT.themeColor),
                                    ])),
                            height: 90,
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
                                      leading: Container(
                                        clipBehavior: Clip.antiAlias,
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(180),
                                          ),
                                        ),
                                        // Image border// Image radius
                                        child: CachedNetworkImage(
                                          imageUrl: image,
                                          placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator(
                                              color: Color(ColorT.themeColor),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/noItem.png"))),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      //   radius: 30,
                                      //   backgroundImage: NetworkImage(image),
                                      // ),
                                      title: Text(
                                        dataList![index]["first_name"]
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          dataList![index]["email"].toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: Colors.white),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AccountCustomTile(
                                    title: "My Orders",
                                    icon: Iconsax.note_21,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return MyOrders();
                                      }),
                                    ),
                                  ),
                                  AccountCustomTile(
                                    title: "Wallet",
                                    icon: Iconsax.wallet_3,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return WalletPage();
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.grey.shade500,
                                  ),
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.grey.shade500,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AccountCustomTile(
                                    title: "Wishlist",
                                    icon: Iconsax.archive_tick,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return Wishlist();
                                      }),
                                    ),
                                  ),
                                  AccountCustomTile(
                                    title: "Subscription",
                                    icon: Iconsax.user_tick,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return Subscription();
                                      }),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AccountCustomTile(
                          title: "Add Address",
                          icon: Iconsax.buildings,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return AddressBook();
                          })),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AccountCustomTile(
                          title: "Settings",
                          icon: Iconsax.setting_2,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Settings();
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AccountCustomTile(
                          title: "Help & Support",
                          icon: Iconsax.info_circle,
                          onTap: () {
                            openGmail();
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AccountCustomTile(
                          title: "Privacy info & Terms",
                          icon: Iconsax.security_safe,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Privacy();
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 10, top: 10, bottom: 10),
                            child: InkWell(
                              onTap: () {
                                Share.share(
                                  "www.meatoz.in/Register/${referralList![index]["referral_code"]}",
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.user_octagon,
                                    size: 20,
                                  ),
                                  SizedBox(width: 25),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Invite a friend",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return FAQ(
                                          section: "reffer_friend",
                                        );
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
