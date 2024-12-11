import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Loader/loader.dart';
import 'package:secondevaluation/Screens/Seller_Sc/home_seller_sc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:secondevaluation/Screens/user_main_sc.dart';

class LoginPage extends StatelessWidget {
  String? heading;
  String? title;
  String? btnText;
  String? tagLine;
  String? tagLineRoute;
  var onCall;

  LoginPage({super.key, 
    required this.heading,
    required this.title,
    required this.btnText,
    required this.tagLine,
    required this.tagLineRoute,
    required this.onCall,
  });

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _shopName = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final FirebaseAuth g  = FirebaseAuth.instance;
  final GetVarsCtrl = Get.put(GetVars());
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString imageUrl = RxString('');
  final RxString shopType = 'restaurant'.obs;


  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  //data being pushed to firebase
  void pushDataToDatabase(
    String uid,
    String shopName,
    String shopImg,
    String userName,
  ) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    databaseReference.child('Sellers').child(uid).set({
      'shopName': shopName,
      'shopType': GetVarsCtrl.isSeller ? shopType.value : "",
      'shopImage': shopImg,
      'userName': userName,
      'uID': uid
    }).then((_) {
      // print('Data pushed to database successfully');
    }).catchError((error) {
      // print('Failed to push data to database: $error');
    });
  }

  //register
  void _register(context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || !isValidEmail(email)) {
      GetVarsCtrl.scaffoldMsg(context, "Please enter a valid email");
      GetVarsCtrl.isLoadingChange(false);
      return;
    }

    if (password.isEmpty) {
      GetVarsCtrl.scaffoldMsg(context, "Please enter your password");
      GetVarsCtrl.isLoadingChange(false);
      return;
    }

    try {
      UserCredential userCredential =
          await GetVarsCtrl.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _uploadImageToFirebaseStorage();
      pushDataToDatabase(userCredential.user!.uid, _shopName.text,
          imageUrl.value, _userName.text);
      GetVarsCtrl.isLoadingChange(false);
      GetVarsCtrl.getSellerCreds();
      if (GetVarsCtrl.isSeller) {
        Get.off(Home_Seller_Sc());
      } else {
        Get.off(const UserMainScreen());
      }
      // If registration is successful, you can navigate to another screen or do something else.
      // For example, Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // Handle registration errors here, like displaying a message to the user.
      // print('Registration failed: $e');
      GetVarsCtrl.scaffoldMsg(context, "${e.message}");
      GetVarsCtrl.isLoadingChange(false);
    }
  }

  //login function
  _login(context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || !isValidEmail(email)) {
      GetVarsCtrl.scaffoldMsg(context, "Please enter a valid email");
      GetVarsCtrl.isLoadingChange(false);
      return;
    }
    if (password.isEmpty) {
      GetVarsCtrl.scaffoldMsg(context, "Please enter your password");
      GetVarsCtrl.isLoadingChange(false);
      return;
    }
    try {
      UserCredential userCredential =
          await GetVarsCtrl.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (GetVarsCtrl.isSeller) {
        DatabaseReference databaseReference =
            FirebaseDatabase.instance.ref();
        var data = await databaseReference
            .child('Sellers')
            .child(userCredential.user!.uid)
            .once();
        var gotData = data.snapshot.value as Map;
        if (gotData["shopName"].toString().isEmpty) {
          GetVarsCtrl.isLoadingChange(false);
          GetVarsCtrl.auth.signOut();
          GetVarsCtrl.scaffoldMsg(context, "This is not an Seller Account !");
          return;
        } else {
          GetVarsCtrl.getSellerCreds();
          GetVarsCtrl.isLoadingChange(false);
          print('User signed in: ${userCredential.user}');
        }
      } else {
        DatabaseReference databaseReference =
            FirebaseDatabase.instance.ref();
        var data = await databaseReference
            .child('Sellers')
            .child(userCredential.user!.uid)
            .once();
        var gotData = data.snapshot.value as Map;
        if (gotData["userName"].toString().isEmpty) {
          GetVarsCtrl.isLoadingChange(false);
          GetVarsCtrl.auth.signOut();
          GetVarsCtrl.scaffoldMsg(context, "This is not an User Account !");
          return;
        } else {
          GetVarsCtrl.getSellerCreds();
          GetVarsCtrl.isLoadingChange(false);
          print('User signed in: ${userCredential.user}');
        }
      }
    } on FirebaseAuthException catch (e) {
      GetVarsCtrl.scaffoldMsg(context, "${e.message}");
      GetVarsCtrl.isLoadingChange(false);
    }
  }

  Future<void> _uploadImageToFirebaseStorage() async {
    if (selectedImage.value == null) {
      print('No image selected');
      return;
    }

    final File imageFile = selectedImage.value!;
    final fileName = imageFile.path.split('/').last;

    try {
      final firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref('/images/$fileName');
      final firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() => print('Image uploaded'));

      final String downloadURL = await ref.getDownloadURL();
      imageUrl.value = downloadURL;
      print('Download URL: $downloadURL');
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<GetVars>(builder: (gV) {
        return Stack(
          children: [
            Container(
              height: Get.height,
              width: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Color.fromARGB(255, 140, 245, 241),
                Color.fromARGB(255, 109, 220, 217),
                Color.fromARGB(255, 76, 197, 193)
              ])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: Text(
                              "$heading",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 84, 84, 84),
                                  fontSize: 40),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Text(
                              "$title",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 84, 84, 84),
                                  fontSize: 18),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                  height: 40,
                                  width: Get.width,
                                  // color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("User"),
                                      GetBuilder<GetVars>(builder: (gV) {
                                        return CupertinoSwitch(
                                            onChanged: (val) {
                                              gV.isSellerChange(val);
                                            },
                                            value: gV.isSeller);
                                      }),
                                      const Text("Seller"),
                                    ],
                                  )),
                              const SizedBox(
                                height: 50,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 700),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(255, 243, 243, 243),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 206, 255, 253),
                                              blurRadius: 20,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        GetBuilder<GetVars>(builder: (gV) {
                                          return Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .grey.shade200))),
                                            child: heading == "Register"
                                                ? TextField(
                                                    controller: gV.isSeller
                                                        ? _shopName
                                                        : _userName,
                                                    decoration: InputDecoration(
                                                        hintText:
                                                            gV.isSeller == true
                                                                ? "Shop Name ?"
                                                                : "User Name ?",
                                                        hintStyle: const TextStyle(
                                                            color: Colors.grey),
                                                        border:
                                                            InputBorder.none),
                                                  )
                                                : Container(),
                                          );
                                        }),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200))),
                                          child: TextField(
                                            controller: _emailController,
                                            decoration: const InputDecoration(
                                                hintText: "Email Address",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors
                                                          .grey.shade200))),
                                          child: TextField(
                                            obscureText: true,
                                            controller: _passwordController,
                                            decoration: const InputDecoration(
                                                hintText: "Password",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        heading == "Register" &&
                                                gV.isSeller == true
                                            ? GetBuilder<GetVars>(
                                                builder: (gV) {
                                                return Container(
                                                    padding: const EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .grey
                                                                    .shade200))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Text(
                                                          "Upload Shop Image",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        GestureDetector(
                                                          onTap: _pickImage,
                                                          child: Container(
                                                            height: 50,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    225,
                                                                    225,
                                                                    225),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: Obx(() {
                                                              if (selectedImage
                                                                      .value !=
                                                                  null) {
                                                                return ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  child: Image
                                                                      .file(
                                                                    selectedImage
                                                                        .value!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                );
                                                              } else {
                                                                return const Icon(
                                                                    Icons
                                                                        .camera_outlined,
                                                                    size: 30);
                                                              }
                                                            }),
                                                          ),
                                                        )
                                                      ],
                                                    ));
                                              })
                                            : Container(),
                                        heading == "Register" &&
                                                gV.isSeller == true
                                            ? GetBuilder<GetVars>(
                                                builder: (gV) {
                                                return Container(
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors.grey
                                                                  .shade200))),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Obx(
                                                            () => Checkbox(
                                                              fillColor:
                                                                  WidgetStateProperty
                                                                      .resolveWith<
                                                                          Color?>(
                                                                (Set<WidgetState>
                                                                    states) {
                                                                  if (states.contains(
                                                                      WidgetState
                                                                          .selected)) {
                                                                    return Colors
                                                                        .green; // Color when checkbox is checked
                                                                  }
                                                                  return null; // Use default color
                                                                },
                                                              ),
                                                              value: shopType
                                                                      .value ==
                                                                  'restaurant',
                                                              onChanged:
                                                                  (value) {
                                                                if (value!) {
                                                                  shopType.value =
                                                                      'restaurant';
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          const Text(
                                                            'I Have Restaurant',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Obx(
                                                            () => Checkbox(
                                                              fillColor:
                                                                  WidgetStateProperty
                                                                      .resolveWith<
                                                                          Color?>(
                                                                (Set<WidgetState>
                                                                    states) {
                                                                  if (states.contains(
                                                                      WidgetState
                                                                          .selected)) {
                                                                    return Colors
                                                                        .green; // Color when checkbox is checked
                                                                  }
                                                                  return null; // Use default color
                                                                },
                                                              ),
                                                              value: shopType
                                                                      .value ==
                                                                  'print',
                                                              onChanged:
                                                                  (value) {
                                                                if (value!) {
                                                                  shopType.value =
                                                                      'print';
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          const Text(
                                                            'I Have Printer Shop',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              })
                                            : Container(),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 40,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1500),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "$tagLine",
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      GestureDetector(
                                        onTap: onCall,
                                        child: Text(
                                          "$tagLineRoute",
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 55, 129, 175)),
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 40,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1600),
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (heading == "Register") {
                                        gV.isLoadingChange(true);
                                        _register(context);
                                      } else {
                                        gV.isLoadingChange(true);
                                        _login(context);
                                      }
                                    },
                                    height: 50,
                                    // margin: EdgeInsets.symmetric(horizontal: 50),
                                    color: const Color.fromARGB(255, 76, 197, 193),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    // decoration: BoxDecoration(
                                    // ),
                                    child: Center(
                                      child: Text(
                                        "$btnText",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            gV.isLoading ? const LoaderCustom() : Container()
          ],
        );
      }),
    );
  }
}
