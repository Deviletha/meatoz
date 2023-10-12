import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';



class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
    apiForProfile();
    getUserAddress();
  }

  Future<void> apiForProfile() async {
    try {
      var response = await ApiHelper().post(endpoint: "common/profile", body: {
        "id": uID,
      });
      if (response != null) {
        setState(() {
          debugPrint('profile api successful:');
          data = response.toString();
          responseData = jsonDecode(response);
          dataList = responseData?["data"];
          if (kDebugMode) {
            print(responseData.toString());
          }
        });
      } else {
        debugPrint('api failed:');
      }
    } catch (err) {
      debugPrint('An error occurred: $err');
    }
  }

  getUserAddress() async {
    var response = await ApiHelper().post(endpoint: "user/getAddress", body: {
      "userid": uID,
    }).catchError((err) {});
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
    var image = UrlConstants.base + (dataList?[index]["image"] ?? "").toString();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: AppText(
          text: "Profile",
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
        child: Center(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child:  Container(
                        clipBehavior: Clip.antiAlias,
                        width: 150,
                        height:150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(15),),
                        ),
                        // Image border// Image radius
                        child: CachedNetworkImage(
                          imageUrl: image,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/noItem.png"))),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                  ),
                  dataList == null
                      ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          width: 120,
                          height: 30,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 80,
                          height: 20,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 120,
                          height: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                      : Column(
                    children: [
                      Text(
                        dataList![index]["first_name"].toString(),
                        style: TextStyle(fontSize: 35),
                      ),
                      Text(
                        dataList![index]["phone"].toString(),
                      ),
                      Text(
                        dataList![index]["email"].toString(),
                      ),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: addressList == null ? 0 : addressList!.length,
                        itemBuilder: (context, index) =>
                            getAddressRow(index),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              addressList![index]["phone"].toString(),
              style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
