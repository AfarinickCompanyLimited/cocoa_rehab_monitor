import 'package:cocoa_monitor/view/appraisal/appraisal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final AppraisalController _appraisalController =
  Get.put(AppraisalController());

  List data = [];
  List<TextEditingController> reasonControllers = [];
  List<TextEditingController> ratingsController = [];
  List<TextEditingController> areasForImprovementControllers = [];
  List<TextEditingController> commentsControllers = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  _getQuestionLimit(String dt) {
    var d = dt.split("- (")[1].split(" ")[0];
    return int.parse(d);
  }

  _fetch() async {
    data = await _appraisalController.fetch;
    _initializeControllers();
    setState(() {});
  }

  bool isDoneChecked = false; // Checkbox state variable

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

  validateFields() {
    if (!_formKey.currentState!.validate()) {
      _appraisalController.globals.showSnackBar(
        title: 'Alert',
        message: 'Kindly provide review and fix all the issues',
      );
      return false;
    }

    if(!isDoneChecked) {
      _appraisalController.globals.showSnackBar(
        title: 'Alert',
        message: 'Kindly check the checkbox if you are done',
      );
      return false;
    }
    return true;
  }

  submit() async {
    if (!validateFields()) return;
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
      "development_appraisal": {
        "areas_for_improvement":
        _appraisalController.areaForImprovementController.text,
      },
      "appraisal_comment": {
        "appraisee_comments": _appraisalController.commentController.text,
      },
      "appraisee_completed": isDoneChecked
    };

    bool feedback = await _appraisalController.submit(d);

    print("THE FEEDBACK IS ${feedback}");

    if (feedback) {
      Get.back();
      _appraisalController.globals.showSnackBar(
          title: 'Success', message: 'Appraisal submitted successfully');
    } else if(!feedback){
      _appraisalController.globals.showSnackBar(
          title: 'Failed',
          message: 'You have submitted the appraisal already');
    } else {
      _appraisalController.globals.showSnackBar(
          title: 'Failed', message: 'Something went wrong, contact support for assistance');
    }
  }

  @override
  Widget build(BuildContext context) {
    _appraisalController.appraisalContext = context;
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
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, // Attach the form key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Obx(() {
                        if (_appraisalController.done.value == false) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                            int limit =
                            _getQuestionLimit(data[index]["evaluation"]);

                            if(ratingsController[index].text.isEmpty) {
                              ratingsController[index].text =1.toString();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]["evaluation"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                ),
                                const SizedBox(height: 15),
                                const Text('Rating',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)),
                                Column(
                                  children: [
                                    Text(
                                      "Selected Rating: ${int.parse(ratingsController[index].text)}",
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    Slider(
                                      value: double.parse(ratingsController[index].text),
                                      min: 1,
                                      max: limit.toDouble(),
                                      divisions: limit - 1,
                                      onChanged: (value) {
                                        setState(() {
                                          // sliderValues[index] = value;
                                          ratingsController[index].text = value.toInt().toString(); // Sync with controller
                                        });
                                      },
                                      activeColor: AppColor.primary,
                                      inactiveColor: AppColor.lightText.withOpacity(0.5),
                                    ),
                                  ],
                                ),


                                const Text('Reason',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)),
                                TextFormField(
                                  maxLines: 2,
                                  controller: reasonControllers[index],
                                  decoration: InputDecoration(
                                    contentPadding:
                                    const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    enabledBorder: inputBorder,
                                    focusedBorder: inputBorderFocused,
                                    errorBorder: inputBorder,
                                    focusedErrorBorder: inputBorderFocused,
                                    filled: true,
                                    fillColor: AppColor.xLightBackground,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Reason is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                    ),
                    if(data.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                              color: AppColor.lightText.withOpacity(0.5),
                              thickness: 1),
                          const Text('Area for improvement',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          TextFormField(
                            controller:
                            _appraisalController.areaForImprovementController,
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
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          TextFormField(
                            controller:
                            _appraisalController.commentController,
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
                    if(data.isNotEmpty)
                    Row(
                      children: [
                        Checkbox(value: isDoneChecked, onChanged: (value){
                          setState(() {
                            isDoneChecked = value ?? false;
                          });
                        }),
                        const Text('I confirm that I have completed this activity',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                    if(data.isNotEmpty)
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
                          style:
                          TextStyle(color: AppColor.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

