import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_rehab_monitor/view/global_components/text_input_decoration.dart';
import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:cocoa_rehab_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_rehab_monitor/view/ra_list/ra_list_controller.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controller/model/rehab_assistant_model.dart';
import 'components/ra_list_card.dart';

class RAList extends StatefulWidget {
  const RAList({Key? key}) : super(key: key);

  @override
  State<RAList> createState() => _RAListState();
}

class _RAListState extends State<RAList> with SingleTickerProviderStateMixin {
  RAListController raListController = Get.put(RAListController());
  GlobalController globalController = Get.find();

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    raListController.fetchData();
  }

  @override
  void dispose() {
    raListController.searchTC?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    raListController.rAListScreenContext = context;

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
                      border: Border(
                          bottom: BorderSide(
                              color: AppColor.lightText.withOpacity(0.5)))),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 15,
                        left: AppPadding.horizontal,
                        right: AppPadding.horizontal),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedIconButton(
                          icon: appIconBack(color: AppColor.black, size: 25),
                          size: 45,
                          backgroundColor: Colors.transparent,
                          onTap: () => Get.back(),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text('RA / RT List',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: TextFormField(
                    controller: raListController.searchTC,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      enabledBorder: inputBorder,
                      focusedBorder: inputBorderFocused,
                      errorBorder: inputBorder,
                      focusedErrorBorder: inputBorderFocused,
                      filled: true,
                      fillColor: AppColor.white,
                      hintText: 'Search name or staff ID',
                      hintStyle:
                      TextStyle(color: AppColor.lightText, fontSize: 13),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child:
                        appIconSearch(color: AppColor.lightText, size: 15),
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      // Refresh data when the search term changes
                      setState(() {
                        raListController.fetchData(searchTerm: value);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: FutureBuilder<List<RehabAssistantModel>>(
                    future: raListController.dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppPadding.horizontal),
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
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 20, top: 15),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final rehabAssistant = snapshot.data![index];
                            return RAListCard(
                              rehabAssistant: rehabAssistant,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                raListController.viewRA(rehabAssistant);
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}