import 'package:cached_network_image/cached_network_image.dart';
import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/equipment.dart';
import 'package:cocoa_rehab_monitor/view/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EquipmentBottomSheet extends StatelessWidget {
  final Equipment equipment;
  const EquipmentBottomSheet({Key? key, required this.equipment}) : super(key: key);

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
          borderRadius: BorderRadius.only(topLeft: Radius.circular(AppBorderRadius.md), topRight: Radius.circular(AppBorderRadius.md)),
          boxShadow:[
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
                      padding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                      child: const Center(
                        child: Text('Equipment Details',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    Center(
                      child: CachedNetworkImage(
                        imageUrl:  "${equipment.picEquipment}",
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                          height: size.width * 0.8,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                            // shape: BoxShape.rectangle,
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Image.asset('assets/images/image_placeholder.png', fit: BoxFit.cover,
                              height: size.width * 0.8,
                              width: size.width * 0.8,
                            ),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/image_placeholder.png', fit: BoxFit.cover,
                              height: size.width * 0.8,
                              width:  size.width * 0.8,
                            ),
                      ),
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Equipment',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${equipment.equipment}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),

                    Divider(
                      indent: AppPadding.horizontal,
                      endIndent: AppPadding.horizontal,
                      height: 0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Code',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${equipment.equipmentCode}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),

                    Divider(
                      indent: AppPadding.horizontal,
                      endIndent: AppPadding.horizontal,
                      height: 0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Serial Number',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${equipment.serialNumber}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),

                    Divider(
                      indent: AppPadding.horizontal,
                      endIndent: AppPadding.horizontal,
                      height: 0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Manufacturer',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${equipment.manufacturer}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),

                    Divider(
                      indent: AppPadding.horizontal,
                      endIndent: AppPadding.horizontal,
                      height: 0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${equipment.status}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),

                    Divider(
                      indent: AppPadding.horizontal,
                      endIndent: AppPadding.horizontal,
                      height: 0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Staff',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: Text(
                        '${equipment.staffName}',
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),

                    Divider(
                      indent: AppPadding.horizontal,
                      endIndent: AppPadding.horizontal,
                      height: 0,
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: AppPadding.horizontal),
                      title: const Text(
                        'Date Captured',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      subtitle: Text(
                        DateFormat('yMMMMEEEEd').format(equipment.dateOfCapturing),
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                      ),
                    ),


                    const SizedBox(height: 10),

                    Center(
                      child: CachedNetworkImage(
                        imageUrl:  "${equipment.picSerialNumber}",
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                          height:  size.width * 0.8,
                          width:  size.width * 0.8,
                          decoration: BoxDecoration(
                            // shape: BoxShape.rectangle,
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                        ),
                        placeholder: (context, url) =>
                            Image.asset('assets/images/image_placeholder.png', fit: BoxFit.cover,
                              height: size.width * 0.8,
                              width:  size.width * 0.8,
                            ),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/image_placeholder.png', fit: BoxFit.cover,
                              height:  size.width * 0.8,
                              width:  size.width * 0.8,
                            ),
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
