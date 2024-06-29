import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetVars extends GetxController {
  var isSeller = false;
  var isLoading = false;
  var uID = "";                          //user ID
  var currentUserName = "";              // username
  final FirebaseAuth auth = FirebaseAuth.instance;
  String currentTimeStatus = 'Good Morning';
  RxString currentTime = ''.obs;          //current time
  Map sellerData = {};
  List menuData = [];
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoad = false;

  @override
  void onInit() {
    _getIsSellerFromSharedPreferences();
    getSellerCreds();
    currentTimeStatus = getCurrentStatus();
    updateTime();
    startTimer();
    super.onInit();
  }

  loading(val) async {
    isLoad = val;
    update();
  }


  void updateTime() {
    final now = DateTime.now();
    final formattedTime = _formatTime(now.hour, now.minute, now.second);
    currentTime.value = formattedTime;
  }

  String _formatTime(int hour, int minute, int second) {
    String period = 'AM';
    if (hour >= 12) {
      period = 'PM';
      hour = hour == 12 ? 12 : hour - 12;
    }
    hour = hour == 0 ? 12 : hour;
    return '${_formatTwoDigits(hour)}:${_formatTwoDigits(minute)}:${_formatTwoDigits(second)} $period';
  }

  String _formatTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      updateTime();
    });
  }

  String getCurrentStatus() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  getSellerCreds() async {
    // print("hi2");
    try {
      // print("hi3");
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref();
      var data = await databaseReference
          .child('Sellers')
          .child(auth.currentUser!.uid)
          .once();
      var gotData = data.snapshot.value as Map;
      sellerData = gotData;
      print("hi4");
      if (sellerData["userName"].toString().isNotEmpty) {
        currentUserName = sellerData["userName"];
      }

      // menuData.add("${gotData["menus"]}");
      menuData.clear();
      menuData.addAll(sellerData["menus"].values.toList());
      menuData.toSet();
      // print(menuData.length);

      if (sellerData["shopName"].toString().isEmpty) {
        // print("hid4");
        // scaffoldMsg(context, "Check Internet Connection !");
      }
      update();
    } catch (e) {
      // print("${e}");
      // scaffoldMsg(context, "Check Internet Connection !");
    }
  }

  removeMenu(title) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    final DatabaseReference sellerRef =
        databaseReference.child('Sellers').child(uID).child('menus');
    await sellerRef.child(title).remove();
    update();
  }

  Future<void> _getIsSellerFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final storedValue = prefs.getBool('isTrue');
    if (storedValue != null) {
      isSeller = storedValue;
      uID = auth.currentUser!.uid;
      update();
    }
    print('isSeller: $isSeller');
  }

  void isSellerChange(bool val) async {
    isSeller = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isTrue', isSeller);
    update();
  }

  void isLoadingChange(bool val) {
    isLoading = val;
    update();
  }

  scaffoldMsg(context, text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.all(10),
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 179, 55, 46),
    ));
  }
}
