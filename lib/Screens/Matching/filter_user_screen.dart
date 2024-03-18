import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:strife/Screens/Matching/controllers/matching_controller.dart';
import 'package:strife/constants.dart';

class FilterUserScreen extends StatelessWidget {
  const FilterUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matchingController = Get.put(MatchingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        backgroundColor: appBarPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Gender",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: appBarPrimaryColor,
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Container(
            //       margin: const EdgeInsets.only(top: 10, bottom: 10),
            //       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            //       decoration: BoxDecoration(
            //         color: Colors.grey.shade200,
            //         borderRadius: BorderRadius.circular(5),
            //       ),
            //       child: Text(
            //         "Male",
            //         style: Theme.of(context).textTheme.bodyLarge,
            //       ),
            //     ),
            //     Container(
            //       margin: const EdgeInsets.only(top: 10, bottom: 10),
            //       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            //       decoration: BoxDecoration(
            //         color: Colors.grey.shade200,
            //         borderRadius: BorderRadius.circular(5),
            //       ),
            //       child: Text(
            //         "Female",
            //         style: Theme.of(context).textTheme.bodyLarge,
            //       ),
            //     )
            //   ],
            // ),
            GetBuilder<MatchingController>(builder: (_) {
              return ToggleButtons(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                isSelected: matchingController.selectedGender,
                renderBorder: false,
                fillColor: Colors.white,
                onPressed: (val) {
                  matchingController.setGenderIndex(val);
                },
                children: List<Widget>.generate(2, (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: matchingController.selectedGender[index]
                      ? Colors.blue.shade200
                      : Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(5),
                    width: 160,
                    height: 70,
                    alignment: Alignment.center,
                    child: Text(
                      matchingController.genderTextList[index],
                      style: const TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ),
                ))
              );

              // return ToggleButtons(
              //   onPressed: (int index) {
              //     matchingController.setGenderIndex(index);
              //   },
              //   borderRadius: const BorderRadius.all(Radius.circular(10)),
              //   selectedBorderColor: Colors.blue[700],
              //   selectedColor: Colors.white,
              //   fillColor: Colors.blue[200],
              //   renderBorder: false,
              //   // color: Colors.green,
              //   constraints: const BoxConstraints(
              //     minHeight: 40.0,
              //     minWidth: 80.0,
              //   ),
              //   isSelected: matchingController.selectedGender,
              //   children: [
              //     Text(
              //       "Male",
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //     Text(
              //       "Female",
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //     // Container(
              //     //   margin: const EdgeInsets.only(top: 10, bottom: 10),
              //     //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //     //   decoration: BoxDecoration(
              //     //     color: Colors.grey.shade200,
              //     //     borderRadius: BorderRadius.circular(5),
              //     //   ),
              //     //   child: Text(
              //     //     "Male",
              //     //     style: Theme.of(context).textTheme.bodyLarge,
              //     //   ),
              //     // ),
              //     // Container(
              //     //   margin: const EdgeInsets.only(top: 10, bottom: 10),
              //     //   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              //     //   decoration: BoxDecoration(
              //     //     color: Colors.grey.shade200,
              //     //     borderRadius: BorderRadius.circular(5),
              //     //   ),
              //     //   child: Text(
              //     //     "Female",
              //     //     style: Theme.of(context).textTheme.bodyLarge,
              //     //   ),
              //     // )
              //   ],
              // );
            }),
            const SizedBox(height: 20),
            Text(
              "Age",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: appBarPrimaryColor,
              ),
            ),
            GetBuilder<MatchingController>( builder: (_) {
              return RangeSlider(
                values: matchingController.values,
                labels: matchingController.labels,
                divisions: 100,
                min: 0,
                max: 100,
                onChanged: (value) {
                  matchingController.setRange(value);
                },
              );
            }),
            const SizedBox(height: 20),
            Text(
              "Games",
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: appBarPrimaryColor,
              ),
            ),
            GetBuilder<MatchingController>(builder: (_) {
              return Column(
                children: <Widget> [
                  ListTile(
                    title: const Text('Recent Game Played'),
                    leading: Radio(
                      value: matchingController.gameTextList[0],
                      groupValue: matchingController.game,
                      onChanged: (value) {
                        matchingController.setGame(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Longest Game Played'),
                    leading: Radio(
                      value: matchingController.gameTextList[1],
                      groupValue: matchingController.game,
                      onChanged: (value) {
                        matchingController.setGame(value!);
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Same Game Played'),
                    leading: Radio(
                      value: matchingController.gameTextList[2],
                      groupValue: matchingController.game,
                      onChanged: (value) {
                        matchingController.setGame(value!);
                      },
                    ),
                  ),
                ],
              );
            }),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    matchingController.filter();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[200],
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("Filter", style: TextStyle(color: tDarkColor)),
                ),
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Row(
            //       children: [
            //         Container(
            //           width: 250,
            //           margin: const EdgeInsets.only(top: 10, bottom: 10),
            //           padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            //           decoration: BoxDecoration(
            //             color: Colors.grey.shade200,
            //             borderRadius: BorderRadius.circular(5),
            //           ),
            //           child: Text(
            //             "Recent Game Played",
            //             style: Theme.of(context).textTheme.bodyLarge,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //         Container(
            //           width: 250,
            //           margin: const EdgeInsets.only(top: 10, bottom: 10),
            //           padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            //           decoration: BoxDecoration(
            //             color: Colors.grey.shade200,
            //             borderRadius: BorderRadius.circular(5),
            //           ),
            //           child: Text(
            //             "Longest Game Played",
            //             style: Theme.of(context).textTheme.bodyLarge,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Row(
            //       children: [
            //         Container(
            //           width: 250,
            //           margin: const EdgeInsets.only(top: 10, bottom: 10),
            //           padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            //           decoration: BoxDecoration(
            //             color: Colors.grey.shade200,
            //             borderRadius: BorderRadius.circular(5),
            //           ),
            //           child: Text(
            //             "Same Game Played",
            //             style: Theme.of(context).textTheme.bodyLarge,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}