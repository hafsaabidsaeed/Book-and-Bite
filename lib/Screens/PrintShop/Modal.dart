import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AwesomeModal extends StatelessWidget {
  var uid;
  var context;
  AwesomeModal({required this.context, required this.uid});
  final RxList<XFile> _selectedImages = <XFile>[].obs;
  final _storage = FirebaseStorage.instance;
  final _databaseReference = FirebaseDatabase.instance.reference();
  final GetVarsCtrl = Get.put(GetVars());
  DateTime now = DateTime.now();

  Future<void> pushDataToFirebase() async {
    List<String> imageUrls = await _uploadImages();
    String formattedDate = '${now.day}-${now.month}-${now.year}';
    final Map<String, dynamic> data = {
      'csName': "${GetVarsCtrl.currentUserName}",
      'time': "${GetVarsCtrl.currentTime}",
      'date': "${formattedDate}",
      'price': "${imageUrls.length}",
      "uID": GetVarsCtrl.auth.currentUser!.uid,
      "status": "accept",
      "item": "Documents",
      'images': imageUrls,
    };

    // final Map<String, dynamic> data = {
    //   'title': "${GetVarsCtrl.currentUserName}",
    //   'description': "printer shop data",
    //   'price': "printer",
    //   'images': imageUrls,
    //   "uID": GetVarsCtrl.auth.currentUser!.uid
    // };

    if (GetVarsCtrl.uID.isNotEmpty) {
      final DatabaseReference sellerRef =
          _databaseReference.child('Sellers').child(uid);
      await sellerRef
          .child('Orders')
          .child(GetVarsCtrl.currentUserName)
          .set(data);

      Get.back();
      GetVarsCtrl.scaffoldMsg(context, "Documents Sent Successfully");
    } else {
      print("Error: User ID is empty");
    }
  }

  Future _uploadImages() async {
    List<String> _selectedImageUrls = [];
    for (int i = 0; i < _selectedImages.length; i++) {
      final file = File(_selectedImages[i].path);
      final ref = _storage.ref().child('images/${DateTime.now()}_$i.jpg');
      await ref.putFile(file);
      var downloadURL = await ref.getDownloadURL();
      _selectedImageUrls.add(downloadURL);
    }
    return _selectedImageUrls;
  }

  void _openImagePicker() async {
    final List<XFile>? images =
        await ImagePicker().pickMultiImage(imageQuality: 50);
    if (images != null) {
      _selectedImages.addAll(images);
    }
  }

  void _deleteImage(int index) {
    _selectedImages.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Send Documents'),
      content: SingleChildScrollView(
        child: Obx(() => Column(
              children: [
                GestureDetector(
                    onTap: _openImagePicker,
                    child: Text(
                      'Choose Photos',
                      style: TextStyle(color: Colors.blue),
                    )),
                Container(
                  height: 110,
                  // color: Colors.red,
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: List.generate(
                        _selectedImages.length,
                        (index) => Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: Container(
                                margin: EdgeInsets.all(2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(_selectedImages[index].path),
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => _deleteImage(index),
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Submit'),
          onPressed: () {
            // Add your submit logic here
            pushDataToFirebase();
          },
        ),
      ],
    );
  }
}
