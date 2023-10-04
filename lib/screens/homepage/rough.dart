

///OUR PRODUCT CARD

// OurProductCard(
//   ItemName: ourProductList![index2]["name"].toString(),
//   ImagePath: image,
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductView(
//           stock: ourProductList![index2]["stock"].toString(),
//           recipe: "Recipe not available for this item",
//           position: index2,
//           id: PID,
//           productname: ourProductList![index2]["name"].toString(),
//           url: image,
//           description: ourProductList![index2]["description"].toString(),
//           amount: ourProductList![index2]["offerPrice"].toString(),
//           combinationId: CombID,
//           psize: ourProductList![index2]["size_attribute_name"].toString(),
//         ),
//       ),
//     );
//   },
//   onPressed: () {
//     addTowishtist(PID, CombID, ourProductList![index2]["offerPrice"].toString(), context);
//   },
//   TotalPrice: price,
//   combinationId: CombID,
//   OfferPrice: offerPrice,
//   Description: ourProductList![index2]["description"].toString());

/// DEAL OF THE DAY CARD

// DealOfTheDayCard(
//   combinationId: CombID,
//   ItemName: dealOfTheDayList![index]["name"].toString(),
//   ImagePath: image,
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductView(
//           stock: dealOfTheDayList![index]["stock"].toString(),
//           recipe: "Recipe not available for this product",
//           position: index,
//           id: PID,
//           productname: dealOfTheDayList![index]["name"].toString(),
//           url: image,
//           description: dealOfTheDayList![index]["description"].toString(),
//           amount: dealOfTheDayList![index]["offerPrice"].toString(),
//           combinationId: CombID,
//           psize: dealOfTheDayList![index]["size_attribute_name"].toString(),
//         ),
//       ),
//     );
//   },
//   onPressed: () {
//     addTowishtist(PID, CombID, dealOfTheDayList![index]["offerPrice"].toString(), context);
//     // check(CombID,PID,dealOfTheDayList![index]["offerPrice"].toString());
//   },
//   TotalPrice: price,
//   OfferPrice: offerPrice,
//   Description: dealOfTheDayList![index]["description"].toString());


/// ALL PRODUCTS CARD


//   ProductTile(
//   ItemName: Finalproductlist![index]["combinationName"].toString(),
//   ImagePath: image,
//   onPressed: () {
//     check(CombID, PID, Finalproductlist![index]["offerPrice"].toString());
//     // Check if the combination ID is in Prlist
//     if (Prlist!.contains(CombID)) {
//       Icon(
//         Iconsax.heart5,
//         color: Colors.red,
//         size: 30,
//       );
//
//       // Item is in the Prlist, set favorite icon color to red
//       // You'll need to update this logic based on how you're displaying the favorite icon
//     } else {
//       Icon(
//         Iconsax.heart,
//         color: Colors.black,
//         size: 30,
//       );
//       // Item is not in the Prlist, set favorite icon color to black
//       // You'll need to update this logic based on how you're displaying the favorite icon
//     }
//   },
//
//   // onPressed: () {
//   //   check(CombID,PID,Finalproductlist![index]["offerPrice"].toString());
//   //
//   // } ,
//   TotalPrice: price,
//   OfferPrice: offerPrice,
//   Description: Finalproductlist![index]["description"].toString(),
//   onTap: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProductView(
//           stock: Finalproductlist![index]["stock"].toString(),
//           recipe: Finalproductlist![index]["hint"].toString(),
//           position: index,
//           id: PID,
//           productname:
//           Finalproductlist![index]["combinationName"].toString(),
//           url: image,
//           description: Finalproductlist![index]["description"].toString(),
//           amount: Finalproductlist![index]["offerPrice"].toString(),
//           combinationId: CombID,
//           psize: Finalproductlist![index]["size_attribute_name"].toString(),
//         ),
//       ),
//     );
//   }, combinationId: CombID,
// );


/// CHECK FUNCTION


// Future<void> check(String id,String  PID, String amount) async {
//
//   if(WID=="NO"|| WID==null){
//     addwisH(id,"YES");
//     addTowishtist(PID, id,amount, context,);
//   }
//   else{
//     addwisH(id, "NO");
//   }
//   final prefs = await SharedPreferences.getInstance();
//   setState(() {
//     WID = prefs.getString(id)!;
//   });
//
// }

// addwisH(String wid,String v) async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString(
//       wid, v );
// }
