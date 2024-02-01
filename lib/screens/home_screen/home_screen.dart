import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobigic_test/controller/home_controller.dart';
import 'package:mobigic_test/screens/components/common_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeCon = Get.put<HomeController>(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    keyBoardType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    labelText: 'Enter number',
                    onChanged: (value) {
                      int rows = int.tryParse(value) ?? 0;
                      homeCon.updateDimensions(rows, homeCon.n.value);
                      homeCon.row.value = value;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CommonTextField(
                    keyBoardType: TextInputType.number,
                    inputFormatters: [LengthLimitingTextInputFormatter(1)],
                    labelText: 'Enter number',
                    onChanged: (value) {
                      homeCon.col.value = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (homeCon.row.isEmpty) {
                  Get.snackbar("Error", "Please enter row digit");
                } else if (homeCon.col.isEmpty) {
                  Get.snackbar("Error", "Please enter column digit");
                } else {
                  int cols = int.tryParse(homeCon.col.value) ?? 0;
                  homeCon.updateDimensions(homeCon.m.value, cols);
                }
              },
              child: const Center(child: Text("Create Grid")),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    con: homeCon.searchTextController,
                    labelText: 'Enter search text',
                    onChanged: (value) {
                      homeCon.searchText.value = value;
                      homeCon.update();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Obx(
              () => homeCon.n.value == 0
                  ? const SizedBox()
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: homeCon.n.value,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: homeCon.m.value * homeCon.n.value,
                        itemBuilder: (context, index) {
                          final int row = index ~/ homeCon.n.value;
                          final int col = index % homeCon.n.value;
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Obx(
                              () => Center(
                                child: Text.rich(
                                  TextSpan(
                                    children: homeCon.highlightOccurrences(
                                        homeCon.controllers[row][col].text, homeCon.searchText.value),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
