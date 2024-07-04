import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/shopItems.dart';
import 'package:secondevaluation/Screens/product_grid.dart';
import 'package:get/get.dart';

class ShopItems extends StatelessWidget {
  ShopItems({super.key});

  final specificSellerData = Get.put(ShopItemsClass());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Here is Hot Menu",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                child: SizedBox(
                  height: Get.height / 1.22,
                  width: Get.width,
                  // color: Colors.red,
                  child: ProductGrid(
                    itemList: specificSellerData.menuData,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
