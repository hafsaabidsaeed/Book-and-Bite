import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:get/get.dart';

class AwesomeModal extends StatelessWidget {
  var uid;
  var context;
  AwesomeModal({required this.context, required this.uid});
  final RxList<XFile> _selectedDocuments = <XFile>[].obs;
  final _storage = FirebaseStorage.instance;
  final _databaseReference = FirebaseDatabase.instance.reference();
  final GetVarsCtrl = Get.put(GetVars());
  DateTime now = DateTime.now();


  Future<void> pushDataToFirebase(BuildContext context) async {

    // Close the AlertDialog
    Navigator.of(context).pop();

    GetVarsCtrl.isLoadingChange(true);

    List<String> documentUrls = await _uploadDocuments();
    String formattedDate = '${now.day}-${now.month}-${now.year}';
    final Map<String, dynamic> data = {
      'csName': "${GetVarsCtrl.currentUserName}",
      'time': "${GetVarsCtrl.currentTime}",
      'date': "${formattedDate}",
      'documentCount': "${documentUrls.length}",
      "uID": GetVarsCtrl.auth.currentUser!.uid,
      "status": "accept",
      "item": "Documents",
      'documentUrls': documentUrls,
    };

    if (GetVarsCtrl.uID.isNotEmpty) {
      final DatabaseReference sellerRef =
      _databaseReference.child('Sellers').child(uid);
      await sellerRef
          .child('Orders')
          .child(GetVarsCtrl.currentUserName)
          .set(data);

      Get.back();
      // GetVarsCtrl.scaffoldMsg(context, "Documents Sent Successfully");
    } else {
      if (kDebugMode) {
        print("Error: User ID is empty");
      }
    }

    GetVarsCtrl.isLoadingChange(false);
    Get.snackbar(
      'Success', // Title of the SnackBar
      'File sent successful', // Message of the SnackBar
      colorText: Colors.white,
      backgroundColor: Colors.green, // Background color of the SnackBar
      snackPosition: SnackPosition.TOP, // Position of the SnackBar
    );
  }

  Future<List<String>> _uploadDocuments() async {
    List<String> _selectedDocumentUrls = [];
    for (int i = 0; i < _selectedDocuments.length; i++) {
      final file = File(_selectedDocuments[i].path);
      final ref = _storage.ref().child('documents/${DateTime.now()}_$i');
      await ref.putFile(file);
      var downloadURL = await ref.getDownloadURL();
      _selectedDocumentUrls.add(downloadURL);
    }
    return _selectedDocumentUrls;
  }

  void _openDocumentPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'png', 'jpg'],
    );

    if (result != null) {
      for (PlatformFile file in result.files) {
        _selectedDocuments.add(XFile(file.path!));
      }
    }
  }

  void _deleteDocument(int index) {
    _selectedDocuments.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select File'),

      content: SingleChildScrollView(
        child: Obx(() => Column(
          children: [
            Text("You can select PDF / WORD / JPG Or PNG files", style: TextStyle(fontSize: 12),),
            GestureDetector(
                onTap: _openDocumentPicker,
                child: const Text(
                  'Choose File',
                  style: TextStyle(color: Colors.blue),
                )),
            SizedBox(
              height: 110,
              child: SingleChildScrollView(
                child: Wrap(
                  children: List.generate(
                    _selectedDocuments.length,
                        (index) => Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            margin: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ListTile(
                                leading: const Icon(Icons.insert_drive_file),
                                title: Text(
                                  _selectedDocuments[index].name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _deleteDocument(index),
                            child: const Icon(
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
          child: const Text('Submit'),
          onPressed: () => pushDataToFirebase(context),
        ),

      ],
    );
  }
}
