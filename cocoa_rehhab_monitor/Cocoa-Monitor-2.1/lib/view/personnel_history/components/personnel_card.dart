import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:cocoa_monitor/view/global_components/round_icon_button.dart';
import 'package:cocoa_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

class PersonnelCard extends StatelessWidget {
  final Personnel personnel;
  final Function? onViewTap;
  final Function? onEditTap;
  final Function? onDeleteTap;
  final bool allowEdit;
  final bool allowDelete;
  const PersonnelCard({Key? key, required this.personnel, this.onViewTap, this.onEditTap, this.onDeleteTap, required this.allowEdit, required this.allowDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppButtonProps.borderRadius),
          boxShadow: const [BoxShadow(
            color: Color.fromRGBO(2, 41, 10, 0.08),
            blurRadius: 80,
            offset: Offset(0, -4),
          )]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(personnel.name ?? '',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColor.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                decoration: BoxDecoration(
                    color: AppColor.lightText,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md)
                ),
                child: Text(personnel.designation ?? '',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Container(
            height: 2,
            width: width * 0.05,
            color: AppColor.black.withOpacity(0.3),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(personnel.contact ?? '',
                style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.black)
              ),
              const SizedBox(width: 15),
              Text(personnel.submissionDate ?? '',
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColor.black)
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CircleIconButton(
                  icon: appIconEye(color: Colors.white, size: 17),
                  size: 45,
                  backgroundColor: AppColor.primary,
                  onTap: () => onViewTap!(),
                ),
              ),

              if (allowEdit)
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CircleIconButton(
                  icon: appIconEdit(color: Colors.white, size: 17),
                  size: 45,
                  backgroundColor: AppColor.black,
                  onTap: () => onEditTap!(),
                ),
              ),

              if(allowDelete)
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: CircleIconButton(
                  icon: appIconTrash(color: Colors.white, size: 17),
                  size: 45,
                  backgroundColor: Colors.red,
                  onTap: () => onDeleteTap!(),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}
