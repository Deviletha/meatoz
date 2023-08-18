import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../Components/appbar_text.dart';
import '../../../Config/ApiHelper.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
          text: "Privacy Policy",
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
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                child: HtmlWidget(genralList![index]["privacy_policy"]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
