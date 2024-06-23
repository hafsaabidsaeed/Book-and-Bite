import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../display_product.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Loader/loader.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GetVars GetVarsCtrl = Get.put(GetVars());

  void _incrementQuantity(int index) {
    setState(() {
      globalOrderList[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (globalOrderList[index]['quantity'] > 1) {
        globalOrderList[index]['quantity']--;
      }
    });
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    for (var order in globalOrderList) {
      total += double.parse(order['price']) * order['quantity'];
    }
    return total;
  }

  void _placeOrder() async {
    DateTime now = DateTime.now();
    String formattedDate = '${now.day}-${now.month}-${now.year}';
    final _databaseReference = FirebaseDatabase.instance.reference();

    for (var order in globalOrderList) {
      final Map<String, dynamic> data = {
        'csName': "${GetVarsCtrl.currentUserName}",
        'time': "${GetVarsCtrl.currentTime}",
        'date': "${formattedDate}",
        'price': "${order['price']}",
        "uID": GetVarsCtrl.auth.currentUser!.uid,
        "status": "pending",
        "item": "${order['name']}"
      };

      final Map<String, dynamic> userPersonalData = {
        'csName': "${GetVarsCtrl.currentUserName}",
        'time': "${GetVarsCtrl.currentTime}",
        'date': "${formattedDate}",
        'price': "${order['price']}",
        "uID": GetVarsCtrl.auth.currentUser!.uid,
        "status": "pending",
        "item": "${order['name']}"
      };

      final DatabaseReference sellerRef =
      _databaseReference.child('Sellers').child(GetVarsCtrl.auth.currentUser!.uid);
      await sellerRef
          .child('Orders')
          .child("${order['name'] + GetVarsCtrl.auth.currentUser!.uid}")
          .set(data);

      final _databaseReferencePersonal = FirebaseDatabase.instance.reference();
      final DatabaseReference sellerRefPersonal = _databaseReferencePersonal
          .child('Sellers')
          .child(GetVarsCtrl.auth.currentUser!.uid);
      await sellerRefPersonal
          .child('Orders')
          .child("${order['name'] + GetVarsCtrl.auth.currentUser!.uid}")
          .set(userPersonalData);
    }

    setState(() {
      globalOrderList.clear();
      currentShopId = null; // Clear the current shop ID after placing the order
    });

    Get.snackbar(
      'Success',
      'Order placed successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      borderRadius: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = _calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: globalOrderList.isEmpty
                ? Center(child: Text('Your cart is empty'))
                : ListView.builder(
              itemCount: globalOrderList.length,
              itemBuilder: (context, index) {
                final order = globalOrderList[index];
                final int quantity = order['quantity'];
                final double price = double.parse(order['price']);
                final double itemTotalPrice = price * quantity;

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(order['image']),
                    title: Text(order['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('PKR $itemTotalPrice'),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _decrementQuantity(index),
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _incrementQuantity(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Total: PKR $totalPrice',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text('Order Now'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
