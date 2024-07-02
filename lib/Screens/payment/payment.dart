import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:secondevaluation/Screens/home_sc.dart';
import 'package:secondevaluation/Screens/payment/place_order_func.dart';

import '../display_product.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  File? _imageFile;
  bool _isUploading = false;
  String _selectedPaymentMethod = 'Easy Paisa'; // Default selected payment method

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImageAndPlaceOrder() async {
    if (_imageFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final fileName = path.basename(_imageFile!.path);
      final destination = 'payment_receipts/$fileName';

      final ref = FirebaseStorage.instance.ref(destination);
      final uploadTask = ref.putFile(_imageFile!);

      await uploadTask.whenComplete(() => null);
      final fileURL = await ref.getDownloadURL();

      print('File uploaded: $fileURL');

      OrderHelper orderHelper = OrderHelper();
      await orderHelper.placeOrder();

      // Clear the cart after placing the order
      setState(() {
        globalOrderList.clear();
      });

      Get.snackbar(
        'Payment Successful',
        'Payment has been sent successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back to the home screen after payment success
      Get.offAll(() => Home_Sc()); // Use Get.offAll to clear stack and navigate

    } catch (e) {
      print('Error uploading file: $e');
      Get.snackbar(
        'Upload Error',
        'Failed to upload payment receipt.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment Method'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RadioListTile<String>(
              title: Text('Easy Paisa'),
              value: 'Easy Paisa',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('JazzCash'),
              value: 'JazzCash',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Sada Pay'),
              value: 'Sada Pay',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            Column(
              children: [
                Text(
                  'Send Payment via $_selectedPaymentMethod',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      image: _imageFile != null
                          ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                          : DecorationImage(
                        image: AssetImage('assets/images/avatar_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: _imageFile == null
                        ? Icon(
                      Icons.add_a_photo,
                      size: 30,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadImageAndPlaceOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isUploading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
