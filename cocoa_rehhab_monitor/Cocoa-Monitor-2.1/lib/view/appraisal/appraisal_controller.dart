import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/global_controller.dart';
import '../../controller/utils/dio_singleton_instance.dart';
import '../global_components/globals.dart';

class AppraisalController extends GetxController {
  BuildContext? appraisalContext;
  final indexController  = Get.put(GlobalController());
  int id = 0;
  int employee = 0;

  final globalController = Get.put(GlobalController());
  final globals = Globals();

  RxBool done= false.obs;

  List questions = [];
  List reasonControllers = [];
  List ratingsController = [];

  final TextEditingController commentController = TextEditingController();
  final TextEditingController areaForImprovementController = TextEditingController();

  _createTextController() {
    questions.forEach((element) {
      reasonControllers.add(TextEditingController());
      ratingsController.add(TextEditingController());
    });
  }


  get fetch => _fetchAppraisalQuestions();
  get create => _createTextController();

  _fetchAppraisalQuestions() async {
    String employeeID = 'U0004';
    String baseURL = "http://18.171.87.243/";
    String appraisalEndPoint = "api/v1/appraisals/${employeeID}/";
    try {
      var response = await DioSingleton.instance
          .get(baseURL + appraisalEndPoint,
      );

      done.value = true;

      if(response.data["data"] != null) {
        id = response.data["data"]['id'];
        employee = response.data["data"]['employee'];
        List resultList = response.data["data"]["performance_appraisal"];

        print("THE RESULT IS ${resultList}");

        // questions = resultList;

        // List<AppraisalModel> appraisals =
        // resultList.map((e) => appraisalFromJson(jsonEncode(e))).toList();
        //
        // appraisals.forEach((element) {
        //   questions.add(element.toJson()["performance_appraisal"]);
        // });

        print("THE QUESTIONS ARE ${questions}");

        return resultList;
      }
    } catch (e) {
      print(e);
    }
  }

  submit(data) async {
    String employeeID = globalController.userInfo.value.userId.toString();
    String baseURL = "http://18.171.87.243/";
    String appraisalEndPoint = "api/v1/appraisals/${employeeID}/";
    globals.startWait(appraisalContext!);
    try {
      var response = await DioSingleton.instance
          .post(baseURL + appraisalEndPoint,
        data: data
      );

      print("THE RESPONSE IS ============ ${response.data}");
    globals.endWait(appraisalContext!);
      if(response.data["status"] == 200) {
        return true;
      }else {
        return false;
      }

    } catch (e) {
      return false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    _fetchAppraisalQuestions();

    _createTextController();
  }
}