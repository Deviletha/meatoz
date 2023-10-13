import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../splash_bottomNav/BottomNavBar.dart';
import 'SignUp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map? user;
  List? userList;
  String? uID;
  bool showPass = true;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");

  }

  apiForLogin() async {
    String username = usernameController.text.toString();
    String password = passwordController.text.toString();
    if (username.isNotEmpty && password.isNotEmpty) {
      var response = await ApiHelper()
          .post(endpoint: "common/authenticate", body: {
        'username': username,
        'password': password,
      }).catchError((err) {});

      if (response != null) {
        var jsonResponse = jsonDecode(response);
        if (jsonResponse is List && jsonResponse.isNotEmpty) {
          if (jsonResponse[0]["error"] == "username or password is incorrect") {
            // Username or password is incorrect
            debugPrint('API failed:');
            Fluttertoast.showToast(
              msg: "Username or password is incorrect",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          } else {
            // Successful login
            setState(() {
              debugPrint('API successful:');
              userList = jsonResponse;
              if (kDebugMode) {
                print(response);
              }
            });
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString("UID", userList![0]["id"].toString());
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
          }
        }
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
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            text: "Login",
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo_short.png",height: 100,),
              Padding(
                padding: const EdgeInsets.only(
                    left: 35, right: 35, top: 80, bottom: 20),
                child: TextFormField(cursorColor: Colors.teal[900],
                  controller: usernameController,
                  decoration: InputDecoration(fillColor: Colors.teal[100],
                    labelText: 'Phone Number',
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
                    left: 35, right: 35, top: 10, bottom: 20),
                child: TextFormField(cursorColor: Colors.teal[900],
                  controller: passwordController,
                  obscureText: showPass,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (showPass) {
                              showPass = false;
                            } else {
                              showPass = true;
                            }
                          });
                        },
                        icon: Icon(
                          showPass == true
                              ? Icons.visibility_off
                              : Icons.visibility,
                        )),
                    labelText: "Password",
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (password) {
                    if (password!.isEmpty || password.length < 6) {
                      return "Enter a valid Password, length should be greater than 6";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    apiForLogin();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[900],
                      shadowColor: Colors.teal[300],),
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
      ),
    );
  }
}
