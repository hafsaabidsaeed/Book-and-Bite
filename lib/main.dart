import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secondevaluation/GetVars/initial.dart';
import 'package:secondevaluation/Screens/Seller_Sc/home_seller_sc.dart';
import 'package:secondevaluation/Screens/home_sc.dart';
import 'package:secondevaluation/Screens/login_sc.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAK0G7DrMkEOOYw6Xs3Am01txw_9hljsug",
          appId: "1:1052097614365:android:4c6746dbc949b9ab4cacf4",
          storageBucket: "gs://bookandbite-7d55a.appspot.com",
          databaseURL:
              "https://bookandbite-7d55a-default-rtdb.firebaseio.com/",
          messagingSenderId: "messagingSenderId",
          projectId: "bookandbite-7d55a"));
  runApp(myApp());
}

class myApp extends StatelessWidget {
  myApp({super.key});
  final GetVarsCtrl = Get.put(GetVars());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    return GetBuilder<GetVars>(builder: (gV) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: GetVarsCtrl.auth.currentUser == null
            ? LoginPage(
                heading: "Login",
                title: "Welcome Back",
                btnText: "Login",
                tagLine: "Don't have an Acoount ? ",
                tagLineRoute: "Reg Here",
                onCall: () {
                  Get.to(
                    LoginPage(
                        heading: "Register",
                        title: "Welcome Here",
                        btnText: "Register",
                        tagLine: "Already have an Acoount ? ",
                        tagLineRoute: "Login Here",
                        onCall: () {
                          Get.back();
                        }),
                  );
                })
            : GetVarsCtrl.isSeller
                ? Home_Seller_Sc()
                : Home_Sc(),
      );
    });
  }
}
