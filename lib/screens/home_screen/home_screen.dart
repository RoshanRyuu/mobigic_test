import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobigic_tets/controller/home_controller.dart';

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
      appBar: AppBar(title: const Text('2D Grid')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Enter number '),
                    onChanged: (value) {
                      int rows = int.tryParse(value) ?? 0;
                      homeCon.updateDimensions(rows, homeCon.n.value);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Enter number'),
                    onChanged: (value) {
                      int cols = int.tryParse(value) ?? 0;
                      homeCon.updateDimensions(homeCon.m.value, cols);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: homeCon.searchTextController,
                    decoration: const InputDecoration(labelText: 'Enter search text'),
                    onChanged: (value) {
                      homeCon.searchText = value;
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
                          return Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                            child: Center(
                              child: Obx(
                                () {
                                  print(homeCon.controllers[index ~/ homeCon.n.value][index % homeCon.n.value].text
                                      .contains(homeCon.searchTextController.text));
                                  return Text(
                                    homeCon.controllers[index ~/ homeCon.n.value][index % homeCon.n.value].text,
                                    style: TextStyle(
                                      fontWeight: homeCon
                                              .controllers[index ~/ homeCon.n.value][index % homeCon.n.value].text
                                              .contains(homeCon.searchTextController.text)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  );
                                },
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
