import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/all_sellers.dart';
import 'package:secondevaluation/GetVars/shopItems.dart';
import 'package:secondevaluation/Loader/loader.dart';
import 'package:secondevaluation/Screens/PrintShop/Customer_View.dart';
import 'package:secondevaluation/Screens/about_us.dart';
import 'package:secondevaluation/Screens/complaint_sc.dart';
import 'package:secondevaluation/Screens/customer_completed.dart';
import 'package:secondevaluation/Screens/product_list.dart';
import 'package:secondevaluation/Screens/product_grid.dart';
import 'package:secondevaluation/Screens/settings.dart';
import 'package:secondevaluation/Screens/shop_Items.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../GetVars/initial.dart';

class Home_Sc extends StatelessWidget {
  Home_Sc({super.key});
  final GetVarsCtrl = Get.put(GetVars());
  final allSellersData = Get.put(AllSellers());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSellers>(builder: (aS) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 76, 197, 193),
          title: const Text(
            "Book & Bite",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          child: Column(
            children: [

              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 76, 197, 193),
                ),
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('COMSATS \n Book & Bite',
                    style: TextStyle(color: Colors.white,
                        fontSize: 22, fontWeight: FontWeight.bold ),
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.print),
                title: const Text('Printing Shop'),
                onTap: () {
                  Get.to(CustomerView());
                },
              ),
              ListTile(
                leading: const Icon(Icons.note_alt_outlined),
                title: const Text('Order Status'),
                onTap: () {
                  Get.to(CustomerCompltePage());
                },
              ),

              ListTile(
                leading: const Icon(Icons.notes),
                title: const Text('Complaints'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const ComplaintScreen();
                      },
                    ),
                  );
                },
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return  SettingsScreen();
                      },
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('About Us'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const AboutUsScreen();
                      },
                    ),
                  );
                },
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),

              ElevatedButton(
                  onPressed: () async {
                    // print('Sign-out button pressed ********************');
                    GetVarsCtrl.loading(true); //this shows loader before signout is complated
                    // print('Loader shown ********************************');
                    try{
                      // print('Sign-out successful ******************************');
                      await GetVarsCtrl.auth.signOut();  //yahan pr perform hoga signout operation
                    } catch(e) {
                      print('Error signing out *******: $e');
                    }finally{
                      GetVarsCtrl.loading(false);  // loader ko band kr diaaaa
                      // print('Loader hidden **************************************');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      )
                  ),
                  child: const Text("Logout")),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: GetBuilder<GetVars>(builder: (gV) {
            return allSellersData.allMenus.length != 0
                ? Container(
                    height: Get.height,
                    width: Get.width,
                    // color: const Color.fromARGB(255, 240, 240, 240),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: Get.height / 04,
                            width: Get.width,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 211, 254, 253),
                                borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Restaurants",
                                  style: TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.w300),
                                ),
                                Container(
                                  height: Get.height / 05.5,
                                  width: Get.width,
                                  // color: Colors.green,
                                  child: ProductList(),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Menus",
                                  style: TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.w300),
                                ),
                                Container(
                                  height: Get.height / 1.8,
                                  width: Get.width,
                                  // color: Colors.red,
                                  child: ProductGrid(
                                    itemList: allSellersData.allMenus,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                : const LoaderCustom();
          }),
        ),
      );
    });
  }
}
