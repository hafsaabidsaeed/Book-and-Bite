import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:secondevaluation/GetVars/all_sellers.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Screens/PrintShop/Modal.dart';
import 'package:secondevaluation/Screens/Seller_Sc/Getx/FetchMenu.dart';
import 'package:secondevaluation/Screens/Status_change.dart';
import 'package:get/get.dart';

class CustomerView extends StatelessWidget {
  CustomerView({super.key});
  final GetVarsCtrl = Get.put(MenuControllerData());
  final GetVarsCtrlMain = Get.put(GetVars());
  final allSellers = Get.put(AllSellers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: Get.height / 9,
          width: Get.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded)),
              Text(
                "COMSATS Printer Shops",
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
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                "All Printer Shops",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          child: Container(
              // color: Colors.red,
              height: Get.height / 1.2,
              child:
                  // mC.ordersCompleted.length != 0
                  //     ?
                  ListView.builder(
                      itemCount: allSellers.allPrinters.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key:
                              // Key(mC.ordersCompleted[index]["csName"].toString()),
                              Key("${allSellers.allPrinters[index]["shopName"].toString()}"),
                          direction: DismissDirection.none,
                          background: Container(
                            color: Colors.green,
                            child: Align(
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
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AwesomeModal(
                                          context: context,
                                          uid: allSellers.allPrinters[index]
                                              ["uID"]);
                                    },
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                leading: Icon(Icons.note_alt_outlined),
                                tileColor: Color.fromARGB(255, 216, 255, 254),
                                title: Text(
                                  "${allSellers.allPrinters[index]["shopName"].toString().toUpperCase()}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: Container(
                                  margin: EdgeInsets.all(10),
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(15)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "${allSellers.allPrinters[index]["shopImage"]}")),
                                  ),
                                )),
                          ),
                        );
                      })
              // : Container(
              //     margin: EdgeInsets.only(top: Get.height / 3.2),
              //     child: Column(
              //       children: [
              //         Icon(
              //           Icons.folder_copy_rounded,
              //           size: 50,
              //           color: Colors.grey,
              //         ),
              //         Text(
              //           "No Completed Orders",
              //           style: TextStyle(
              //               color: Colors.grey,
              //               fontWeight: FontWeight.w400,
              //               fontSize: 20),
              //         ),
              //       ],
              //     ),
              //   );
          
              ),
        ),
      ],
    ));
  }
}
