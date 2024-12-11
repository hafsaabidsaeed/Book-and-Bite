import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/all_sellers.dart';
import 'package:secondevaluation/Screens/display_product.dart';
import 'package:get/get.dart';

class ProductGrid extends StatelessWidget {
  final allSellersData = Get.put(AllSellers());

  var itemList = [];

  ProductGrid({super.key, 
    required this.itemList,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllSellers>(builder: (allSellersData) {
      return GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: itemList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              var listHere = [];
              listHere.add(itemList[index]);
              print(" list forward $listHere");
              Get.to(DisplayPage(
                currentProduct: listHere,
              ));
            },
            child: Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              shadowColor: const Color.fromARGB(255, 195, 251, 249),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image:
                              NetworkImage("${itemList[index]["images"][0]}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemList[index]["title"].toString().toUpperCase(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(height: 4),
                        Text(
                          "PKR ${itemList[index]["price"]}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
