import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secondevaluation/GetVars/all_sellers.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/GetVars/shopItems.dart';
import 'package:secondevaluation/Screens/shop_Items.dart';
import 'package:get/get.dart';

class ProductList extends StatelessWidget {
  // AllSellers
  final allSellersGet = Get.put(AllSellers());
  final getVarsGlobal = Get.put(GetVars());
  final getSpecificSellerCredsCtrl = Get.put(ShopItemsClass());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSellers>(builder: (allSellersGet) {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: allSellersGet.sellers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GetBuilder<GetVars>(builder: (gV) {
                  return GestureDetector(
                    onTap: () async {
                      allSellersGet.loadNew(true);

                      await getSpecificSellerCredsCtrl.getSpecificSellerCreds(
                          "${allSellersGet.sellers[index]["uID"]}");
                      Get.to(ShopItems());
                      allSellersGet.loadNew(false);
                    },
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[300], // Placeholder color
                      ),
                      // Replace the image URLs with network images
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          '${allSellersGet.sellers[index]["shopImage"]}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 8),
                Text(
                  '${allSellersGet.sellers[index]["shopName"].toString().toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
