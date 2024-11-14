import 'package:cocoa_monitor/view/appraisal/appraisal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../global_components/custom_button.dart';
import '../global_components/globals.dart';
import '../global_components/round_icon_button.dart';
import '../global_components/text_input_decoration.dart';
import '../utils/style.dart';

class Appraisal extends StatefulWidget {
  const Appraisal({Key? key}) : super(key: key);

  @override
  State<Appraisal> createState() => _AppraisalState();
}

class _AppraisalState extends State<Appraisal> {
  final AppraisalController _appraisalController =
      Get.put(AppraisalController());

  List data = [];
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
    _initializeControllers();
    setState(() {});
  }

  _initializeControllers() {
    reasonControllers =
        List.generate(data.length, (_) => TextEditingController());
    ratingsController =
        List.generate(data.length, (_) => TextEditingController());
    areasForImprovementControllers =
        List.generate(data.length, (_) => TextEditingController());
    commentsControllers =
        List.generate(data.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
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

  validateFields(){
    for (int i = 0; i < ratingsController.length; i++) {
      if (ratingsController[i].text == "" ||
          reasonControllers[i].text == "") {
        _appraisalController.globals.showSnackBar(
            title: 'Alert',
            message:
            'Kindly provide all required information');
        return;
      }
    }
  }

  submit()async {
    validateFields();
    var dt = [];
    for (int i = 0; i < data.length; i++) {
      var item = {
        "evaluation": data[i]["evaluation"],
        "appraisee_rating": int.tryParse(ratingsController[i].text),
        "appraisee_reasons": reasonControllers[i].text,
      };
      dt.add(item);
    }

    var d = {
      "id": _appraisalController.id,
      "employee": _appraisalController.employee,
      "performance_appraisal": dt,
      "development_appraisal":{"areas_for_improvement": _appraisalController.areaForImprovementController.text},
      "appraisal_comment":{"appraisee_comments": _appraisalController.commentController.text}
    };

    bool feedback = await _appraisalController.submit(d);

    if (feedback) {
      Get.back();
      _appraisalController.globals.showSnackBar(
          title: 'Success',
          message: 'Feedback submitted successfully');
    } else {
      _appraisalController.globals.showSnackBar(
          title: 'Failed',
          message: 'Failed to submit appraisal, contact support');

    }
  }
  @override
  Widget build(BuildContext context) {
    _appraisalController.appraisalContext = context;
    return Scaffold(
      body: Column(
        children: [
          // Fixed Top navigation and title bar
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
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Obx(() {
                      if (_appraisalController.done.value == false) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (data.isEmpty) {
                        return const Center(
                            child: Text("No questions to display"));
                      }
                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (ctx, index) => Column(
                          children: [
                            const SizedBox(height: 20),
                            Divider(
                                color: AppColor.lightText.withOpacity(0.5),
                                thickness: 1),
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17),
                              ),
                              const SizedBox(height: 15),
                              const Text('Rating',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: ratingsController[index],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
                                  enabledBorder: inputBorder,
                                  focusedBorder: inputBorderFocused,
                                  errorBorder: inputBorder,
                                  focusedErrorBorder: inputBorderFocused,
                                  filled: true,
                                  fillColor: AppColor.xLightBackground,
                                ),
                              ),
                              const Text('Reason',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              TextFormField(
                                controller: reasonControllers[index],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 15),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                            color: AppColor.lightText.withOpacity(0.5), thickness: 1),
                        const Text('Area for improvement',
                            style:
                            TextStyle(fontWeight: FontWeight.w500)),
                        TextFormField(
                          controller: _appraisalController.areaForImprovementController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            enabledBorder: inputBorder,
                            focusedBorder: inputBorderFocused,
                            errorBorder: inputBorder,
                            focusedErrorBorder: inputBorderFocused,
                            filled: true,
                            fillColor: AppColor.xLightBackground,
                          ),
                        ),
                        const Text('Comment',
                            style:
                            TextStyle(fontWeight: FontWeight.w500)),
                        TextFormField(
                          controller: _appraisalController.commentController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            enabledBorder: inputBorder,
                            focusedBorder: inputBorderFocused,
                            errorBorder: inputBorder,
                            focusedErrorBorder: inputBorderFocused,
                            filled: true,
                            fillColor: AppColor.xLightBackground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 15),
                    child: CustomButton(
                      isFullWidth: true,
                      backgroundColor: AppColor.primary,
                      verticalPadding: 0.0,
                      horizontalPadding: 8.0,
                      onTap: () => submit(),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: AppColor.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
