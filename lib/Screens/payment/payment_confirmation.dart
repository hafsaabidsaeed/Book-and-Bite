import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class PaymentConfirmationScreen extends StatefulWidget {
  final String paymentMethod;

  const PaymentConfirmationScreen({required this.paymentMethod});

  @override
  _PaymentConfirmationScreenState createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  File? _imageFile; // File variable to store the selected image
  bool _isUploading = false; // Boolean to track the uploading state

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Store the picked image file
      });
    }
  }

  // Function to upload the selected image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_imageFile == null) return; // If no image is selected, return

    setState(() {
      _isUploading = true; // Set uploading state to true
    });

    try {
      final fileName = path.basename(_imageFile!.path); // Get the file name
      final destination = 'payment_receipts/$fileName'; // Set the upload path

      final ref = FirebaseStorage.instance.ref(destination); // Reference to the storage location
      final uploadTask = ref.putFile(_imageFile!); // Start the upload

      await uploadTask.whenComplete(() => null); // Wait for the upload to complete
      final fileURL = await ref.getDownloadURL(); // Get the download URL of the uploaded file

      // Print the file URL (can be used for further processing)
      print('File uploaded: $fileURL');

      // Show success message using Get.snackbar
      Get.snackbar(
        'Payment Successful',
        'Payment has been sent successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Print the error message
      print('Error uploading file: $e');

      // Show error message using Get.snackbar
      Get.snackbar(
        'Upload Error',
        'Failed to upload payment receipt.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isUploading = false; // Set uploading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Send Payment via ${widget.paymentMethod}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: _pickImage, // Call _pickImage when the container is tapped
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
                  : const DecorationImage(
                image: AssetImage('assets/images/avatar_placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: _imageFile == null
                ? const Icon(
              Icons.add_a_photo,
              size: 30,
              color: Colors.white,
            )
                : null,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isUploading ? null : _uploadImage, // Call _uploadImage if not uploading
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isUploading
              ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
              : const Text(
            'Send Payment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
