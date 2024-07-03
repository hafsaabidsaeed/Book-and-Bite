import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:get/get.dart';

class ChangeStatus extends GetxController {
  final GetVarsCtrl = Get.put(GetVars());

  changeStatus({val, productName, cmUserID}) async {
    final _databaseReference = FirebaseDatabase.instance.ref();

    final Map<String, dynamic> data = {
      "status": "$val",
    };

    final Map<String, dynamic> userPersonalData = {
      "status": "$val",
    };
    if (kDebugMode) {
      print("My UID : ${GetVarsCtrl.auth.currentUser!.uid}");
    }
    final DatabaseReference sellerRef = _databaseReference
        .child('Sellers')
        .child(GetVarsCtrl.auth.currentUser!.uid);
    await sellerRef
        .child('Orders')
        .child("${productName + cmUserID}")
        .update(data);

    final _databaseReferencePersonal = FirebaseDatabase.instance.ref();
    final DatabaseReference sellerRefPersonal =
        _databaseReferencePersonal.child('Sellers').child(cmUserID);
    await sellerRefPersonal
        .child('Orders')
        .child("${productName + cmUserID}")
        .update(userPersonalData);
    update();
  }

  chnagePrintStatus({val, sellerName}) async {
    final _databaseReference = FirebaseDatabase.instance.ref();

    final Map<String, dynamic> data = {
      "status": "$val",
    };

    final DatabaseReference sellerRef = _databaseReference
        .child('Sellers')
        .child(GetVarsCtrl.auth.currentUser!.uid);
    await sellerRef.child('Orders').child("$sellerName").update(data);
  }
}
