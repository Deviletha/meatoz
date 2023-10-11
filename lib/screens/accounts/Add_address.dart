import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../../Config/ApiHelper.dart';
import 'FAQ_page.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  String? UID;

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      UID = prefs.getString("UID");
    });
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

      var response = await ApiHelper().post(endpoint: "user/saveAddress", body: {
        "name": nameController.text.toString(),
        "contact": contactController.text.toString(),
        "locality": localityController.text.toString(),
        "postal" : postalController.text.toString(),
        "address" : addressController.text.toString(),
        "location" : locationController.text.toString(),
        "state" : stateController.text.toString(),
        "latitude": latitude.toString(),
        "longitude": longitude.toString(),
        "userid" : UID
      });
      if (response != null) {
        setState(() {
          debugPrint('add address api successful:');
          print(response);

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
  void initState() {
   checkUser();
    super.initState();
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
                  prefixIcon: Icon(Iconsax.user,color: Colors.black),
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
                  prefixIcon: Icon(Iconsax.buildings,color: Colors.black),
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
                  prefixIcon: Icon(Iconsax.call_add
                      ,color: Colors.black),
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
                  prefixIcon: Icon(Iconsax.message_add,color: Colors.black),

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
                  prefixIcon: Icon(Iconsax.building_3,color: Colors.black),

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
                  prefixIcon: Icon(Iconsax.location_add,color: Colors.black),

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
                  prefixIcon: Icon(Iconsax.location,color: Colors.black,),
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
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: ElevatedButton(
                onPressed: () {
                  AddAddress();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[900],
                    shadowColor: Colors.teal[300],minimumSize: Size.fromHeight(50),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.only(
                    //       bottomLeft: Radius.circular(15),
                    //       topRight: Radius.circular(15)),
                    // )
                ),
                child: Text("Add Address"),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
