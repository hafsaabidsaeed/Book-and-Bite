import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Loader/loader.dart';
import 'package:get/get.dart';

class DisplayPage extends StatelessWidget {
  var currentProduct = [];
  final GetVarsCtrl = Get.put(GetVars());

  DateTime now = DateTime.now();

  DisplayPage({required this.currentProduct, super.key});

  @override
  Widget build(BuildContext context) {
    // print("hie");
    List images = [];
    images.addAll(currentProduct[0]["images"]);
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<GetVars>(builder: (gV) {
        return SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    // Text("${currentProduct[0]["title"]}"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CarouselSlider(
                          items: images.map((image) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              height: Get.height / 04,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${currentProduct[0]["title"].toString().toUpperCase()}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  ' ${currentProduct[0]["description"]}',
                                  // currentProduct[0]["uID"]
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'PKR ${currentProduct[0]["price"]}',
                                  // textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color.fromARGB(255, 132, 221, 218)),
                            onPressed: () async {
                              GetVarsCtrl.loading(true);
                              String formattedDate =
                                  '${now.day}-${now.month}-${now.year}';
                              final _databaseReference =
                              FirebaseDatabase.instance.reference();

                              final Map<String, dynamic> data = {
                                'csName': "${GetVarsCtrl.currentUserName}",
                                'time': "${GetVarsCtrl.currentTime}",
                                'date': "${formattedDate}",
                                'price': "${currentProduct[0]["price"]}",
                                "uID": GetVarsCtrl.auth.currentUser!.uid,
                                "status": "pending",
                                "item": "${currentProduct[0]["title"]}"
                              };

                              final Map<String, dynamic> userPersonalData = {
                                'csName': "${GetVarsCtrl.currentUserName}",
                                'time': "${GetVarsCtrl.currentTime}",
                                'date': "${formattedDate}",
                                'price': "${currentProduct[0]["price"]}",
                                "uID": currentProduct[0]["uID"],
                                "status": "pending",
                                "item": "${currentProduct[0]["title"]}"
                              };

                              final DatabaseReference sellerRef =
                              _databaseReference
                                  .child('Sellers')
                                  .child(currentProduct[0]["uID"]);
                              await sellerRef
                                  .child('Orders')
                                  .child(
                                  "${currentProduct[0]["title"] + GetVarsCtrl.auth.currentUser!.uid}")
                                  .set(data);

                              final _databaseReferencePersonal =
                              FirebaseDatabase.instance.reference();
                              final DatabaseReference sellerRefPersonal =
                              _databaseReferencePersonal
                                  .child('Sellers')
                                  .child(GetVarsCtrl.auth.currentUser!.uid);
                              await sellerRefPersonal
                                  .child('Orders')
                                  .child(
                                  "${currentProduct[0]["title"] + GetVarsCtrl.auth.currentUser!.uid}")
                                  .set(userPersonalData);

                              GetVarsCtrl.loading(false);
                              Get.back();

                            // Show Snackbar using GetX
                              Get.snackbar(
                                'Success', // Title
                                'Order placed successfully!', // Message
                                snackPosition: SnackPosition.TOP, // Position of the SnackBar
                                backgroundColor: Colors.green, // Background color of the SnackBar
                                colorText: Colors.white, // Text color of the SnackBar
                                duration: Duration(seconds: 3), // Duration for which the snackbar is visible
                                borderRadius: 10, // BorderRadius for the snackbar
                              );
                            },
                            child: const Text(
                              'Order Now',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              gV.isLoad == true ? const LoaderCustom() : Container()
            ],
          ),
        );
        // : LoaderCustom();
      }),
    );
  }
}
