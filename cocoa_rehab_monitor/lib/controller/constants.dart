// ignore_for_file: non_constant_identifier_names

import 'package:cocoa_rehab_monitor/controller/global_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String googlePlacesApiKey = 'AIzaSyB-I85PyI0Hn_73pLQnZnF2I-lY2erlXoQ';
// final String googlePlacesApiKey = 'AIzaSyBTFoUzCdhGIfUZTHy52TjwwMeKIQ77Sjs';

const String debugModePasscode = '0248823823';

class URLs {
  // static String baseUrl = 'https://be0e-102-176-10-212.eu.ngrok.io';
  static String baseUrl = Get.find<GlobalController>().serverUrl;
  // static String baseUrl = 'https://e441-41-155-5-26.ngrok-free.app';
  // static String baseUrl = 'https://cocoarehabmonitor.com';
  // static String baseUrl = 'https://35.80.124.218';
  static String addPersonnel = '/api/v1/saveregister/';
  static String loadRegionDistricts = '/api/v1/regiondistricts/';
  static String loadContractors = '/api/v1/fetchallcontractors/';
  //todo: change to the correct url
  static String submitLeave = '/api/v1/leave/';
  static String loadActivities = '/api/v1/activity/';
  static String loadFarms = '/api/v1/farms/';
  static String loadJobOrderFarms = '/api/v1/fetchjoborder/';
  static String loadRehabAssistants = '/api/v1/fetchrehabassistants/';
  static String loadPaginatedRehabAssistants =
      '/rehabassistantslist_drf/?page=';

  static String saveMonitoring = '/api/v1/savemonitoringform/';
  static String saveObMonitoring = '/api/v1/saveobmonitoringform/';
  static String saveContractorCertificate =
      '/api/v1/saveContractorcertificateofworkdone/';

  static String saveContractorCertificateVerification =
      '/api/v1/saveverificationfarms/';
  static String saveAllMonitorings = '/api/v1/saveactivityreport/';
  static String assignPersonnel = '/api/v1/saverehabasssignment/';
  static String updateFirebaseToken = '/api/v1/updatefirebase/';
  static String loadFarmStatus = '/api/v1/fetchfarmstatus/';
  static String loadAssignedFarms = '/api/v1/fetchpoassignedfarms/';
  static String loadCocoaTypes = '/api/v1/fetchcocoatype/';
  static String loadCocoaAgeClass = '/api/v1/cocoaageclass/';
  static String loadCommunities = '/api/v1/fetchcommunity/';
  static String loadAssignedOutbreaks = '/api/v1/fetchoutbreak/';
  static String loadEquipments = '/api/v1/fetchallequipment/';
  static String loadInitialTreatmentFarms = '/api/v1/fetchoutbreafarmslist/';
  static String saveOutbreakFarm = '/api/v1/saveoutbreakfarm/';
  static String loadOutbreakCSV = '/api/v1/fetchoutbreakcsv/';
  static String savePOLocation = '/api/v1/savepomonitoring/';
  static String saveMaintenanceFuel = '/api/v1/savemaintenancefuel/';
  static String saveInitialTreatmentFuel = '/api/v1/saveobfuel/';
  static String sendIssue = '/api/v1/savefeedback/';
  static String loadAllIssues = '/api/v1/fetchallfeedback/';
  static String versionCheck = '/api/v1/version/';

  static String loadPayments = '/api/v1/fetchpayments/';
  static String loadDetailedPaymentReport =
      '/api/v1/fetchpaymentdetailedreport/';

  static String modulesEndpoint = '/endpoint/v1/utils/get-app-modules';
  static String lookupUserAccount = '/api/v2/auth/login/';
  static String createAccount = '/endpoint/v1/user/create-account';
  static String resetPassword = '/api/v1/auth/reset-password/';
  static String changePassword = '/api/v1/auth/changepasword/';
  static String updateUserInfo = '/endpoint/v1/user/update-details';
  static String changeProfilePicture = '/endpoint/v1/user/upload-profile';
  static String getUserInfo = '/endpoint/v1/user/get-user-profile';
  static String setNotificationToken =
      '/endpoint/v1/user/update-notification-token';
  static String updateProfilePhoto = '/endpoint/v1/user/upload-profile';
  static String updateAccountDetails = '/endpoint/v1/user/update-details';

