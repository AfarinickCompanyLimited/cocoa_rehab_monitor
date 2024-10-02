import 'package:floor/floor.dart';

import '../../entity/cocoa_rehub_monitor/contractor_certificate_verification.dart';

@dao
abstract class ContractorCertificateVerificationDao {
  @Query('SELECT * FROM ContractorCertificateVerification')
  Stream<List<ContractorCertificateVerification>> findAllContractorCertificateVerificationStream();

  @Query('SELECT * FROM ContractorCertificateVerification')
  Future<List<ContractorCertificateVerification>> findAllContractorCertificateVerification();

  @Query('SELECT * FROM ContractorCertificateVerification WHERE status = :status')
  Stream<List<ContractorCertificateVerification>> findContractorCertificateVerificationByStatusStream(
      int status);

  @Query(
      'SELECT * FROM ContractorCertificateVerification WHERE status = :status LIMIT :limit OFFSET :offset')
  Future<List<ContractorCertificateVerification>>
      findContractorCertificateVerificationByStatusWithLimit(
          int status, int limit, int offset);

  @Query('SELECT * FROM ContractorCertificateVerification WHERE status = :status')
  Future<List<ContractorCertificateVerification>> findContractorCertificateVerificationByStatus(
      int status);

  @Query('SELECT * FROM ContractorCertificateVerification WHERE uid = :id')
  Future<List<ContractorCertificateVerification>> findContractorCertificateVerificationByUID(String id);

  @Query('DELETE FROM ContractorCertificateVerification WHERE uid = :id')
  Future<int?> deleteContractorCertificateVerificationByUID(String id);

  @delete
  Future<int?> deleteContractorCertificateVerification(
      ContractorCertificateVerification contractorCertificateVerification);

  @Query('DELETE FROM ContractorCertificateVerification')
  Future<void> deleteAllContractorCertificateVerification();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertContractorCertificateVerification(
      ContractorCertificateVerification contractorCertificateVerification);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertContractorCertificateVerification(
      List<ContractorCertificateVerification> contractorCertificateVerificationList);

  @Query('UPDATE ContractorCertificateVerification SET status = :status WHERE uid = :id')
  Future<int?> updateContractorCertificateVerificationSubmissionStatusByUID(
      int status, String id);

  @update
  Future<void> updateContractorCertificateVerification(
      ContractorCertificateVerification contractorCertificateVerification);
}
