import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

get kPrimaryLightColor => const Color(0xFFF1E6FF);
get kPrimaryColor => const Color(0xFF6F35A5);
get accentColor => Color(0xff04d4ee);

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download Link:  $urlDownload');

    setState(() {
      uploadTask = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complaint',
          style: TextStyle(color: Color(0xFF6F35A5)),
        ),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
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
                            color: kPrimaryLightColor,
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
                            cursorColor: kPrimaryColor,
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
                            color: kPrimaryLightColor,
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
                            cursorColor: kPrimaryColor,
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
                            color: kPrimaryLightColor,
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
                            cursorColor: kPrimaryColor,
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
                        width: screenWidth * 0.8,
                        height: screenWidth * 0.8,
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String name = _nameController.text;
                          String shopName = _shopNameController.text;
                          String complaint = _complaintController.text;

                          if (pickedFile != null) {
                            await uploadFile();

                            _formKey.currentState!.reset();
                            _nameController.clear();
                            _shopNameController.clear();
                            _complaintController.clear();

                            setState(() {
                              pickedFile = null;
                            });

                            // Show snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Complaint submitted successfully!'),
                                duration: Duration(seconds: 2),
                              ),
                            );

                          } else {
                            print('Please select a file before submitting.');
                          }
                        }
                      },
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

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });
}
