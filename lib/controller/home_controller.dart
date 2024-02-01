import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<List<String>> grid = <List<String>>[].obs;
  Rx<int> m = 0.obs;
  Rx<int> n = 0.obs;
  TextEditingController searchTextController = TextEditingController();
  List<List<TextEditingController>> controllers = [];
  Rx<String> searchText = "".obs;
  RxBool found = false.obs;
  RxBool containsSearchText = false.obs;
  Rx<String> row = "".obs;
  Rx<String> col = "".obs;

  void updateDimensions(int rows, int cols) {
    m.value = rows;
    n.value = cols;
    controllers = List.generate(
      m.value,
      (i) => List.generate(
        n.value,
        (j) {
          return TextEditingController()..text = generateRandomString();
        },
      ),
    );
    update(); // Trigger a rebuild
  }

  String generateRandomString({int length = 4}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    return String.fromCharCodes(
      List.generate(length, (index) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(
        TextSpan(
          text: source.substring(match.start, match.end),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }
}
