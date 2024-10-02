import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

class PersonnelOptionsBottomSheet extends StatelessWidget {
  final Personnel personnel;
  const PersonnelOptionsBottomSheet({Key? key, required this.personnel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.sm), topRight: Radius.circular(AppBorderRadius.sm)),
        ),
        padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(
                height: 20,
              ),

              Center(
                child: Container(
                  height: 6,
                  width: 48,
                  decoration: BoxDecoration(
                      color: AppColor.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24)
                  ),
                )
              ),

              const SizedBox(
                height: 25,
              ),

              ListTile(
                onTap: (){},
                title: const Text('View'),
                leading: appIconHome(size: 24),
              ),

              const SizedBox(
                height: 40,
              ),

            ]
        )
    );
  }
}
