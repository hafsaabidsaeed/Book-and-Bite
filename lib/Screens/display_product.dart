import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Loader/loader.dart';
import 'cart/cart_page.dart';

List<Map<String, dynamic>> globalOrderList = [];
String? currentShopId; // Variable to store the current shop ID

class DisplayPage extends StatelessWidget {
  final List currentProduct;
  final GetVars GetVarsCtrl = Get.put(GetVars());

  DisplayPage({required this.currentProduct, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List images = currentProduct[0]["images"];
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Get.to(CartPage());
            },
          ),
        ],
      ),
      body: GetBuilder<GetVars>(builder: (gV) {
        return SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  CarouselSlider(
                    items: images.map((image) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        height: Get.height / 4,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(18.0),
                    height: Get.height / 1.9,
                    width: Get.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentProduct[0]["title"].toString().toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            currentProduct[0]["description"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'PKR ${currentProduct[0]["price"]}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 132, 221, 218),
                      ),
                      onPressed: () async {
                        GetVarsCtrl.loading(true);

                        String formattedDate = '${now.day}-${now.month}-${now.year}';
                        final _databaseReference = FirebaseDatabase.instance.ref();

                        // Check if the cart is empty or if the current product's shop ID matches the existing shop ID in the cart
                        if (globalOrderList.isEmpty || currentShopId == currentProduct[0]["uID"]) {
                          globalOrderList.add({
                            'name': currentProduct[0]["title"],
                            'price': currentProduct[0]["price"],
                            'image': currentProduct[0]["images"][0],
                            'quantity': 1,
                            'shopId': currentProduct[0]["uID"]
                          });
                          currentShopId = currentProduct[0]["uID"];

                          GetVarsCtrl.loading(false);

                          Get.snackbar(
                            'Success',
                            'Item added to cart ',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                            borderRadius: 10,
                          );
                        } else {
                          GetVarsCtrl.loading(false);

                          Get.snackbar(
                            'Error',
                            'You can only add items from the same shop',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 3),
                            borderRadius: 10,
                          );
                        }
                      },
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              gV.isLoad ? const LoaderCustom() : Container(),
            ],
          ),
        );
      }),
    );
  }
}
