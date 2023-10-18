import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meatoz/Components/alertbox_text.dart';
import 'package:meatoz/screens/accounts/widgets/AccountsCustomCard.dart';
import 'package:meatoz/screens/accounts/password.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/appbar_text.dart';
import '../splash_bottomNav/BottomNavBar.dart';
import 'EditProfile.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  Future<void> _showLogoutConfirmationSnackBar() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Do you want to logout from app'),
        action: SnackBarAction(
          label: 'YES',
          textColor: Colors.red,
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return BottomNav();
              }),
            );

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
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "Settings",
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              AccountCustomTile(
                title: "Edit Profile",
                icon: Iconsax.user_edit,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return ChangeProfile();
                })),
              ),
              SizedBox(
                height: 10,
              ),
              AccountCustomTile(
                title: "Change Password",
                icon: Iconsax.keyboard,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return ChangePassword();
                })),
              ),
              SizedBox(
                height: 10,
              ),
              AccountCustomTile(
                title: "Logout from App",
                icon: Iconsax.logout,
                onTap: () => _showLogoutConfirmationSnackBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
