import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Config/ApiHelper.dart';
import 'FAQ_page.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  String? UID;
  String? datas;
  Map? responseData;
  List? userAddresslist;

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
      print(UID);
    });
    AddAddress();
  }

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final localityController = TextEditingController();
  final postalController = TextEditingController();
  final addressController = TextEditingController();
  final locationController = TextEditingController();
  final stateController = TextEditingController();

  Future<void> AddAddress() async {
    try {
      var response = await ApiHelper().post(endpoint: "user/saveAddress", body: {
        "name": nameController.text,
        "contact": contactController.text,
        "locality": localityController.text,
        "postal" : postalController.text,
        "address" : addressController.text,
        "location" : locationController.text,
        "state" : stateController.text,
        "latitude": "123",
        "longitude": "1234",
        "userid" : UID
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          datas = response.toString();
          responseData = jsonDecode(response);
          if (responseData?["status"] is List<dynamic>) {
            userAddresslist = responseData?["status"] as List<dynamic>?;
          } else {
            userAddresslist = null; // or handle the case when the response is not a list
          }
          print(responseData.toString());

        });
      }

      else {
        debugPrint('api failed:');

      }
    } catch (err) {
      debugPrint('An error occurred: $err');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return FAQ(
          section: "edit_address",
        );
      }),
    ),icon: Icon(Icons.help_outline_rounded))
        ],
      ),
      backgroundColor: Colors.white,
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
        child: ListView(
          children: [
            Text("Hey, User!",textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35,color: Colors.teal[900]),),
            Text("Complete your profile",textAlign: TextAlign.center,),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: Icon(Icons.account_circle_outlined,color: Colors.black),
                ),validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your name';
                } else {
                  return null;
                }
              },
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20),
              child: TextFormField(
                controller: localityController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_city_rounded,color: Colors.black),
                  labelText: "City",
                ),validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your city';
                } else {
                  return null;
                }
              },
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20),
              child: TextFormField(
                controller: contactController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_android_outlined,color: Colors.black),
                  labelText: "Mobile",
                ),validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your Number';
                } else {
                  return null;
                }
              },
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20),
              child: TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  prefixIcon: Icon(Icons.mail_outlined,color: Colors.black),

                ),validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your address';
                } else {
                  return null;
                }
              },
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20),
              child: TextFormField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Town",
                  prefixIcon: Icon(Icons.villa_outlined,color: Colors.black),

                ),validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your town';
                } else {
                  return null;
                }
              },
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20),
              child: TextFormField(
                controller: postalController,
                decoration: InputDecoration(
                  labelText: "Pin code",
                  prefixIcon: Icon(Icons.person_pin_circle_outlined,color: Colors.black),

                ),validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter you pin code';
                } else {
                  return null;
                }
              },
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35, right: 35, top: 20, bottom: 20),
              child: TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                  labelText: "State",
                  prefixIcon: Icon(Icons.edit_location_alt_outlined,color: Colors.black,),
                ),validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your state';
                } else {
                  return null;
                }
              },
                textInputAction: TextInputAction.next,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: ElevatedButton(
                onPressed: () {
                  AddAddress();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[900],
                    shadowColor: Colors.teal[300],minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                    )),
                child: Text("Change Address"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
