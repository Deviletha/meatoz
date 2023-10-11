import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';
import 'FAQ_page.dart';


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
  int index = 0;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
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
        title: AppText(text:
          "Change Password",
        ),
        actions: [
          IconButton(onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return FAQ(
                section: "change_password",
              );
            }),
          ), icon: Icon(Icons.help_outline_rounded))
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
          children: [
            Image.asset("assets/logo_short.png",height: 100,),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20, bottom: 20),
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
                ),
                textInputAction: TextInputAction.next,
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
                  left: 35, right: 35, top: 20, bottom: 40),
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ChangePassword();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[900],
                      shadowColor: Colors.teal[300],),
                  child: Text("Change Password"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
