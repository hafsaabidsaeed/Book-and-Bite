import 'package:get/get.dart';

class DiscountCarouselController extends GetxController {
  var currentIndex = 0.obs;
  final List<String> images = [
    'assets/discount/discount1.jpg',
    'assets/discount/discount2.jpg',
    'assets/discount/discount3.jpg',
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
