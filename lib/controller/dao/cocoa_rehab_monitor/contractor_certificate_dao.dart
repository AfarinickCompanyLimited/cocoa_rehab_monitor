import 'package:cocoa_rehab_monitor/controller/entity/cocoa_rehub_monitor/contractor_certificate.dart';
import 'package:floor/floor.dart';

@dao
abstract class ContractorCertificateDao {
  @Query('SELECT * FROM ContractorCertificate')
  Stream<List<ContractorCertificate>> findAllContractorCertificateStream();

  @Query('SELECT * FROM ContractorCertificate')
  Future<List<ContractorCertificate>> findAllContractorCertificate();

  @Query('SELECT * FROM ContractorCertificate WHERE status = :status')
  Stream<List<ContractorCertificate>> findContractorCertificateByStatusStream(
      int status);

  @Query(
      'SELECT * FROM ContractorCertificate WHERE status = :status LIMIT :limit OFFSET :offset')
  Future<List<ContractorCertificate>>
      findContractorCertificateByStatusWithLimit(
          int status, int limit, int offset);

  @Query('SELECT * FROM ContractorCertificate WHERE status = :status')
  Future<List<ContractorCertificate>> findContractorCertificateByStatus(
      int status);

  @Query('SELECT * FROM ContractorCertificate WHERE uid = :id')
  Future<List<ContractorCertificate>> findContractorCertificateByUID(String id);

  @Query('DELETE FROM ContractorCertificate WHERE uid = :id')
  Future<int?> deleteContractorCertificateByUID(String id);

  @delete
  Future<int?> deleteContractorCertificate(
      ContractorCertificate contractorCertificate);

  @Query('DELETE FROM ContractorCertificate')
  Future<void> deleteAllContractorCertificate();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertContractorCertificate(
      ContractorCertificate contractorCertificate);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> bulkInsertContractorCertificate(
      List<ContractorCertificate> contractorCertificateList);

  @Query('UPDATE ContractorCertificate SET status = :status WHERE uid = :id')
  Future<int?> updateContractorCertificateSubmissionStatusByUID(
      int status, String id);

  @update
  Future<void> updateContractorCertificate(
      ContractorCertificate contractorCertificate);
}
