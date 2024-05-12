import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ShopItemsClass extends GetxController {
  Map sellerData = {};
  List menuData = [];

  getSpecificSellerCreds(uID) async {
    // print("hi2");
    try {
      // print("hi3");
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      var data = await databaseReference.child('Sellers').child(uID).once();
      var gotData = data.snapshot.value as Map;
      sellerData = gotData;
      menuData.clear();
      menuData.addAll(sellerData["menus"].values.toList());
      menuData.toSet();

      update();
    } catch (e) {
      print("${e}");
      // scaffoldMsg(context, "Check Internet Connection !");
    }
  }
}
