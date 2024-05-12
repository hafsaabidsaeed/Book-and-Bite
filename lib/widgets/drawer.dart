import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetVars/initial.dart';
import '../Screens/PrintShop/Customer_View.dart';
import '../Screens/about_us.dart';
import '../Screens/complaint_sc.dart';
import '../Screens/customer_completed.dart';
import '../Screens/settings.dart';

class SideDrawer extends StatelessWidget {
  final GetVarsCtrl = Get.put(GetVars());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 76, 197, 193),
            ),
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'COMSATS \n Book & Bite',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Printing Shop'),
            onTap: () {
              Get.to(CustomerView());
            },
          ),
          ListTile(
            leading: const Icon(Icons.note_alt_outlined),
            title: const Text('Order Status'),
            onTap: () {
              Get.to(CustomerCompltePage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.notes),
            title: const Text('Complaints'),
            onTap: () {
              Get.to(const ComplaintScreen());
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Get.to(SettingsScreen());
            },
          ),
          ListTile(
            title: const Text('About Us'),
            onTap: () {
              Get.to(const AboutUsScreen());
            },
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          ElevatedButton(
            onPressed: () async {
              GetVarsCtrl.loading(true); // Shows loader before signout
              try {
                await GetVarsCtrl.auth.signOut(); // Sign out operation
              } catch (e) {
                print('Error signing out: $e');
              } finally {
                GetVarsCtrl.loading(false); // Hides loader
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
