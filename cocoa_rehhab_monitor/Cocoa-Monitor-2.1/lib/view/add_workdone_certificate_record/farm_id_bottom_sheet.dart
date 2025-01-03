// ignore_for_file: avoid_print, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/entity/cocoa_rehub_monitor/assigned_farm.dart';
import '../../controller/global_controller.dart';
import '../utils/style.dart';
import 'add_workdone_record_controller.dart';

class FarmIdBottomSheet extends StatefulWidget {
  const FarmIdBottomSheet({Key? key}) : super(key: key);

  @override
  _FarmIdBottomSheetState createState() => _FarmIdBottomSheetState();
}

class _FarmIdBottomSheetState extends State<FarmIdBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<AssignedFarm> _filteredFarms = [];
  List<AssignedFarm> _allFarms = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFarms(String query) {
    setState(() {
      _filteredFarms = _allFarms.where((farm) {
        final farmReference = farm.farmReference?.toLowerCase() ?? '';
        final location = farm.location?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return farmReference.contains(searchLower) || location.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.find();
    final AddContractorCertificateRecordController addWorkdoneRecordController =
    Get.put(AddContractorCertificateRecordController());

    final assignedFarmDao = globalController.database?.assignedFarmDao;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 5, // Spread radius
              blurRadius: 7, // Blur radius
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search by Farm Reference or Location",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColor.lightText.withOpacity(0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      width: 1,
                      color: AppColor.primary,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      width: 0.5,
                      color: AppColor.primary,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: AppColor.primary,
                    ),

                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _filterFarms, // Filter the farms in real-time
              ),
            ),
            FutureBuilder<List<AssignedFarm>>(
              future: assignedFarmDao?.findAllAssignedFarms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primary,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  print("Error fetching farms: ${snapshot.error}");
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  _allFarms = snapshot.data ?? [];
                  _filteredFarms = _filteredFarms.isEmpty ? _allFarms : _filteredFarms;

                  return Expanded(
                    child: _filteredFarms.isEmpty
                        ? Center(
                      child: Text(
                        'No farms available.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _filteredFarms.length,
                      itemBuilder: (context, index) {
                        final farm = _filteredFarms[index];
                        return ListTile(
                          title: Text(farm.farmReference ?? "Unknown Farm"),
                          subtitle: Text(farm.location ?? "Unknown Location"),
                          onTap: () {
                            // Update the text fields in the controller with the selected farm data
                            addWorkdoneRecordController
                                .farmReferenceNumberTC
                                ?.text = farm.farmReference ?? "";
                            addWorkdoneRecordController.farmSizeTC?.text =
                                farm.farmSize ?? "";
                            addWorkdoneRecordController.communityTC?.text =
                                farm.location ?? "";
                           // addWorkdoneRecordController.farmerNameTC?.text = farm.farmername ?? "";

                            // Close the bottom sheet
                            Get.back();
                          },
                        );
                      },
                    ),
                  );
                }

                return Center(
                  child: Text(
                    'No data available.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
