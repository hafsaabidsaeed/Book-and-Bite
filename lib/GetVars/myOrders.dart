import 'package:firebase_database/firebase_database.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:get/get.dart';

class MyOrdersGx extends GetxController {
  final GetVarsCtrl = Get.put(GetVars());

  List ordersData = [];

  @override
  void onInit() {
    GetVarsCtrl.isLoadingChange(true);
    myOrders();
    super.onInit();
    GetVarsCtrl.isLoadingChange(false);
  }

  myOrders() async {

    try {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference();
      var data = await databaseReference
          .child('Sellers')
          .child(GetVarsCtrl.uID)
          .once();
      var gotData = data.snapshot.value as Map;
      ordersData.clear();
      ordersData.addAll(gotData["Orders"].values.toList());
      ordersData.toSet();
      // print("yhi h orders ************  ${ordersData}");
      update();
    } catch (e) {
      // print("${e}");
    }
    update();

  }
}
