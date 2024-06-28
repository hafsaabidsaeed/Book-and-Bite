// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:secondevaluation/Screens/customer_completed.dart';
// import 'package:secondevaluation/widgets/drawer.dart';
//
// import '../../Screens/PrintShop/Customer_View.dart';
// import '../../Screens/cart/cart_page.dart';
// import '../../Screens/home_sc.dart';
//
// class CurvedNavigationBarExample extends StatelessWidget {
//   CurvedNavigationBarExample({Key? key}) : super(key: key);
//
//   final NavigationController navController = Get.put(NavigationController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.black),
//         elevation: 0.0,
//         title: const Text(
//           'Cafeteria',
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.help_outline),
//           ),
//         ],
//       ),
//       drawer: SideDrawer(),
//       body: Obx(() {
//         return IndexedStack(
//           index: navController.currentIndex.value,
//           children: [
//             Home_Sc(),
//             CustomerCompltePage(),
//             CartPage(),
//           ],
//         );
//       }),
//       bottomNavigationBar: Obx(() {
//         return CurvedNavigationBar(
//           items: const [
//             Icon(Icons.home, color: Colors.white),
//             Icon(Icons.note_alt_outlined, color: Colors.white),
//             Icon(Icons.shopping_cart, color: Colors.white),
//           ],
//           backgroundColor: Colors.white,
//           color: Color.fromARGB(255, 76, 197, 193),
//           buttonBackgroundColor: Color.fromARGB(255, 76, 197, 193),
//           animationDuration: const Duration(milliseconds: 300),
//           height: 55.0,
//           onTap: (index) {
//             navController.updateIndex(index);
//           },
//         );
//       }),
//     );
//   }
// }
//
//
//
// class NavigationController extends GetxController {
//   var currentIndex = 0.obs;
//
//   void updateIndex(int index) {
//     currentIndex.value = index;
//   }
// }
