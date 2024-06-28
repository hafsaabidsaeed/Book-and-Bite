// //this is home screen (navbar wale) of fast food section
//
// import 'package:flutter/material.dart';
// import 'package:secondevaluation/Screens/home_sc.dart';
//
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
//         useMaterial3: true,
//       ),
//       home: const fastFoodHomeScreen(),
//     );
//   }
// }
//
// // ignore: camel_case_types
// class fastFoodHomeScreen extends StatefulWidget {
//   const fastFoodHomeScreen({super.key});
//
//   @override
//   State<fastFoodHomeScreen> createState() => _fastFoodHomeScreenState();
// }
//
// // ignore: camel_case_types
// class _fastFoodHomeScreenState extends State<fastFoodHomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       body: Container(
//         color: Colors.white,
//         child: const Column(
//           children: [
//             Expanded(
//               child: Home_Sc(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
