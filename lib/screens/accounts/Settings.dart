import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meatoz/Components/Alertbox_text.dart';
import 'package:meatoz/screens/accounts/AccountsCustomCard.dart';
import 'package:meatoz/screens/accounts/password.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/appbar_text.dart';
import 'EditProfile.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),gapPadding: 20
          ),
          title:  Text('Logout'),
          content:  Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              child:  AlertText(text: 'Cancel',),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: AlertText(text: 'Logout',),
              onPressed: () async {
                Navigator.of(context).pop();

                // Clear the user session data
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove("UID");
                Fluttertoast.showToast(
                  msg: "Logged out",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "SETTINGS",
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
        child: Column(
          children: [
            AccountCustomTile(
              title: "Edit Profile",
              icon: Icons.person_outline_outlined,
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChangeProfile();
              })),
            ),
            Divider(),
            AccountCustomTile(
              title: "Change Password",
              icon: Icons.keyboard_outlined,
              onTap: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ChangePassword();
              })),
            ),
            Divider(),
            AccountCustomTile(
              title: "Logout",
              icon: Icons.logout_outlined,
              onTap: () => _showLogoutConfirmationDialog(),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
