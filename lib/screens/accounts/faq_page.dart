
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../Components/appbar_text.dart';
import '../../Config/api_helper.dart';
import '../../theme/colors.dart';

class FAQ extends StatefulWidget {
  final String section;

  const FAQ({Key? key, required this.section}) : super(key: key);

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  Map? faq;
  List? faqList;
  int index = 0;
  bool isLoading = true;

  @override
  void initState() {
    getFAQ();
    super.initState();
  }

  getFAQ() async {

    var response = await ApiHelper().post(
      endpoint: "faq/get",
      body: {
        "section": widget.section,
      },
    ).catchError((err) {});

    setState(() {
      isLoading = false; // Set isLoading back to false after API response
    });

    if (response != null) {
      setState(() {
        debugPrint('FAQ api successful:');
        faq = jsonDecode(response);
        faqList = faq!["faq"];
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: "FAQ's"),
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
            ])),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.teal[900],
                ),
              )
            : ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Color(ColorT.themeColor),),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(faqList![index]["heading"].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          faqList![index]["content"].toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
