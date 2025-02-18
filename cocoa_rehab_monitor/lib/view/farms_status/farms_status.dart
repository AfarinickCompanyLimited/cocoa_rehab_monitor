import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/farm_status.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'components/farm_status_card.dart';
import 'farms_status_controller.dart';


class FarmsStatus extends StatefulWidget {
  const FarmsStatus({Key? key}) : super(key: key);

  @override
  State<FarmsStatus> createState() => _FarmsStatusState();
}

class _FarmsStatusState extends State<FarmsStatus> with SingleTickerProviderStateMixin {

  FarmsStatusController farmsStatusController = Get.put(FarmsStatusController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    farmsStatusController.pagingController.addPageRequestListener((pageKey) {
      farmsStatusController.fetchData(status: SubmissionStatus.pending, pageKey: pageKey, controller: farmsStatusController.pagingController);
    });

  }

  @override
  void dispose() {
    farmsStatusController.pagingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    farmsStatusController.farmsStatusScreenContext = context;

    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColor.lightBackground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: AppColor.lightBackground,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColor.lightText.withOpacity(0.5)))
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: AppPadding.horizontal, right: AppPadding.horizontal),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedIconButton(
                          icon: appIconBack(color: AppColor.black, size: 25),
                          size: 45,
                          backgroundColor: Colors.transparent,
                          onTap: () => Get.back(),
                        ),

                        const SizedBox(width: 12,),

                        Expanded(
                          child: Text('Farms Status',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black)
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12,),

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    controller: farmsStatusController.searchTC,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorderFocused,
                      errorBorder: inputBorder,
                      focusedErrorBorder: inputBorderFocused,
                      filled: true,
                      fillColor: AppColor.white,
                      hintText: 'Search farmer name or farm reference',
                      hintStyle: TextStyle(color: AppColor.lightText, fontSize: 13),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: appIconSearch(color: AppColor.lightText, size: 15),
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (val){
                      farmsStatusController.pagingController.refresh();
                      // farmsStatusController.update();
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: GetBuilder(
                      init: farmsStatusController,
                      builder: (ctx) {
                        return PagedListView<int, FarmStatus>(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
                          pagingController: farmsStatusController.pagingController,
                          builderDelegate: PagedChildBuilderDelegate<FarmStatus>(
                              itemBuilder: (context, farmStatus, index){
                                return FarmStatusCard(
                                  farmStatus: farmStatus,
                                  onTap: (){},
                                );
                              },
                              noItemsFoundIndicatorBuilder: (context) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 50),
                                    Image.asset(
                                      'assets/images/cocoa_monitor/empty-box.png',
                                      width: 60,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      "No data found",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                          ),
                        );
                      }
                  ),
                ),

                /*Expanded(
                  child:  GetBuilder(
                    init: farmsStatusController,
                    builder: (context) {
                      return farmsStream(globalController, farmsStatusController);
                    }
                  ),
                )*/

              ],

            ),
          ),
        ),
      ),
    );
  }

  /*Widget farmsStream(GlobalController globalController, FarmsStatusController farmsStatusController) {
    final farmStatusDao = globalController.database!.farmStatusDao;
    return StreamBuilder<List<FarmStatus>>(
      // stream: farmStatusDao.findAllFarmStatusStream(),
      stream: farmsStatusController.searchTC!.text.isEmpty ? farmStatusDao.findAllFarmStatusStream() : farmStatusDao.streamAllFarmStatusWithNamesLike("%${farmsStatusController.searchTC!.text.toLowerCase()}%"),
      builder:
          (BuildContext context, AsyncSnapshot<List<FarmStatus>> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset('assets/gif/loading2.gif', height: 60),
          );
        } else if (snapshot.connectionState == ConnectionState.active
            || snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: const Text('Oops.. Something went wrong'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 10,),
                  ListView.builder(
                    padding: EdgeInsets.only(top: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        FarmStatus farmStatus = snapshot.data![index];
                        // return Text("haaa");
                        return FarmStatusCard(
                          farmStatus: farmStatus,
                          onTap: (){},
                        );
                      }),
                ],
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      'assets/images/cocoa_monitor/empty-box.png',
                      width: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "There is nothing to display here",
                      style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return Center(
            child: Image.asset('assets/gif/loading2.gif', height: 60),
          );
        }

      },
    );
  }*/

}
