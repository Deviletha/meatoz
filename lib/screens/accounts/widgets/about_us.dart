import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:meatoz/Components/text_widget.dart';
import '../../../Components/appbar_text.dart';
import '../../../Config/ApiHelper.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  Map? list;
  List? genralList;
  int index = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    generalDetailsApi();
  }

  generalDetailsApi() async {
    var response = await ApiHelper()
        .post(endpoint: "generalInfo/get", body: {})
        .catchError((err) {});
    if (response != null) {
      setState(() {
        debugPrint('general detailsapi successful:');
        list = jsonDecode(response);
        genralList = list!["general_info"];
      });
    } else {
      debugPrint('api failed:');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "ABOUT US",
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
              ],
            )),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Show a CircularProgressIndicator while loading
            : ListView(
          children: [
            if (genralList != null) ...[
              TextConst(text: genralList![index]["shop_name"].toString()),
              TextConst(
                  text:
                  "Location: ${genralList![index]["address"] + "," + genralList![index]["location"]}"),
              TextConst(text: "Pin Code: ${genralList![index]["pincode"]}"),
              TextConst(
                  text: "License No: ${genralList![index]["license_number"]}"),
              TextConst(
                  text:
                  "Terms & Conditions: ${genralList![index]["terms_and_conditions"]}"),
              TextConst(
                  text:
                  "Privacy & Policy: ${genralList![index]["privacy_policy"]}"),
            ],
          ],
        ),
      ),
    );
  }
}
