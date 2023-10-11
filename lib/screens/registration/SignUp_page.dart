import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Components/appbar_text.dart';
import '../../Config/ApiHelper.dart';
import 'Login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? UID;
  Map? signuplist;
  List? slist;

  checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    UID = prefs.getString("UID");
    print(UID);
  }

  bool showpass = true;

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
    try {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Handle case where user denies permission
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double latitude = position.latitude;
    double longitude = position.longitude;

    print(latitude);
    print(longitude);

    var response = await ApiHelper().post(endpoint: "common/signUP", body: {
      "name": _nameController.text.toString(),
      "email": _emailController.text.toString(),
      "contact": _contactController.text.toString(),
      "address": _addressController.text.toString(),
      "state": _stateController.text.toString(),
      "location": _locationController.text.toString(),
      "postal": _postalController.text.toString(),
      "password": _passwordController.text.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    }).catchError((err) {});
    if (response != null) {
      setState(() async {
        debugPrint('api successful:');
        signuplist = jsonDecode(response);

        print(response);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("UID", signuplist![0]["id"].toString());
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
    } catch (err) {
      debugPrint('An error occurred: $err');
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
                        const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: showpass,
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                          isDense: true,
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
                          labelText: "Password",
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
                      onPressed: () {
                        apiForSignup();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[900],
                          shadowColor: Colors.teal[300],),
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
