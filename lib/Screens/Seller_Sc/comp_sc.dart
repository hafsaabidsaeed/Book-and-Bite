import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Screens/Seller_Sc/Getx/FetchMenu.dart';
import 'package:secondevaluation/Screens/Status_change.dart';
import 'package:get/get.dart';

class Comp_Sc extends StatelessWidget {
  Comp_Sc({super.key});
  //to fetch menu
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
              const Text(
                "Completed Orders",
                style: TextStyle(
                    fontSize: 20,
                    // color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        // SizedBox(
        //   height: 10,
        // ),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                "History of Completed Orders",
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
        SizedBox(
          // color: Colors.red,
          height: Get.height / 1.2,
          child: GetBuilder<MenuControllerData>(builder: (mC) {
            return mC.ordersCompleted.isNotEmpty
                ? ListView.builder(
                    itemCount: mC.ordersCompleted.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key:
                            Key(mC.ordersCompleted[index]["csName"].toString()),
                        direction: DismissDirection.none,
                        background: Container(
                          color: Colors.green,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Icon(Icons.done_all, color: Colors.white),
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
                        onDismissed: (direction) {
                          // Implement delete functionality here
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            leading: const Icon(Icons.person),
                            tileColor: const Color.fromARGB(255, 216, 255, 254),
                            title: Text(
                              mC.ordersCompleted[index]["csName"].toString().toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Time: ${mC.ordersCompleted[index]["time"]}'),
                                Text(
                                    'Date: ${mC.ordersCompleted[index]["date"]}'),
                                Text(GetVarsCtrl.isRestaurant
                                    ? 'Amount: ${mC.ordersCompleted[index]["price"]}'
                                    : "Total prints: ${mC.ordersCompleted[index]["price"]}"),
                                Text(GetVarsCtrl.isRestaurant
                                    ? 'Food: ${mC.ordersCompleted[index]["item"]}'
                                    : "Order Type: ${mC.ordersCompleted[index]["item"]}"),
                              ],
                            ),
                            trailing: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: Icon(
                                      Icons.done_all,
                                      color: Color.fromARGB(255, 46, 145, 142),
                                    )),
                                SizedBox(height: 20),
                                Text("Done Order")
                              ],
                            ),
                          ),
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
                          "No Completed Orders",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  );
          }),
        ),
      ],
    ));
  }
}
