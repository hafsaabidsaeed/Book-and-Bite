import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:get/get.dart';
// import 'package:your_app/firebase_service.dart'; // Import your Firebase service

class MenuControllerData extends GetxController {
  final GetVarsCtrl = Get.put(GetVars());
  List menuData = [];
  List ordersData = [];
  List TempListData = [];
  List ordersCompleted = [];
  bool isRestaurant = true;

  @override
  void onInit() {
    // print("hiInit");
    getSellerCreds();
    myOrders();
    super.onInit();
    // fetchMenu(); // Fetch menus when the controller initializes
  }

  getSellerCreds() async {
    print("hiInit");
    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      var data = await databaseReference
          .child('Sellers')
          .child(GetVarsCtrl.uID)
          .once();
      var gotData = data.snapshot.value as Map;
      menuData.clear();
      print("dsdsdsd ****");
      if (gotData["shopType"] == "print") {
        isRestaurant = false;
        update();
        print("isRestaurant h ya  h **** ${isRestaurant}");
      }

      menuData.addAll(gotData["menus"].values.toList());
      menuData.toSet();
      print("yhi h ${data}");
      update();
    } catch (e) {
      print("${e}");
    }
    update();
  }

  myOrders() async {
    print("orders+*********");
    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      var data = await databaseReference
          .child('Sellers')
          .child(GetVarsCtrl.uID)
          .once();
      var gotData = data.snapshot.value as Map;
      ordersData.clear();
      TempListData.clear();
      ordersCompleted.clear();
      TempListData.addAll(gotData["Orders"].values.toList());
      TempListData.toSet();

      for (var i = 0; i < TempListData.length; i++) {
        if (TempListData[i]["status"] == "done") {
          ordersCompleted.add(TempListData[i]);
        } else {
          ordersData.add(TempListData[i]);
        }
      }

      ordersData.toSet();
      ordersCompleted.toSet();
      print("yhi h orders ************  ${ordersCompleted}");
      update();
    } catch (e) {
      print("${e}");
    }
    update();
  }
}
