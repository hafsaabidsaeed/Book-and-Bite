import 'package:firebase_database/firebase_database.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:get/get.dart';

class AllSellers extends GetxController {
  final getVarsGlobal = Get.put(GetVars());
  List<dynamic> sellers = [];
  List<dynamic> menuData = [];
  List<dynamic> allMenus = [];
  List<dynamic> allPrinters = [];

  @override
  void onInit() {
    //yahan par we are calling two methods to fetch data from firebase when controller is initialized
    // sellers or unki products ka data will be fetched from firebase added by them
    getAllSellers();
    allProduct();
    super.onInit();
  }

  //updates loading status and shows changes made in UI
  loadNew(valNew) {
    getVarsGlobal.loading(valNew);
    update();
  }

  //
  void getAllSellers() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    var data = await databaseReference.child('Sellers').once();
    var gotData = data.snapshot.value as Map;

    sellers.clear();
    allPrinters.clear();
    if (gotData != null) {
      gotData.forEach((key, value) {
        if (value['shopType'] == "restaurant" &&
            value['shopName'].toString().isNotEmpty) {
          sellers.add(value);
        } else if (value['shopType'] == "print" &&
            value['shopName'].toString().isNotEmpty) {
          allPrinters.add(value);
        }
      });
      print(allPrinters);
    }
    update();
  }

  void allProduct() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    var data = await databaseReference.child('Sellers').once();
    if (data != null && data.snapshot.value != null) {
      var sellersData = data.snapshot.value as Map<dynamic, dynamic>;
      sellersData.forEach((sellerId, sellerData) {
        if (sellerData != null && sellerData['menus'] != null) {
          var menus = sellerData['menus'] as Map<dynamic, dynamic>;
          menus.values.forEach((menu) {
            allMenus.add(menu);
          });
        }
      });
      print(allMenus);
    }
  }
}
