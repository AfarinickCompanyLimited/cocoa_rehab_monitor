import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/calculated_area.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'components/saved_area_card.dart';
import 'saved_area_calculations_controller.dart';

class SavedAreaCalculations extends StatefulWidget {
  const SavedAreaCalculations({super.key});

  @override
  State<SavedAreaCalculations> createState() => _SavedAreaCalculationsState();
}

class _SavedAreaCalculationsState extends State<SavedAreaCalculations> with SingleTickerProviderStateMixin {

  SavedAreaCalculationsController savedAreaCalculationsController = Get.put(SavedAreaCalculationsController());
  GlobalController globalController = Get.find();

 
  

  @override
  Widget build(BuildContext context) {

    savedAreaCalculationsController.savedAreaCalculationsScreenContext = context;

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
                          child: Text('Saved Area Calculations',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.black)
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child:  GetBuilder(
                    init: savedAreaCalculationsController,
                    builder: (context) {
                      return dataStream(globalController, savedAreaCalculationsController);
                    }
                  ),
                )

              ],

            ),
          ),
        ),
      ),
    );
  }


  Widget dataStream(GlobalController globalController, SavedAreaCalculationsController savedAreaCalculationsController) {
    final calculatedAreaDao = globalController.database!.calculatedAreaDao;
    return StreamBuilder<List<CalculatedArea>>(
      stream: calculatedAreaDao.findAllCalculatedAreaStream(),
      builder:
          (BuildContext context, AsyncSnapshot<List<CalculatedArea>> snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset('assets/gif/loading2.gif', height: 60),
          );
        } else if (snapshot.connectionState == ConnectionState.active
            || snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text('Oops.. Something went wrong'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 10,),
                  ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        CalculatedArea calculatedArea = snapshot.data![index];
                        // return Text("haaa");
                        return SavedAreaCard(
                          calculatedArea: calculatedArea,
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
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
  }


}
