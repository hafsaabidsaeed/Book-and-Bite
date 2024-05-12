import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/all_sellers.dart';
import 'package:secondevaluation/Loader/loader.dart';
import 'package:secondevaluation/Screens/product_list.dart';
import 'package:secondevaluation/Screens/product_grid.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:secondevaluation/widgets/drawer.dart';
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
        drawer: SideDrawer(),
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
