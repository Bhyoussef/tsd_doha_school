import 'package:get/get.dart';

enum DrawerOption { myChildren, myMessages, myPayments, about }

class DrawerController extends GetxController {
  final selectedOption = DrawerOption.myChildren.obs;

  void changeSelectedOption(DrawerOption option) {
    selectedOption.value = option;
  }

  bool isOptionSelected(DrawerOption option) {
    return selectedOption.value == option;
  }
}
