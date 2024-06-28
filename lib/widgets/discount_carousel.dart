import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../GetVars/discount_carousel_controller.dart';

class DiscountCarousel extends StatelessWidget {
  final DiscountCarouselController _controller = Get.put(DiscountCarouselController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,  // Adjust height as needed
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              _controller.changeIndex(index);
            },
          ),
          items: _controller.images.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _controller.images.map((url) {
              int index = _controller.images.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _controller.currentIndex.value == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
