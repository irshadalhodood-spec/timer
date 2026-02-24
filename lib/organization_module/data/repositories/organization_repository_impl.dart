import '../../domain/entities/organization_entity.dart';
import '../../../auth_module/domain/repositories/auth_repository.dart';
import '../../domain/repositories/organization_repository.dart';
import '../datasources/organization_local_datasource.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  OrganizationRepositoryImpl({
    OrganizationLocalDatasource? local,
    AuthRepository? authRepository,
  })  : _local = local ?? OrganizationLocalDatasource(),
        _auth = authRepository;

  final OrganizationLocalDatasource _local;
  final AuthRepository? _auth;

  @override
  Future<OrganizationEntity?> getOrganization(String id) =>
      _local.getOrganization(id);

  @override
  Future<void> saveOrganization(OrganizationEntity organization) =>
      _local.saveOrganization(organization);

  @override
  Future<OrganizationEntity?> getCurrentOrganization() async {
    final session = _auth != null ? await _auth.getSession() : null;
    final orgId = session?.organizationId ?? 'local_org';
    return _local.getOrganization(orgId);
  }
}
