import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPrints extends StatelessWidget {
  var list = [];
  ViewPrints({required this.list, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: CarouselSlider(
          items: list.map((image) {
            return Container(
              margin: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  image,
                  fit: BoxFit.fitHeight,
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) {},
          ),
        ),
      ),
    );
  }
}
