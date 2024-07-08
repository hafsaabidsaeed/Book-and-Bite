import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Loader/loader.dart';
import 'package:secondevaluation/Screens/Seller_Sc/Getx/FetchMenu.dart';
import 'package:secondevaluation/Screens/Seller_Sc/comp_sc.dart';
import 'package:secondevaluation/Screens/Seller_Sc/my_menu_sc.dart';
import 'package:secondevaluation/Screens/Seller_Sc/remain_sc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Home_Seller_Sc extends StatelessWidget {
  Home_Seller_Sc({super.key});
  final GetVarsCtrl = Get.put(GetVars());
  final GetVarsCtrlMenu = Get.put(MenuControllerData());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final RxList<XFile> _selectedImages = <XFile>[].obs;
  final _storage = FirebaseStorage.instance;
  final _databaseReference = FirebaseDatabase.instance.ref();

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

// Modify pushDataToFirebase to return a boolean indicating success or failure
  Future<bool> pushDataToFirebase(BuildContext context) async {
    // Check if any field is empty
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty || _selectedImages.isEmpty) {
      Get.snackbar(
        'Missing field', // Title of the SnackBar
        'Please fill all the fields', // Message of the SnackBar
        colorText: Colors.white,
        backgroundColor: Colors.red, // Background color of the SnackBar
        snackPosition: SnackPosition.TOP, // Position of the SnackBar
      );
      return false; // Return false indicating failure
    }

    // Continue with uploading data to Firebase
    List<String> imageUrls = await _uploadImages();

    final Map<String, dynamic> data = {
      'title': _nameController.text,
      'description': _descriptionController.text,
      'price': _priceController.text,
      'images': imageUrls,
      "uID": GetVarsCtrl.auth.currentUser!.uid
    };

    if (GetVarsCtrl.uID.isNotEmpty) {
      final DatabaseReference sellerRef =
      _databaseReference.child('Sellers').child(GetVarsCtrl.uID);
      await sellerRef.child('menus').child(_nameController.text).set(data);
      return true; // Return true indicating success
    } else {
      print("Error: User ID is empty");
      return false; // Return false indicating failure
    }
  }

  void sendDataToFirebase(BuildContext context) async {
    // Call pushDataToFirebase to upload data to Firebase
    await pushDataToFirebase(context);

    // Check if data was successfully sent to Firebase
    // You can implement this logic inside pushDataToFirebase to return a boolean indicating success or failure
    bool dataSentSuccessfully = true; // Set this to true if data is sent successfully, false otherwise

    if (dataSentSuccessfully) {
      // Show a Snackbar if data is sent successfully
      Get.snackbar(
        'Success',
        'Item added to Menu successfully',
        backgroundColor: Colors.green, // Background color of the SnackBar
        snackPosition: SnackPosition.TOP, // Position of the SnackBar
      );


      // Clear text input fields
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _selectedImages.clear();

      // Dismiss the bottom sheet
      Navigator.pop(context);
    }
  }

  void addMenuButtonPressed(BuildContext context) async {
    // Call pushDataToFirebase and wait for its result
    bool success = await pushDataToFirebase(context);

    // If pushDataToFirebase returns true, call sendDataToFirebase
    if (success) {
      sendDataToFirebase(context);
    }
  }



  void _openImagePicker() async {
    final List<XFile> images =
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
    GetVarsCtrl.onInit();
    return Scaffold(
      body: GetBuilder<GetVars>(builder: (gV) {
        return Stack(
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              color: const Color.fromARGB(255, 240, 240, 240),
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  children: [
                    Container(
                      height: Get.height / 4,
                      width: Get.width,
                      padding: const EdgeInsets.all(25),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              colors: [
                                Color.fromARGB(255, 140, 245, 241),
                                Color.fromARGB(255, 109, 220, 217),
                                Color.fromARGB(255, 76, 197, 193)
                              ]),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(100),
                              bottomLeft: Radius.circular(100))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Warm Welcome Today",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 87, 87, 87),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Obx(
                                () => Text(
                                  'Time: ${GetVarsCtrl.currentTime.value}',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 87, 87, 87),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Text(
                                gV.currentTimeStatus,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 87, 87, 87),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                GetVarsCtrl.sellerData["shopName"] != null
                                    ? "${GetVarsCtrl.sellerData["shopName"]}"
                                    : "Loading ...",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 87, 87, 87),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 20.0),
                              height: Get.height / 7,
                              width: Get.height / 7,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 229, 229, 229),
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child:
                                    GetVarsCtrl.sellerData["shopImage"] != null
                                        ? Image(
                                            image: NetworkImage(
                                                "${GetVarsCtrl.sellerData["shopImage"]}"),
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(
                                            Icons.image_outlined,
                                            color: Colors.grey,
                                            size: 35,
                                          ),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 70),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Orders Summary",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 81, 81, 81)),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              btnContainer(
                                  txt: "Compeleted",
                                  icon: const Icon(
                                    Icons.done_all_sharp,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                  onTap: () {
                                    Get.to(Comp_Sc());
                                  }),
                              btnContainer(
                                  txt: "Remaining",
                                  icon: const Icon(
                                    Icons.timelapse_sharp,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                  onTap: () {
                                    Get.to(Remain_Sc());
                                  })
                            ],
                          ),
                          GetVarsCtrlMenu.isRestaurant
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    btnContainer(
                                        txt: "Add Menu",
                                        icon: const Icon(
                                          Icons.add_business_outlined,
                                          size: 40,
                                          color: Colors.blue,
                                        ),
                                        onTap: () {
                                          Get.bottomSheet(
                                            Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10))),
                                              height: Get.height / 1,
                                              padding: const EdgeInsets.all(16),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CupertinoTextField(
                                                      controller:
                                                          _nameController,
                                                      placeholder: 'Name',
                                                    ),
                                                    CupertinoTextField(
                                                      controller:
                                                          _priceController,
                                                      placeholder: 'Price',
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                    CupertinoTextField(
                                                      minLines: 05,
                                                      controller:
                                                          _descriptionController,
                                                      placeholder:
                                                          'Food Description',
                                                      maxLines: null,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                            onTap:
                                                                _openImagePicker,
                                                            child: const Text(
                                                              'Choose Photos',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            )),
                                                      ],
                                                    ),
                                                    Obx(() => SizedBox(
                                                          height: 110,
                                                          // color: Colors.red,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Wrap(
                                                              children:
                                                                  List.generate(
                                                                _selectedImages
                                                                    .length,
                                                                (index) =>
                                                                    Stack(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                      child:
                                                                          Container(
                                                                        margin: const EdgeInsets
                                                                            .all(
                                                                            2.0),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              Image.file(
                                                                            File(_selectedImages[index].path),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                            width:
                                                                                50,
                                                                            height:
                                                                                50,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 0,
                                                                      right: 0,
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap: () =>
                                                                            _deleteImage(index),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .cancel,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                    const SizedBox(height: 20),
                                                    FadeInUp(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1600),
                                                        child: MaterialButton(
                                                          onPressed: () {

                                                            // pushDataToFirebase(context);


                                                            addMenuButtonPressed(context);

                                                          },
                                                          height: 50,
                                                          // margin: EdgeInsets.symmetric(horizontal: 50),
                                                          color: const Color.fromARGB(255, 76,197, 193),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(50),
                                                          ),
                                                          // decoration: BoxDecoration(
                                                          // ),
                                                          child: const Center(
                                                            child: Text(
                                                              "Add Menu",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                            elevation: 10,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                          );
                                        }),
                                    btnContainer(
                                        txt: "My Menu",
                                        icon: const Icon(
                                          Icons.menu_open_rounded,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                        onTap: () {
                                          Get.to(My_Menu_Sc());
                                        })
                                  ],
                                )
                              : Container(),
                          const SizedBox(height: 20),
                          ElevatedButton(
                              onPressed: () {
                                GetVarsCtrl.auth.signOut();
                              },
                              child: const Text("Logout"))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GetBuilder<GetVars>(builder: (gV) {
              if (kDebugMode) {
                print("${gV.sellerData["sellerImage"]} check check ****");
              }
              return gV.sellerData["sellerImage"].toString().isEmpty
                  ? const LoaderCustom()
                  : Container();
            })
          ],
        );
      }),
    );
  }
}

class btnContainer extends StatelessWidget {
  btnContainer({
    required this.onTap,
    required this.icon,
    required this.txt,
    super.key,
  });
  var onTap;
  var icon;
  var txt;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.all(5.0),
              height: Get.height / 7,
              width: Get.height / 7,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 225, 225, 225),
                borderRadius: BorderRadius.circular(20),
              ),
              child: icon),
          Text(txt)
        ],
      ),
    );
  }
}
