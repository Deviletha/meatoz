import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../Components/appbar_text.dart';
import 'privacy_policy.dart';
import 'refund_policy.dart';
import 'terms&conditions.dart';
import 'widgets/accounts_custom_card.dart';

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
        child: ListView(
          children: [
            AccountCustomTile(
              title: "Privacy Policy",
              icon: Iconsax.security,
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PrivacyPolicy();
              })),
            ),
            Divider(),
            AccountCustomTile(
              title: "Terms & Conditions",
              icon: Iconsax.security_time,
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TermsAndConditions();
              })),
            ),
            Divider(),
            AccountCustomTile(
              title: "Refund Policy",
              icon: Iconsax.security_card,
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
