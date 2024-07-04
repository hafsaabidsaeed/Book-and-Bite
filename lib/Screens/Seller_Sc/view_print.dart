import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for launching URLs

class ViewPrints extends StatelessWidget {
  final List<dynamic> list;

  ViewPrints({required this.list});

  void viewFile(String filePath) async {
    try {
      // Use a conditional statement to handle different file types
      if (filePath.endsWith('.pdf') || filePath.endsWith('.docx') || filePath.endsWith('.png') || filePath.endsWith('.jpg')) {
        // Open the file using the platform's default viewer (if supported)
        bool canLaunchFile = await canLaunch(filePath);
        if (canLaunchFile) {
          await launch(filePath);
        } else {
          // Handle error if the file cannot be launched
          Get.snackbar(
            'Error',
            'Could not open file. Please check if you have an app that supports this file type.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Handle other file types or unsupported types
        Get.snackbar(
          'Unsupported File',
          'This file type is not supported for viewing.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Print or log the error for debugging purposes
      print('Error opening file: $e');
      Get.snackbar(
        'Error',
        'Failed to open file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Prints'),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          String item = list[index];
          Widget fileIcon;
          if (item.endsWith('.pdf')) {
            fileIcon = Icon(Icons.picture_as_pdf);
          } else if (item.endsWith('.docx')) {
            fileIcon = Icon(Icons.library_books);
          } else if (item.endsWith('.png') || item.endsWith('.jpg')) {
            fileIcon = Icon(Icons.image);
          } else {
            // Default icon for unsupported file types
            fileIcon = Icon(Icons.insert_drive_file);
          }

          return ListTile(
            leading: fileIcon,
            title: Text('File ${index + 1}'),
            subtitle: Text('File path: $item'),
            onTap: () {
              // Call the method to view the file when tapped
              viewFile(item);
            },
          );
        },
      ),
    );
  }
}
