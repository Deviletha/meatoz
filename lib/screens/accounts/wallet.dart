import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meatoz/Components/appbar_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Config/api_helper.dart';
import 'faq_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool isLoading = true;
  String? uID;
  int index = 0;

  ///WalletAmountList
  Map? wallet;
  List? walletList;

  double walletAmount = 0;
  double walletAmountL = 0;

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
    apiForWalletAmount();
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
        debugPrint('Wallet successful:');
        wallet = jsonDecode(responseWallet);
        walletList = wallet!["walletAmount"];
        walletAmountL = walletList![index]["wallet_amount"].toDouble();
        // Initialize the walletAmount to the maximum available value initially
        walletAmount = walletAmountL;
      });
    } else {
      debugPrint('wallet api failed:');
    }
  }

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: "Wallet"),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return FAQ(
                        section: "wallet",
                      );
                    }),
                  ),
              icon: Icon(Icons.help_outline_rounded))
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/wallet.png"),
            SizedBox(
              height: 10,
            ),
            Text(
              "Your Wallet Amount Rs.$walletAmountL",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
