import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPrints extends StatelessWidget {
  final List<dynamic> list;

  ViewPrints({required this.list, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
              // Add functionality to view the file here
            },
          );
        },
      ),
    );
  }
}
