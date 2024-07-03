import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final Map<String, dynamic> userData;

  const OrderDetailsScreen({
    required this.orderData,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text('Customer Name: ${userData['csName']}'),
          ),
          ListTile(
            title: Text('Date: ${orderData['date']}'),
          ),
          ListTile(
            title: Text('Price: ${orderData['price']}'),
          ),
          // Add more details as needed
        ],
      ),
    );
  }
}
