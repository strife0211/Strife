import 'package:get/get.dart';

class NavigationController extends GetxController {
  var tabIndex = 4;

  void changeTabInex(int index) {
    tabIndex = index;
    update();
  }
}