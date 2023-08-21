import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meatoz/Components/appbar_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/ApiHelper.dart';
import 'FAQ_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool isLoading = true;
  String? UID;
  int index = 0;

  ///WalletAmountList
  Map? wallet;
  List? walletList;

  double WALLET_AMOUNT = 0;
  double WALLET_AMOUNT_L = 0;

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
    });
    apiForWalletAmount();
  }

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
        WALLET_AMOUNT_L = walletList![index]["wallet_amount"].toDouble();
        // Initialize the WALLET_AMOUNT to the maximum available value initially
        WALLET_AMOUNT = WALLET_AMOUNT_L;
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
        title: AppText(text: "WALLET"),
        actions: [
          IconButton(onPressed:
              () => Navigator.push(
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
                ])
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/wallet.png"),
            SizedBox(
              height: 10,
            ),
            Text("Your Wallet Amount Rs."+WALLET_AMOUNT_L.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
