import 'dart:async';
import 'dart:typed_data';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/activity_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/assigned_farm_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/assigned_outbreak_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/calculated_area_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/cocoa_age_class_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/cocoa_type_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/community_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/equipment_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/farm_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/farm_status_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/farmer_from_server_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/initial_treatment_fuel_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/initial_treatment_monitor_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/maintenance_fuel_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/map_farm_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/notification_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/outbreak_farm_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/outbreak_farm_from_server_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/personnel_assignment_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/personnel_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/po_location_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/region_district_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/rehab_assistant_dao.dart';
import 'package:cocoa_monitor/controller/dao/cocoa_rehab_monitor/society_dao.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/activity.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/assigned_farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/assigned_outbreak.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/calculated_area.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/cocoa_age_class.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/cocoa_type.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/community.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/equipment.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farm_status.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/farmer_from_server.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_fuel.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/initial_treatment_monitor.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/maintenance_fuel.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/map_farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/notification_data.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/outbreak_farm_from_server.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/personnel_assignment.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/po_location.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/region_district.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/rehab_assistant.dart';
import 'package:cocoa_monitor/controller/entity/cocoa_rehub_monitor/society.dart';
import 'package:cocoa_monitor/controller/utils/datetime_intlist_converter.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/cocoa_rehab_monitor/contractor_certificate_dao.dart';
import '../dao/cocoa_rehab_monitor/contractor_certificate_verification_dao.dart';
import '../dao/cocoa_rehab_monitor/contractor_dao.dart';
import '../entity/cocoa_rehub_monitor/contractor.dart';
import '../entity/cocoa_rehub_monitor/contractor_certificate.dart';
import '../entity/cocoa_rehub_monitor/contractor_certificate_verification.dart';

part 'database.g.dart';

@TypeConverters([DateTimeConverter, IntListConverter])
@Database(version: 1, entities: [
  Activity,
  Farm,
  Personnel,
  RegionDistrict,
  RehabAssistant,
  Contractor,
  PersonnelAssignment,
  FarmStatus,
  AssignedFarm,
  NotificationData,
  AssignedOutbreak,
  Community,
  CocoaType,
  CocoaAgeClass,
  OutbreakFarm,
  CalculatedArea,
  PoLocation,
  InitialTreatmentMonitor,
  ContractorCertificate,
  OutbreakFarmFromServer,
  MaintenanceFuel,
  InitialTreatmentFuel,
  Equipment,
  ContractorCertificateVerification,
  MapFarm,
  Society,
  FarmerFromServer,
])
abstract class AppDatabase extends FloorDatabase {
  ActivityDao get activityDao;
  FarmDao get farmDao;
  PersonnelDao get personnelDao;
  RegionDistrictDao get regionDistrictDao;
  RehabAssistantDao get rehabAssistantDao;
  ContractorDao get contractorDao;
  PersonnelAssignmentDao get personnelAssignmentDao;
  FarmStatusDao get farmStatusDao;
  AssignedFarmDao get assignedFarmDao;
  NotificationDao get notificationDao;
  AssignedOutbreakDao get assignedOutbreakDao;
  CommunityDao get communityDao;
  CocoaTypeDao get cocoaTypeDao;
  CocoaAgeClassDao get cocoaAgeClassDao;
  OutbreakFarmDao get outbreakFarmDao;
  CalculatedAreaDao get calculatedAreaDao;
  POLocationDao get poLocationDao;
  InitialTreatmentMonitorDao get initialTreatmentMonitorDao;
  ContractorCertificateDao get contractorCertificateDao;
  OutbreakFarmFromServerDao get outbreakFarmFromServerDao;
  MaintenanceFuelDao get maintenanceFuelDao;
  InitialTreatmentFuelDao get initialTreatmentFuelDao;
  EquipmentDao get equipmentDao;
  ContractorCertificateVerificationDao get contractorCertificateVerificationDao;
  MapFarmDao get mapFarmDao;
  SocietyDao get societyDao;
  FarmerFromServerDao get farmerFromServerDao;
}
