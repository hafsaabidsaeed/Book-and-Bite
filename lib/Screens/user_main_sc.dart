import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondevaluation/Screens/PrintShop/Customer_View.dart';
import 'package:secondevaluation/Screens/complaint_sc.dart';
import 'package:secondevaluation/Screens/home_sc.dart';
import 'package:secondevaluation/widgets/bottom_nav_bar/cafe_nav_bar.dart';
import 'package:secondevaluation/widgets/drawer.dart';

import '../widgets/discount_carousel.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 197, 193),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
        title: Text(
          'Book & Bite',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white ),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: SideDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: _buildButton('Cafeteria', screenWidth * 0.85, screenHeight * 0.2, 'assets/background/cafeteria.jpg'),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: _buildButton('Printing \n Shop', screenWidth * 0.42, screenHeight * 0.15, 'assets/background/printshop.jpg'),
                      ),
                      _buildButton('Complaints', screenWidth * 0.42, screenHeight * 0.15, 'assets/background/complaints.jpg'),
                    ],
                  ),
                ],
              ),
            ),
            DiscountCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, double width, double height, String imagePath) {
    return GestureDetector(
      onTap: () {
        if (text == 'Cafeteria') {
          // Get.to(CurvedNavigationBarExample());
          Get.to(Home_Sc());
        } else if (text == 'Printing \n Shop') {
          Get.to(CustomerView());
        } else if (text == 'Complaints') {
          Get.to(ComplaintScreen());
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              Text(
                  text,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.left,
                ),
            ],
          ),
        ),

      ),
    );
  }
}
