import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../theme/colors.dart';
import 'add_address.dart';
import 'faq_page.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({Key? key}) : super(key: key);

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  String? uID;
  String? data;
  Map? responseData;
  List? dataList;
  int index = 0;
  Map? address;
  List? addressList;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  Future<void> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uID = prefs.getString("UID");
    });
    getUserAddress();
  }

  bool isLoading = true;

  getUserAddress() async {
    var response = await ApiHelper().post(endpoint: "user/getAddress", body: {
      "userid": uID,
    }).catchError((err) {});
    setState(() {
      isLoading = false;
    });
    if (response != null) {
      setState(() {
        debugPrint('get address api successful:');
        address = jsonDecode(response);
        addressList = address!["status"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText(
          text: "Address Book",
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return FAQ(
                        section: "edit_address",
                      );
                    }),
                  ),
              icon: Icon(Icons.help_outline_rounded))
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.teal[900]),
            )
          : Container(
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
              child: Center(
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                addressList == null ? 0 : addressList!.length,
                            itemBuilder: (context, index) =>
                                getAddressRow(index),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return AddAddress();
              }),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(ColorT.themeColor),
            shadowColor: Colors.teal[300],
            minimumSize: Size.fromHeight(50),
          ),
          child: Text("Add New Address"),
        ),
      ),
    );
  }

  Widget getAddressRow(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            addressList == null
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 20,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    addressList![index]["address"].toString(),
                    style: const TextStyle(color: Colors.red),
                  ),
            SizedBox(
              height: 5,
            ),
            Text(
              addressList![index]["phone"].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              addressList![index]["city"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              addressList![index]["pincode"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              addressList![index]["state"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
