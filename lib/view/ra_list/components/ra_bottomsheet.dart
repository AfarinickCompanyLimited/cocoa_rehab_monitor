// ignore_for_file: avoid_print, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocoa_rehab_monitor/controller/constants.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';

import '../../../controller/model/rehab_assistant_model.dart';

class RABottomSheet extends StatelessWidget {
  final RehabAssistantModel rehabAssistant;
  const RABottomSheet({Key? key, required this.rehabAssistant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppBorderRadius.md),
              topRight: Radius.circular(AppBorderRadius.md)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 5, //spread radius
              blurRadius: 7, // blur radius
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: 4,
                decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.horizontal),
                      child: Center(
                        child: Text(
                          '${rehabAssistant.designation == PersonnelDesignation.rehabAssistant ? "RA " : rehabAssistant.designation == PersonnelDesignation.rehabTechnician ? "RT " : ""}Details',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    Center(
                      child: CachedNetworkImage(
                        imageUrl: "${rehabAssistant.image}",
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                            // shape: BoxShape.rectangle,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            // borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                        ),
                        placeholder: (context, url) => Image.asset(
                          'assets/images/user_avatar_default.png',
                          fit: BoxFit.cover,
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/user_avatar_default.png',
                          fit: BoxFit.cover,
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: SelectableText(
                        '${rehabAssistant.rehabName}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                        toolbarOptions: const ToolbarOptions(
                          copy: true,
                          selectAll: true,
                        ),
                        showCursor: true,
                        cursorWidth: 2,
                        cursorColor: Colors.red,
                        cursorRadius: const Radius.circular(5),
                      ),
                    ),

                    if (rehabAssistant.designation != null)
                      Divider(
                        indent: AppPadding.horizontal,
                        endIndent: AppPadding.horizontal,
                        height: 0,
                      ),
                    if (rehabAssistant.designation != null)
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        title: const Text(
                          'Staff Type',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        subtitle: Text(
                          '${rehabAssistant.designation}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),

                    if (rehabAssistant.staffId != null)
                      Divider(
                        indent: AppPadding.horizontal,
                        endIndent: AppPadding.horizontal,
                        height: 0,
                      ),

                    if (rehabAssistant.staffId != null)
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        title: const Text(
                          'Staff ID',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        subtitle: SelectableText(
                          '${rehabAssistant.staffId}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            selectAll: true,
                          ),
                          showCursor: true,
                          cursorWidth: 2,
                          cursorColor: Colors.red,
                          cursorRadius: const Radius.circular(5),
                        ),
                      ),

                    // Divider(
                    //     indent: AppPadding.horizontal,
                    //     endIndent: AppPadding.horizontal,
                    //   height: 0,
                    // ),
                    //
                    // ListTile(
                    //   contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                    //   title: Text(
                    //     'Code',
                    //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    //   ),
                    //   subtitle: Text(
                    //     '${rehabAssistant.rehabCode}',
                    //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    //   ),
                    // ),

                    Divider(
                      indent: AppPadding.horizontal,
                      endIndent: AppPadding.horizontal,
                      height: 0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: AppPadding.horizontal),
                      title: const Text(
                        'District',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${rehabAssistant.districtName}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),

                    Divider(
                      indent: AppPadding.horizontal,
                      endIndent: AppPadding.horizontal,
                      height: 0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Region',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${rehabAssistant.regionName}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),

                    if (rehabAssistant.phoneNumber != null &&
                        rehabAssistant.phoneNumber != "")
                      Divider(
                        indent: AppPadding.horizontal,
                        endIndent: AppPadding.horizontal,
                        height: 0,
                      ),

                    if (rehabAssistant.phoneNumber != null &&
                        rehabAssistant.phoneNumber != "")
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        title: const Text(
                          'Phone Number',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        subtitle: SelectableText(
                          '${rehabAssistant.phoneNumber}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            selectAll: true,
                          ),
                          showCursor: true,
                          cursorWidth: 2,
                          cursorColor: Colors.red,
                          cursorRadius: const Radius.circular(5),
                        ),
                      ),

                    // if (rehabAssistant.po != null && rehabAssistant.po != "")
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Project Officer',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: SelectableText(
                        '${rehabAssistant.rehabName} ${rehabAssistant.po}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 12),
                        toolbarOptions: const ToolbarOptions(
                          copy: true,
                          selectAll: true,
                        ),
                        showCursor: true,
                        cursorWidth: 2,
                        cursorColor: Colors.red,
                        cursorRadius: const Radius.circular(5),
                      ),
                    ),

                    if (rehabAssistant.salaryBankName != null &&
                        rehabAssistant.salaryBankName != "")
                      Divider(
                        indent: AppPadding.horizontal,
                        endIndent: AppPadding.horizontal,
                        height: 0,
                      ),
                    if (rehabAssistant.salaryBankName != null &&
                        rehabAssistant.salaryBankName != "")
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        title: const Text(
                          'Bank Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        subtitle: Text(
                          '${rehabAssistant.salaryBankName}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),

                    if (rehabAssistant.bankAccountNumber != null &&
                        rehabAssistant.bankAccountNumber != "")
                      Divider(
                        indent: AppPadding.horizontal,
                        endIndent: AppPadding.horizontal,
                        height: 0,
                      ),
                    if (rehabAssistant.bankAccountNumber != null &&
                        rehabAssistant.bankAccountNumber != "")
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        title: const Text(
                          'Account Number',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        subtitle: SelectableText(
                          '${rehabAssistant.bankAccountNumber}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            selectAll: true,
                          ),
                          showCursor: true,
                          cursorWidth: 2,
                          cursorColor: Colors.red,
                          cursorRadius: const Radius.circular(5),
                        ),
                      ),

                    if (rehabAssistant.ssnitNumber != null &&
                        rehabAssistant.ssnitNumber != "")
                      Divider(
                        indent: AppPadding.horizontal,
                        endIndent: AppPadding.horizontal,
                        height: 0,
                      ),
                    if (rehabAssistant.ssnitNumber != null &&
                        rehabAssistant.ssnitNumber != "")
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        title: const Text(
                          'SSNIT Number',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        subtitle: SelectableText(
                          '${rehabAssistant.ssnitNumber}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            selectAll: true,
                          ),
                          showCursor: true,
                          cursorWidth: 2,
                          cursorColor: Colors.red,
                          cursorRadius: const Radius.circular(5),
                        ),
                      ),

                    if (rehabAssistant.paymentOption != null &&
                        rehabAssistant.paymentOption != "")
                      Divider(
                        indent: AppPadding.horizontal,
                        endIndent: AppPadding.horizontal,
                        height: 0,
                      ),

                    if (rehabAssistant.paymentOption != null &&
                        rehabAssistant.paymentOption != "")
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        title: const Text(
                          'Payment Option',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        subtitle: Text(
                          '${rehabAssistant.paymentOption}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),

                    if (rehabAssistant.paymentOption == "momo" &&
                        (rehabAssistant.momoAccountName != null &&
                            rehabAssistant.momoAccountName != ""))
                      Divider(
                        indent: AppPadding.horizontal,
                        endIndent: AppPadding.horizontal,
                        height: 0,
                      ),
                    if (rehabAssistant.paymentOption == "momo" &&
                        (rehabAssistant.momoAccountName != null &&
                            rehabAssistant.momoAccountName != ""))
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        title: const Text(
                          'Momo Account Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        subtitle: Text(
                          '${rehabAssistant.momoAccountName}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),

                    if (rehabAssistant.paymentOption == "momo" &&
                        (rehabAssistant.momoNumber != null &&
                            rehabAssistant.momoNumber != ""))
                      Divider(
                        indent: AppPadding.horizontal,
                        endIndent: AppPadding.horizontal,
                        height: 0,
                      ),
                    if (rehabAssistant.paymentOption == "momo" &&
                        (rehabAssistant.momoNumber != null &&
                            rehabAssistant.momoNumber != ""))
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: AppPadding.horizontal),
                        title: const Text(
                          'Momo Number',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        subtitle: SelectableText(
                          '${rehabAssistant.momoNumber}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                          toolbarOptions: const ToolbarOptions(
                            copy: true,
                            selectAll: true,
                          ),
                          showCursor: true,
                          cursorWidth: 2,
                          cursorColor: Colors.red,
                          cursorRadius: const Radius.circular(5),
                        ),
                      ),

                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
