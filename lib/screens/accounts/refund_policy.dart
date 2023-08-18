import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../Components/appbar_text.dart';
import '../../../Config/ApiHelper.dart';

class RefundPolicy extends StatefulWidget {
  const RefundPolicy({Key? key}) : super(key: key);

  @override
  State<RefundPolicy> createState() => _RefundPolicyState();
}

class _RefundPolicyState extends State<RefundPolicy> {
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
          text: "Refund Policy",
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
                padding:  EdgeInsets.all(8.0),
                child: HtmlWidget(genralList![index]["return_policy"]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
