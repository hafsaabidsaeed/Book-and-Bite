import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Screens/Seller_Sc/Getx/FetchMenu.dart';
import 'package:get/get.dart';

class My_Menu_Sc extends StatelessWidget {
  My_Menu_Sc({super.key});

  // to fetch menu data added by seller
  final GetVarsCtrl = Get.put(MenuControllerData());

  final GetVarsCtrlMain = Get.put(GetVars());

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Menu",
                      style: TextStyle(
                          fontSize: 20,
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

        const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                "Menu in your Restaurant",
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
          return mC.menuData.isNotEmpty
              ? SizedBox(

                  height: Get.height / 1.2,
                  child: ListView.builder(
                      itemCount: mC.menuData.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(mC.menuData[index]["title"].toString()),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            color: Colors.red,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_forever,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      "Delete from Menu !",
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
                            await GetVarsCtrlMain.removeMenu(
                                GetVarsCtrl.menuData[index]["title"]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              leading: const Icon(Icons.person),
                              tileColor: const Color.fromARGB(255, 216, 255, 254),
                              title: Text(
                                mC.menuData[index]["title"].toString().toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Amount: ${GetVarsCtrl.menuData[index]["price"].toString()} PKR'),
                                  Text(
                                      'Decription: ${GetVarsCtrl.menuData[index]["description"]}'),
                                ],
                              ),
                              trailing: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(GetVarsCtrl
                                          .menuData[index]["images"][0])),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
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
                        "No Menu Items",
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 20),
                      ),
                    ],
                  ),
                );
        }),
      ],
    ));
  }
}
