import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../../base_module/data/app_database.dart';
import '../../domain/entities/organization_entity.dart';

class OrganizationLocalDatasource {
  Future<OrganizationEntity?> getOrganization(String id) async {
    final db = await AppDatabase.database;
    final rows = await db.query('organization', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return _rowToEntity(rows.first as Map<String, dynamic>);
  }

  static OrganizationEntity _rowToEntity(Map<String, dynamic> row) {
    List<DepartmentEntity> departments = const [];
    final deptJson = row['departments_json'] as String?;
    if (deptJson != null && deptJson.isNotEmpty) {
      try {
        final list = jsonDecode(deptJson) as List<dynamic>;
        departments = list.map((e) => DepartmentEntity.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    return OrganizationEntity(
      id: row['id'] as String,
      name: row['name'] as String,
      logoUrl: row['logo_url'] as String?,
      industry: row['industry'] as String?,
      registeredAddress: row['registered_address'] as String?,
      totalHeadcount: row['total_headcount'] as int?,
      departments: departments,
    );
  }

  Future<void> saveOrganization(OrganizationEntity organization) async {
    final db = await AppDatabase.database;
    final deptJson = jsonEncode(organization.departments.map((e) => e.toJson()).toList());
    await db.insert('organization', {
      'id': organization.id,
      'name': organization.name,
      'logo_url': organization.logoUrl,
      'industry': organization.industry,
      'registered_address': organization.registeredAddress,
      'total_headcount': organization.totalHeadcount,
      'departments_json': deptJson,
      'updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
