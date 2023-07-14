import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Config/ApiHelper.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {


  final passwordController = TextEditingController();
  final newPassController = TextEditingController();
  String? UID;
  bool showpass = true;
  Map? passlist;
  Map? passlist1;
  Map? Finalpasswrd;
  int index = 0;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
  }

  ChangePassword() async {
    var response = await ApiHelper().post(
      endpoint: "common/resetPassword",
      body: {
        "id": UID,
        "password": newPassController.text,
      },
    ).catchError((err) {});

    if (response != null) {
      setState(() {
        debugPrint('change password api successful:');
        passlist = jsonDecode(response);
        passlist1 = passlist!["status"];
        Finalpasswrd = passlist1!["user"];

        Fluttertoast.showToast(
          msg: "Password Changed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Navigate back to the settings page
        Navigator.pop(context);
      });
    } else {
      debugPrint('reset password failed:');
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.teal[900]),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: passwordController,
              obscureText: showpass,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        if (showpass) {
                          showpass = false;
                        } else {
                          showpass = true;
                        }
                      });
                    },
                    icon: Icon(
                      showpass == true
                          ? Icons.visibility_off
                          : Icons.visibility,
                    )),
                labelText: "New Password",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),
              textInputAction: TextInputAction.done,
              validator: (Password) {
                if (Password!.isEmpty || Password.length < 6) {
                  return "Enter a valid Password, length should be greater than 6";
                } else {
                  return null;
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 20, bottom: 20),
            child: TextFormField(
              controller: newPassController,
              obscureText: showpass,
              obscuringCharacter: "*",
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        if (showpass) {
                          showpass = false;
                        } else {
                          showpass = true;
                        }
                      });
                    },
                    icon: Icon(
                      showpass == true
                          ? Icons.visibility_off
                          : Icons.visibility,
                    )),
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),
              textInputAction: TextInputAction.done,
              validator: (Password) {
                if (Password!.isEmpty || Password.length < 6) {
                  return "Enter the same Password, as above";
                } else {
                  return null;
                }
              },
            ),
          ),
          SizedBox(
            width: 350,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ChangePassword();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shadowColor: Colors.teal[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  )),
              child: Text("Change Password"),
            ),
          ),
        ],
      ),
    );
  }
}
