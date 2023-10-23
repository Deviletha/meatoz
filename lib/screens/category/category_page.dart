import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

import '../../Config/api_helper.dart';
import '../../Config/image_url_const.dart';
import '../category_view/category_view.dart';
import '../homepage/Category/CategoryWidget.dart';
import '../splash_bottomNav/bottom_nav_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isLoading = true;

  ///CategoryList
  List? categoryList;

  @override
  void initState() {
    super.initState();
    apiForCategory();
  }

  apiForCategory() async {
    var response = await ApiHelper()
        .post(endpoint: "categories", body: {}).catchError((err) {});

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      setState(() {
        debugPrint('get products api successful:');
        categoryList = jsonDecode(response);
      });
    } else {
      debugPrint('api failed:');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Category"),
          leading: IconButton(
            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return BottomNav();
                }),
              );
            }, icon: Icon(Iconsax.arrow_left
          ),
          ),
        ),
        body: isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: GridView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: .95,
                  ),
                  itemCount: 8,
                  // Set a fixed count for shimmer effect
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(360),
                      ),
                    );
                  },
                ),
              )
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: .95,
                ),
                itemCount: categoryList == null ? 0 : categoryList?.length,
                itemBuilder: (context, index) => getCategoryRow(index),
              ),
            ));
  }

  Widget getCategoryRow(int index) {
    if (categoryList == null) {
      return Container(); // Handle the case when category-list is null
    }
    var image =
        UrlConstants.base + (categoryList![index]["image"] ?? "").toString();
    var itemName = categoryList![index]["name"].toString();

    return CategoryCard(
      itemName: itemName,
      imagePath: image,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryView(
              // url: image,
              itemName: categoryList![index]["name"].toString(),
              // description: categoryList![index]["description"].toString(),
              // price: categoryList![index]["price"].toString(),
              id: categoryList![index]["id"],
            ),
          ),
        );
      },
    );
  }
}
