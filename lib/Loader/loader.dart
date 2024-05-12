import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoaderCustom extends StatelessWidget {
  const LoaderCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: Color.fromARGB(116, 255, 255, 255),
      child: Lottie.asset("assets/load.json", height: 10),
    );
  }
}
