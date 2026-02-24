import '../entities/organization_entity.dart';

abstract class OrganizationRepository {
  Future<OrganizationEntity?> getOrganization(String id);
  Future<void> saveOrganization(OrganizationEntity organization);
  Future<OrganizationEntity?> getCurrentOrganization();
}
