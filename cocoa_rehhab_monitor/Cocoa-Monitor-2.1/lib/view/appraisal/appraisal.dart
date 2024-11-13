import 'package:cocoa_monitor/view/appraisal/appraisal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global_components/custom_button.dart';
import '../global_components/round_icon_button.dart';
import '../global_components/text_input_decoration.dart';
import '../utils/style.dart';

class Appraisal extends StatefulWidget {
  const Appraisal({Key? key}) : super(key: key);

  @override
  State<Appraisal> createState() => _AppraisalState();
}

class _AppraisalState extends State<Appraisal> {
  final AppraisalController _appraisalController = Get.put(AppraisalController());
  List data = [];
  int id = 0;
  int employee = 0;

  List<TextEditingController> reasonControllers = [];
  List<TextEditingController> ratingsController = [];
  List<TextEditingController> areasForImprovementControllers = [];
  List<TextEditingController> commentsControllers = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  _fetch() async {
    data = await _appraisalController.fetch;
    _initializeControllers(); // Initialize controllers after fetching data
    setState(() {});
  }

  _initializeControllers() {
    // Ensure controllers list lengths match the data length
    reasonControllers = List.generate(data.length, (_) => TextEditingController());
    ratingsController = List.generate(data.length, (_) => TextEditingController());
    areasForImprovementControllers = List.generate(data.length, (_) => TextEditingController());
    commentsControllers = List.generate(data.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose of controllers to prevent memory leaks
    for (final controller in reasonControllers) {
      controller.dispose();
    }
    for (final controller in ratingsController) {
      controller.dispose();
    }
    for (final controller in areasForImprovementControllers) {
      controller.dispose();
    }
    for (final controller in commentsControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top navigation and title bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColor.lightText.withOpacity(0.5),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 15,
                bottom: 10,
                left: AppPadding.horizontal,
                right: AppPadding.horizontal,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedIconButton(
                    icon: appIconBack(color: AppColor.black, size: 25),
                    size: 45,
                    backgroundColor: Colors.transparent,
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Appraisal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // List of questions with input fields
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(() {
                if (_appraisalController.done.value == false) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (data.isEmpty) {
                  return const Center(child: Text("No questions to display"));
                }
                return ListView.separated(
                  separatorBuilder: (ctx, index) => Column(
                    children: [
                      const SizedBox(height: 20),
                      Divider(color: AppColor.lightText.withOpacity(0.5), thickness: 1),
                      const SizedBox(height: 20),
                    ],
                  ),
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data[index]["evaluation"],
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                        const SizedBox(height: 15),
                        const Text('Rating', style: TextStyle(fontWeight: FontWeight.w500)),
                        TextFormField(
                          controller: ratingsController[index],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            enabledBorder: inputBorder,
                            focusedBorder: inputBorderFocused,
                            errorBorder: inputBorder,
                            focusedErrorBorder: inputBorderFocused,
                            filled: true,
                            fillColor: AppColor.xLightBackground,
                          ),
                        ),
                        const Text('Reason', style: TextStyle(fontWeight: FontWeight.w500)),
                        TextFormField(
                          controller: reasonControllers[index],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            enabledBorder: inputBorder,
                            focusedBorder: inputBorderFocused,
                            errorBorder: inputBorder,
                            focusedErrorBorder: inputBorderFocused,
                            filled: true,
                            fillColor: AppColor.xLightBackground,
                          ),
                        ),
                        const Text('Area for improvement', style: TextStyle(fontWeight: FontWeight.w500)),
                        TextFormField(
                          controller: areasForImprovementControllers[index],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            enabledBorder: inputBorder,
                            focusedBorder: inputBorderFocused,
                            errorBorder: inputBorder,
                            focusedErrorBorder: inputBorderFocused,
                            filled: true,
                            fillColor: AppColor.xLightBackground,
                          ),
                        ),
                        const Text('Comment', style: TextStyle(fontWeight: FontWeight.w500)),
                        TextFormField(
                          controller: commentsControllers[index],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            enabledBorder: inputBorder,
                            focusedBorder: inputBorderFocused,
                            errorBorder: inputBorder,
                            focusedErrorBorder: inputBorderFocused,
                            filled: true,
                            fillColor: AppColor.xLightBackground,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ),
          // Submit button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomButton(
              isFullWidth: true,
              backgroundColor: AppColor.primary,
              verticalPadding: 0.0,
              horizontalPadding: 8.0,
              onTap: () async {

                var dt = [];
                for(int i=0; i<data.length; i++){
                  var item = {
                    "evaluation": data[i]["evaluation"],
                    "rating": ratingsController[i].text,
                    "reason": reasonControllers[i].text,
                    "area_for_improvement": areasForImprovementControllers[i].text,
                    "comment": commentsControllers[i].text
                  };
                  if(ratingsController[i].text != "" || reasonControllers[i].text != "" || areasForImprovementControllers[i].text != ""){
                    dt.add(item);
                  }
                }

                var d = {
                  "id": _appraisalController.id,
                  "performance_appraisal":[

                  ],
                };

                print("THE DATA FOR POST ======== $data");
              },
              child: Text(
                'Submit',
                style: TextStyle(color: AppColor.white, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
