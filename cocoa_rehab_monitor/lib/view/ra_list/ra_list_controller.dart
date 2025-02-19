import 'package:cocoa_rehab_monitor/controller/api_interface/cocoa_rehab/personnel_assignment_apis.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/globals.dart';
import 'package:cocoa_rehab_monitor/view/home/home_controller.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../controller/db/rehab_assistant_db.dart';
import '../../controller/model/rehab_assistant_model.dart';
import 'components/ra_bottomsheet.dart';

class RAListController extends GetxController {
  BuildContext? rAListScreenContext;

  HomeController homeController = Get.find();

  GlobalController globalController = Get.find();

  Globals globals = Globals();

  PersonnelAssignmentApiInterface personnelAssignmentApiInterface =
      PersonnelAssignmentApiInterface();

  TextEditingController? searchTC = TextEditingController();

  final rehabAssistantRepository = Get.put(RehabAssistantRepository());

  // TabController? tabController;
  // var activeTabIndex = 0.obs;

  final PagingController<int, RehabAssistant> pagingController =
      PagingController(firstPageKey: 0);
  final int _pageSize = 10;

  // INITIALISE
  //
  // Future<void> fetchData(
  //     {required String searchTerm,
  //     required int pageKey,
  //     required PagingController controller}) async
  // {
  //   try {
  //     final data = searchTerm.trim().isEmpty
  //         ? await globalController.database!.rehabAssistantDao
  //             .findRehabAssistantsWithLimit(_pageSize, pageKey * _pageSize)
  //         : await globalController.database!.rehabAssistantDao
  //             .findRehabAssistantsWithSearchAndLimit(
  //                 "%${searchTerm.trim()}%".toLowerCase(),
  //                 _pageSize,
  //                 pageKey * _pageSize);
  //     final isLastPage = data.length < _pageSize;
  //     if (isLastPage) {
  //       controller.appendLastPage(data);
  //     } else {
  //       final nextPageKey = pageKey + 1;
  //       controller.appendPage(data, nextPageKey);
  //     }
  //   } catch (error, stackTrace) {
  //     controller.error = error;
  //   FirebaseCrashlytics.instance.recordError(error, stackTrace);
  //       FirebaseCrashlytics.instance.log('ra list. fetchData');
  //
  //
  //   }
  // }

  viewRA(RehabAssistantModel rehabAssistant) {
    showModalBottomSheet<void>(
      elevation: 5,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.md),
        ),
      ),
      context: rAListScreenContext!,
      builder: (context) {
        return RABottomSheet(rehabAssistant: rehabAssistant);
      },
    );
  }

  Future<List<RehabAssistantModel>>? dataFuture;
  RehabAssistantDatabaseHelper db = RehabAssistantDatabaseHelper.instance;

  Future<List<RehabAssistantModel>> fetchData({String? searchTerm}) async {
    List<RehabAssistantModel> data = await db.getAllData();
    if (searchTerm != null && searchTerm.isNotEmpty) {
      data =
          data
              .where(
                (ra) =>
                    ra.rehabName.toLowerCase().contains(searchTerm.toLowerCase()) ||
                    ra.staffId!.contains(searchTerm),
              )
              .toList();
    }
    return data;
  }

  @override
  void onInit() {
    super.onInit();
    dataFuture = fetchData();
  }
}

class RehabAssistantRepository {
  GlobalController globalController = Get.find();
  final _rehabAssistantList = RxList<RehabAssistant>();
  final _filteredRehabAssistantList = RxList<RehabAssistant>();

  List<RehabAssistant> get rehabAssistantList => _filteredRehabAssistantList;

  Future<void> initializeData() async {
    final rehabAssistantData =
        await globalController.database!.rehabAssistantDao
            .findAllRehabAssistants();
    _rehabAssistantList.addAll(rehabAssistantData);
    _filteredRehabAssistantList.addAll(rehabAssistantData);
  }

  void search(String rehabName) {
    final filteredList =
        _rehabAssistantList
            .where(
              (rehab) =>
                  rehab.rehabName!.toLowerCase().contains(
                    rehabName.toLowerCase(),
                  ) ||
                  rehab.staffId!.toLowerCase().contains(
                    rehabName.toLowerCase(),
                  ),
            )
            .toList();
    _filteredRehabAssistantList.clear();
    _filteredRehabAssistantList.addAll(filteredList);
  }
}
