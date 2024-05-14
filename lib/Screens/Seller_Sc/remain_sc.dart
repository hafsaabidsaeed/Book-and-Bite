import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Screens/Seller_Sc/Getx/FetchMenu.dart';
import 'package:secondevaluation/Screens/Seller_Sc/view_print.dart';
import 'package:secondevaluation/Screens/Status_change.dart';
import 'package:get/get.dart';
import 'package:flutter_image/flutter_image.dart' as flutter_image;

class Remain_Sc extends StatelessWidget {
  Remain_Sc({super.key});
  final GetVarsCtrl = Get.put(MenuControllerData());
  final GetVarsCtrlMain = Get.put(GetVars());
  final ChangeStatusVar = Get.put(ChangeStatus());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: Get.height / 9,
          width: Get.width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
              SizedBox(
                width: Get.width / 1.2,
                // color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Remaining Orders",
                      style: TextStyle(
                          fontSize: 20,
                          // color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          GetVarsCtrl.onInit();
                        },
                        icon: const Icon(Icons.replay_outlined))
                  ],
                ),
              )
            ],
          ),
        ),
        // SizedBox(
        //   height: 05,
        // ),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                "Your these customers are waiting ...",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        GetBuilder<MenuControllerData>(builder: (mC) {
          return SizedBox(
            // color: Colors.red,
            height: Get.height / 1.2,
            child: mC.ordersData.isNotEmpty
                ? ListView.builder(
                    itemCount: mC.ordersData.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Stack(
                          children: [
                            Dismissible(
                              key: Key(
                                  mC.ordersData[index]["csName"].toString()),
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                color: Colors.green,
                                child: const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      children: [
                                        Icon(Icons.done_all,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                          "Order Completed !",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onDismissed: (direction) async {
                                // Implement delete functionality here


                                if (GetVarsCtrl.isRestaurant) {
                                  await ChangeStatusVar.changeStatus(
                                      cmUserID:
                                          "${mC.ordersData[index]["uID"]}",
                                      productName:
                                          "${mC.ordersData[index]["item"]}",
                                      val: "done");
                                } else {
                                  await ChangeStatusVar.chnagePrintStatus(
                                      sellerName:
                                          "${mC.ordersData[index]["csName"]}",
                                      val: "done");
                                }

                                // GetVarsCtrl.onInit();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    leading: const Icon(Icons.person),
                                    tileColor:
                                        const Color.fromARGB(255, 216, 255, 254),
                                    title: Text(
                                      mC.ordersData[index]["csName"].toString().toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Time: ${mC.ordersData[index]["time"]}'),
                                        Text(
                                            'Date: ${mC.ordersData[index]["date"]}'),
                                        Text(GetVarsCtrl.isRestaurant
                                            ? 'Amount: ${mC.ordersData[index]["price"]}'
                                            : "Total prints: ${mC.ordersData[index]["price"]}"),
                                        Text(GetVarsCtrl.isRestaurant
                                            ? 'Food: ${mC.ordersData[index]["item"]}'
                                            : "Order Type: ${mC.ordersData[index]["item"]}"),
                                      ],
                                    ),
                                    trailing: GetBuilder<MenuControllerData>(
                                        builder: (mC) {
                                      return GetVarsCtrl.isRestaurant
                                          ? CupertinoSwitch(
                                              activeColor: const Color.fromARGB(
                                                  255, 46, 145, 142),
                                              onChanged: (val) async {
                                                if (kDebugMode) {
                                                  print(
                                                    "${mC.ordersData[index]["uID"]}");
                                                }
                                                await ChangeStatusVar.changeStatus(
                                                    cmUserID:
                                                        "${mC.ordersData[index]["uID"]}",
                                                    productName:
                                                        "${mC.ordersData[index]["item"]}",
                                                    val: val
                                                        ? "accept"
                                                        : "pending");

                                                GetVarsCtrl.onInit();
                                              },
                                              value: mC.ordersData[index]
                                                          ["status"] ==
                                                      "pending"
                                                  ? false
                                                  : true,
                                            )
                                          : IconButton(
                                              onPressed: () async {
                                                List myList = [];
                                                myList.clear();
                                                myList.addAll(mC
                                                    .ordersData[index]["images"]
                                                    .toList());

                                                if (kDebugMode) {
                                                  print(myList);
                                                }
                                                Get.to(ViewPrints(
                                                  list: myList,
                                                ));

                                                // await downloadImages(
                                                //     myList, context);
                                              },
                                              icon: const Icon(
                                                Icons.photo_album,
                                                size: 35,
                                              ));
                                    })),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                : Container(
                    margin: EdgeInsets.only(top: Get.height / 3.2),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.folder_copy_rounded,
                          size: 50,
                          color: Colors.grey,
                        ),
                        Text(
                          "No Remaining Orders",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
          );
        }),
      ],
    ));
  }
}
