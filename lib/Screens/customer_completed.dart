import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:secondevaluation/GetVars/myOrders.dart';

import '../GetVars/initial.dart';
import '../Loader/loader.dart';

class CustomerCompltePage extends StatelessWidget {
  CustomerCompltePage({super.key});
  final GetVarsCtrl = Get.put(MyOrdersGx());
  final GetVarsCtrlMain = Get.put(GetVars());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder <GetVars> (
            builder: (GetVarsCtrlMain) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: Get.height / 9,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                              const Text(
                                "Order Status",
                                style: TextStyle(
                                    fontSize: 20,
                                    // color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),

                              IconButton(onPressed: (){
                                // GetVarsCtrlM.isLoadingChange(true);
                                GetVarsCtrl.onInit();
                                // GetVarsCtrlM.isLoadingChange(false);
                              }, icon: const Icon(Icons.replay_outlined) )

                            ],
                          ),
                        ),

                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text(
                                "Accepted and Pending Orders",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        // Displaying colors and their purposes
                        _buildStatusColor(const Color.fromARGB(255, 216, 255, 254), "Order Accepted", ),
                        _buildStatusColor(const Color.fromARGB(255, 221, 178, 247), "Order Completed",),
                        _buildStatusColor(const Color.fromARGB(255, 255, 180, 174), "Order Pending", ),


                        const SizedBox(
                          height: 10,
                        ),

                        Container(
                          // color: Colors.red,
                          height: Get.height / 1.2,
                          child: GetBuilder<MyOrdersGx>(builder: (mC) {
                            return mC.ordersData.length != 0
                                ? ListView.builder(
                                itemCount: mC.ordersData.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: Key(mC.ordersData[index]["csName"].toString()),
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
                                    onDismissed: (direction) {  },
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        leading: const Icon(Icons.person),
                                        tileColor: mC.ordersData[index]["status"] ==
                                            "accept"
                                            ? const Color.fromARGB(255, 216, 255, 254)
                                            : mC.ordersData[index]["status"] == "done"
                                            ? const Color.fromARGB(
                                            255, 221, 178, 247)
                                            :
                                        const Color.fromARGB(255, 255, 180, 174),
                                        title: Text(
                                          "${mC.ordersData[index]["item"].toString().toUpperCase()}",
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Time: ${mC.ordersData[index]["time"]}'),
                                            Text(
                                                'Amount: ${mC.ordersData[index]["price"]}'),
                                          ],
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                                height: 10,
                                                width: 10,
                                                child: Icon(
                                                  Icons.done_all,
                                                  color: Color.fromARGB(255, 46, 145, 142),
                                                )),
                                            const SizedBox(height: 20),
                                            Text('${mC.ordersData[index]["status"]}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                :  Container(
                              margin: EdgeInsets.only(top: Get.height / 3.2),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.folder_copy_rounded,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "No Orders",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                  GetVarsCtrlMain.isLoading? const LoaderCustom() : Container(),
                ],
              );
            }
          ),
        );
  }
  Widget _buildStatusColor(Color color, String status) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
