import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import 'Login_page.dart';

class SignupPage1 extends StatefulWidget {
  const SignupPage1({Key? key, required String referralCode}) : super(key: key);

  @override
  State<SignupPage1> createState() => _SignupPage1State();
}

class _SignupPage1State extends State<SignupPage1> {
  String? uID;
  Map? signupList;


  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    uID = prefs.getString("UID");

  }

  bool showPass = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  apiForSignup() async {
    var response = await ApiHelper().post(endpoint: "common/signUP", body: {
      "name": _nameController.text,
      "email": _emailController.text,
      "contact": _contactController.text,
      "address": _addressController.text,
      "state": _stateController.text,
      "location": _locationController.text,
      "postal": _postalController.text,
      "password": _passwordController.text,
      "latitude": _latitudeController.text,
      "longitude": _longitudeController.text,
    }).catchError((err) {});
    if (response != null) {
      setState(() async {
        debugPrint('api successful:');
        signupList = jsonDecode(response);

        if (kDebugMode) {
          print(response);
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("UID", signupList![0]["id"].toString());
        checkUser();
        Fluttertoast.showToast(
          msg: "Signup success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  void initState() {
    apiForSignup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AppText(text: "SIGNUP",),
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height/1,
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Name",),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid name';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 15,
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Email ID",
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Enter a valid Email ID';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 15,),
                    child: TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Mobile",
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a valid Number";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 15,top: 15),
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Address",
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid Address';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "State",
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid State';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "location",
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid location';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: TextFormField(
                      controller: _postalController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Postal code",
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a valid Postal code';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: showPass,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                        isDense: true,
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
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: TextFormField(
                      controller: _latitudeController,
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Latitude",
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter latitude';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: TextFormField(
                      controller: _longitudeController,
                      decoration: InputDecoration(
                        isDense: false,
                        labelText: "Longitude",
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter longitude';
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
                        apiForSignup();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[900],
                          shadowColor: Colors.teal[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          )),
                      child: Text("Sign Up"),
                    ),
                  ),
                  TextButton(
                    child: Text("Already have an account? Login",
                        style: TextStyle(fontSize: 15, color: Colors.black45)),
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
