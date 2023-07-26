import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meatoz/screens/password.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/appbar_text.dart';
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
          title: const Text('Logout'),
          content: const Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
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
        title: AppText(text:
          "SETTINGS",
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
                ])
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ChangeProfile();
                    })),
                child: Row(
                  children: const [
                    Icon(
                      Icons.person_outline_outlined,
                      size: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ChangePassword();
                    })),
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_outlined,
                      size: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Change Password",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => _showLogoutConfirmationDialog(),
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout_outlined,
                      size: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}