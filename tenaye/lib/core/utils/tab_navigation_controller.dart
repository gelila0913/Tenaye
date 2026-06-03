import 'package:flutter/foundation.dart';

class TabNavigationController {
  // Selected tab index (defaults to index 2: Medications)
  static final ValueNotifier<int> selectedIndex = ValueNotifier<int>(2);

  static void changeTab(int index) {
    selectedIndex.value = index;
  }
}
