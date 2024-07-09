import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GetVars/initial.dart';
import '../display_product.dart';

class OrderHelper {
  final GetVars GetVarsCtrl = Get.put(GetVars());

  Future<void> placeOrder() async {
    DateTime now = DateTime.now();
    String formattedDate = '${now.day}-${now.month}-${now.year}';
    final _databaseReference = FirebaseDatabase.instance.ref();

    for (var order in globalOrderList) {
      final Map<String, dynamic> data = {
        'csName': "${GetVarsCtrl.currentUserName}",
        'time': "${GetVarsCtrl.currentTime}",
        'date': "${formattedDate}",
        'price': "${order['price']}",
        "uID": GetVarsCtrl.auth.currentUser!.uid,
        "status": "pending",
        "item": "${order['name']}"
      };

      final Map<String, dynamic> userPersonalData = {
        'csName': "${GetVarsCtrl.currentUserName}",
        'time': "${GetVarsCtrl.currentTime}",
        'date': "${formattedDate}",
        'price': "${order['price']}",
        "uID": GetVarsCtrl.auth.currentUser!.uid,
        "status": "pending",
        "item": "${order['name']}"
      };

      final DatabaseReference sellerRef =
      _databaseReference.child('Sellers').child(GetVarsCtrl.auth.currentUser!.uid);
      await sellerRef
          .child('Orders')
          .child("${order['name'] + GetVarsCtrl.auth.currentUser!.uid}")
          .set(data);

      final _databaseReferencePersonal = FirebaseDatabase.instance.ref();
      final DatabaseReference sellerRefPersonal = _databaseReferencePersonal
          .child('Sellers')
          .child(GetVarsCtrl.auth.currentUser!.uid);
      await sellerRefPersonal
          .child('Orders')
          .child("${order['name'] + GetVarsCtrl.auth.currentUser!.uid}")
          .set(userPersonalData);
    }

    Get.snackbar(
      'Success',
      'Order placed successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      borderRadius: 10,
    );
  }
}
