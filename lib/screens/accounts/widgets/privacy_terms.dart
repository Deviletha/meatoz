import 'package:flutter/material.dart';
import '../../../Components/appbar_text.dart';
import '../privacy_policy.dart';
import '../refund_policy.dart';
import '../terms&conditions.dart';
import 'AccountsCustomCard.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "PRIVACY INFO",
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
              ],
            )),
        child
            : ListView(
          children: [
            AccountCustomTile(
              title: "Privacy Policy",
              icon: Icons.privacy_tip_outlined,
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PrivacyPolicy();
                  })),
            ),
            Divider(),
            AccountCustomTile(
              title: "Terms & Conditions",
              icon: Icons.note_outlined,
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TermsAndConditions();
                  })),
            ),
            Divider(),
            AccountCustomTile(
              title: "Refund Policy",
              icon: Icons.monetization_on_outlined,
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RefundPolicy();
                  })),
            ),
            Divider(),
            ],
        ),
      ),
    );
  }
}
