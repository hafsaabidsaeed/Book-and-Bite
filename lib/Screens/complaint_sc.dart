import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _complaintController = TextEditingController();

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<void> uploadAndSubmitComplaint() async {
    if (pickedFile == null) {
      // Handle the case where no file is selected
      return;
    }

    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download Link: $urlDownload');

    setState(() {
      uploadTask = null;
    });

    String name = _nameController.text;
    String shopName = _shopNameController.text;
    String complaint = _complaintController.text;

    await submitComplaint(name, shopName, complaint, urlDownload);

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Complaint submitted successfully!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Clear the form
    _formKey.currentState!.reset();
    _nameController.clear();
    _shopNameController.clear();
    _complaintController.clear();
    setState(() {
      pickedFile = null;
    });
  }

  Future<void> submitComplaint(
      String name, String shopName, String complaint, String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('complaints').add({
        'name': name,
        'shopName': shopName,
        'complaint': complaint,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      // Successfully submitted
      print('Complaint submitted successfully!');
    } catch (e) {
      // Handle errors
      print('Error submitting complaint: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complaint',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 140, 245, 241),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      // color: Colors.green,
                      width: screenWidth,
                      height: screenHeight * 0.04,
                      child: const Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                        width: screenWidth,
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            onTap: () {},
                            decoration: const InputDecoration(
                              hintText: 'Enter your name',
                              border: InputBorder.none,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    SizedBox(
                      // color: Colors.green,
                      width: screenWidth,
                      height: screenHeight * 0.04,
                      child: const Text(
                        'Shop name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                        width: screenWidth,
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _shopNameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            onTap: () {},
                            decoration: const InputDecoration(
                              hintText: 'Enter shop name',
                              border: InputBorder.none,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    SizedBox(
                      // color: Colors.green,
                      width: screenWidth,
                      height: screenHeight * 0.04,
                      child: const Text(
                        'Complaint',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                        width: screenWidth,
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _complaintController,
                            maxLines: 5,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.black,
                            onTap: () {},
                            decoration: const InputDecoration(
                              hintText: 'Your complaint . . . ',
                              border: InputBorder.none,
                            ),
                          ),
                        )),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    if (pickedFile != null)
                      Container(
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: FileImage(File(pickedFile!.path!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: selectFile,
                      child: const Text('Select File'),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: uploadAndSubmitComplaint,
                      child: const Text('Submit Complaint'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
