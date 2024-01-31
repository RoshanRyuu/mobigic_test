import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<int> m = 0.obs;
  Rx<int> n = 0.obs;
  TextEditingController searchTextController = TextEditingController();
  List<List<TextEditingController>> controllers = [];
  String searchText = '';
  RxBool found = false.obs;
  RxBool containsSearchText = false.obs;
  void updateDimensions(int rows, int cols) {
    m.value = rows;
    n.value = cols;
    controllers = List.generate(
      m.value,
      (i) => List.generate(
        n.value,
        (j) => TextEditingController()..text = generateRandomString(),
      ),
    );
    update(); // Trigger a rebuild
  }

  String generateRandomString({int length = 10}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    return String.fromCharCodes(
      List.generate(length, (index) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  bool isTextFound(String searchText) {
    if (searchText.isEmpty) {
      return false;
    }

    for (int i = 0; i < m.value; i++) {
      for (int j = 0; j < n.value; j++) {
        if (controllers[i][j].text.toLowerCase() == searchText.toLowerCase()) {
          return true;
        }
      }
    }

    return false;
  }

  // bool isTextReadableEast(int row, int col, int textLength) {
  //   return col + textLength <= n.value;
  // }
  //
  // bool isTextReadableSouth(int row, int col, int textLength) {
  //   return row + textLength <= m.value;
  // }
  //
  // bool isTextReadableSoutheast(int row, int col, int textLength) {
  //   return isTextReadableEast(row, col, textLength) && isTextReadableSouth(row, col, textLength);
  // }
}
