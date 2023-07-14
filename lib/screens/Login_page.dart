import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meatoz/constants/appbar_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/ApiHelper.dart';
import 'BottomNavBar.dart';
import 'SignUp_page.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map? user;
  List? UserList;
  String? UID;
  bool showpass = true;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            text: "LOGIN",
          ),
          backgroundColor: Colors.teal[900],
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 40, bottom: 20),
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.account_box_sharp),
                  hintText: "Phone Number",
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10))),
                ),
                textInputAction: TextInputAction.next,
                validator: (uname) {
                  if (uname!.isEmpty || !uname.contains('')) {
                    return 'Enter a valid Phone Number';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 20),
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
                  hintText: "Password",
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
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
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  String username = usernameController.text.toString();
                  String password = passwordController.text.toString();
                  if (username.isNotEmpty && password.isNotEmpty) {
                    var response = await ApiHelper()
                        .post(endpoint: "common/authenticate", body: {
                      'username': username,
                      'password': password,
                    }).catchError((err) {});
                    if (response != null) {
                      setState(() {
                        debugPrint('API successful:');
                        UserList = jsonDecode(response);
                      });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString(
                          "UID", UserList![0]["id"].toString());
                      checkUser();
                      Fluttertoast.showToast(
                        msg: "Login success",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomNav()),
                      );
                    } else {
                      // API call failed
                      debugPrint('API failed:');
                      Fluttertoast.showToast(
                        msg: "Login failed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.SNACKBAR,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  } else {
                    // Username or password is empty
                    Fluttertoast.showToast(
                      msg: "Please enter username and password",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[900],
                    shadowColor: Colors.teal[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    )),
                child: Text("Login"),
              ),
            ),
            TextButton(
              child: Text("Don't have an account? Sign Up",
                  style: TextStyle(fontSize: 15, color: Colors.black45)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