  static String getIDTypes = '/endpoint/v1/utils/get-national-it-types';

  static String getActiveNews = '/endpoint/v1/news/get-active-news';

  static String getRegionDistrictConstituency =
      '/endpoint/v1/utils/get-all-regional-info';

  // WAI==============================
  static String getLocationInfo = '/endpoint/v1/wai/location-info';
  // WAI==============================

  // TMT ============================
  static String getTreeSpecies = '/endpoint/v1/tmt/get-tree-species';
  static String confirmSeedlingReceipt =
      '/endpoint/v1/tmt/complete-seedling-request-cycle';
  static String requestSeedling = '/endpoint/v1/tmt/request-for-seedlings';
  static String getUserRequests = '/endpoint/v1/tmt/get-user-seedling-requests';
  static String tagNewTree = '/endpoint/v1/tmt/post-tree-tags';
  static String getUserTreeTags = '/endpoint/v1/tmt/get-user-tree-tagging';
  static String getPublicTreeTags = '/endpoint/v1/tmt/get-public-tree-tags';
  static String getTreeTagDetails = '/endpoint/v1/tmt/get-tree-tag-details';
  static String clapOperation = '/endpoint/v1/tmt/tree-tag-clap-operation';
  static String postTagComment = '/endpoint/v1/tmt/post-tree-tag-comment';

  static String getStatSeedlingRequest =
      '/endpoint/v1/tmt/get-seedling-request-stats';
  // TMT ============================

  // TrueKing added
  static String saveFarm = '/api/v1/savefarm/';
  static String mapFarm = '/api/v1/savemappedfarm/';
}

class FileType {
  static String image = "Image";
  static String video = "Video";
  static String audio = "Audio";
}

class PersonnelDesignation {
  // static String projectOfficer = "Project Officer";
  static String rehabAssistant = "Rehab Assistant";
  static String rehabTechnician = "Rehab Technician";
  // static String districtManager = "District Manager";
}

class MaritalStatus {
  static String married = "Married";
  static String single = "Single";
  static String widowed = "Widowed";
  static String divorced = "Divorced";
  static String separated = "Separated";
}

class EducationLevel {
  static String primary = "Primary School";
  static String juniorHigh = "Junior High School";
  static String seniorHigh = "Senior High School";
  static String tertiary = "Tertiary Institution";
  static String none = "None";
}

class PaymentMethod {
  static String bank = "Bank Payment";
  static String mobileMoney = "Mobile Money";
}

class YesNo {
  static String yes = "Yes";
  static String no = "No";
}

class TaskStatus {
  static String pending = "Pending";
  static String ongoing = "Ongoing";
  static String completed = "Completed";
}

// Weeding, Hacking and Slashing, Portage, Planting, Holing, Cutting
class FarmActivities {
  static String weeding = "Weeding";
  static String planting = "Planting";
  static String holing = "Holing";
  static String cutting = "Cutting";
  static String hackingSlashing = "Hacking and Slashing";
}

class PersonnelImageData {
  static String personnelImage = "PersonnelImage";
  static String idImage = "IDImage";
  static String sSNITCardImage = "SSNITCardImage";
}

class SubmissionStatus {
  static int pending = 0;
  static int submitted = 1;
}

class RequestStatus {
  static int False = 0;
  static int True = 1;
  static int Exist = 2;
  static int NoInternet = 3;
}

class HomeMenuItem {
  static String OutbreakFarm = "OutbreakFarm";
  static String Monitoring = "Maintenance";
  static String Personnel = "Personnel";
  static String AssignPersonnel = "AssignPersonnel";
  static String report = "report";
  // static String detailedReport = "detailedReport";
  // static String issuesReport = "issuesReport";
}

class AllMonitorings {
  static String InitialTreatment = "InitialTreatment";
  static String Maintenance = "Maintenance";
  static String Establishment = "Establishment";
}

// TrueKing added
class MapFarms {
  static String mapFarm = "MapFarms";
}

class MaxLocationAccuracy {
  static double max = 30;
}

class MainActivities {
  static String Establishment = "Establishment";
  static String InitialTreatment = "Initial Treatment";
  static String Maintenance = "Maintenance";
}

class Build {
  static int buildNumber = 12;
  // static double buildNumber = 11.1; // TrueKing changed
}

class ShareP {
  static SharedPreferences? preferences;
}
