import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondevaluation/Screens/PrintShop/Customer_View.dart';
import 'package:secondevaluation/Screens/complaint_sc.dart';
import 'package:secondevaluation/Screens/home_sc.dart';
import 'package:secondevaluation/widgets/drawer.dart';

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
          textAlign: TextAlign.center ,
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
                        child: _buildButton('Cafeteria' ,  screenWidth * 0.85, screenHeight * 0.2),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: _buildButton(
                            'Printing \n Shop', screenWidth * 0.42, screenHeight * 0.15),
                      ),
                      _buildButton(
                          'Complaints', screenWidth * 0.42, screenHeight * 0.15),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, double width, double height) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'Cafeteria') {
          Get.to(Home_Sc());
        } else if (text == 'Printing \n Shop') {
          Get.to(CustomerView());
        } else if (text == 'Complaints') {
          Get.to(ComplaintScreen());
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 109, 220, 217),
        shadowColor: Color.fromARGB(255, 140, 245, 241),
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, color: Colors.white),

      ),
    );
  }
}
