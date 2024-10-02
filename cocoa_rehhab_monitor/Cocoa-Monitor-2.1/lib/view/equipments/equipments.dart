import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/equipment.dart';
import 'package:cocoa_monitor/view/equipments/components/equipment_card.dart';
import 'package:cocoa_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_monitor/controller/global_controller.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'equipments_controller.dart';


class EquipmentList extends StatefulWidget {
  const EquipmentList({Key? key}) : super(key: key);

  @override
  State<EquipmentList> createState() => _EquipmentListState();
}

class _EquipmentListState extends State<EquipmentList> with SingleTickerProviderStateMixin {

  EquipmentsController equipmentsController = Get.put(EquipmentsController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();

    equipmentsController.pagingController.addPageRequestListener((pageKey) {
      equipmentsController.fetchData(pageKey: pageKey, controller: equipmentsController.pagingController);
    });

  }

  @override
  void dispose() {
    equipmentsController.pagingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    equipmentsController.context = context;

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
                          child: Text('Equipments',
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
                    controller: equipmentsController.searchTC,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorderFocused,
                      errorBorder: inputBorder,
                      focusedErrorBorder: inputBorderFocused,
                      filled: true,
                      fillColor: AppColor.white,
                      hintText: 'Search equipment name or code',
                      hintStyle: TextStyle(color: AppColor.lightText, fontSize: 13),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: appIconSearch(color: AppColor.lightText, size: 15),
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (val){
                      equipmentsController.pagingController.refresh();
                      // equipmentsController.update();
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: GetBuilder(
                      init: equipmentsController,
                      builder: (ctx) {
                        return PagedListView<int, Equipment>(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 15),
                          pagingController: equipmentsController.pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Equipment>(
                              itemBuilder: (context, farmStatus, index){
                                return EquipmentCard(
                                  equipment: farmStatus,
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
                    init: equipmentsController,
                    builder: (context) {
                      return farmsStream(globalController, equipmentsController);
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

  /*Widget farmsStream(GlobalController globalController, equipmentsController equipmentsController) {
    final farmStatusDao = globalController.database!.farmStatusDao;
    return StreamBuilder<List<Equipment>>(
      // stream: farmStatusDao.findAllFarmStatusStream(),
      stream: equipmentsController.searchTC!.text.isEmpty ? farmStatusDao.findAllFarmStatusStream() : farmStatusDao.streamAllFarmStatusWithNamesLike("%${equipmentsController.searchTC!.text.toLowerCase()}%"),
      builder:
          (BuildContext context, AsyncSnapshot<List<Equipment>> snapshot) {

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
                        Equipment farmStatus = snapshot.data![index];
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
