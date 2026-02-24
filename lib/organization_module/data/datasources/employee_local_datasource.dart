import 'package:sqflite/sqflite.dart';
import '../../../base_module/data/app_database.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeLocalDatasource {
  static EmployeeEntity _rowToEntity(Map<String, dynamic> row) {
    return EmployeeEntity(
      id: row['id'] as String,
      fullName: row['full_name'] as String,
      jobTitle: row['job_title'] as String?,
      departmentId: row['department_id'] as String?,
      departmentName: row['department_name'] as String?,
      email: row['email'] as String?,
      phone: row['phone'] as String?,
      profilePhotoUrl: row['profile_photo_url'] as String?,
      joinDate: row['join_date'] != null ? DateTime.tryParse(row['join_date'] as String) : null,
      reportingManagerId: row['reporting_manager_id'] as String?,
      isOnline: (row['is_online'] as int?) == 1,
    );
  }

  static Map<String, Object?> _entityToRow(EmployeeEntity e, String orgId) {
    return {
      'id': e.id,
      'org_id': orgId,
      'full_name': e.fullName,
      'job_title': e.jobTitle,
      'department_id': e.departmentId,
      'department_name': e.departmentName,
      'email': e.email,
      'phone': e.phone,
      'profile_photo_url': e.profilePhotoUrl,
      'join_date': e.joinDate?.toIso8601String(),
      'reporting_manager_id': e.reportingManagerId,
      'is_online': e.isOnline ? 1 : 0,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  Future<List<EmployeeEntity>> getEmployeesByOrg(String orgId, {String? departmentId, String? search}) async {
    final db = await AppDatabase.database;
    String where = 'org_id = ?';
    List<Object?> args = [orgId];
    if (departmentId != null && departmentId.isNotEmpty) {
      where += ' AND department_id = ?';
      args.add(departmentId);
    }
    if (search != null && search.isNotEmpty) {
      where += ' AND (full_name LIKE ? OR job_title LIKE ?)';
      args.add('%$search%');
      args.add('%$search%');
    }
    final rows = await db.query('employees', where: where, whereArgs: args, orderBy: 'full_name ASC');
    return rows.map((r) => _rowToEntity(r as Map<String, dynamic>)).toList();
  }

  Future<EmployeeEntity?> getEmployeeById(String id) async {
    final db = await AppDatabase.database;
    final rows = await db.query('employees', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;
    return _rowToEntity(rows.first as Map<String, dynamic>);
  }

  Future<void> saveEmployees(List<EmployeeEntity> employees, String orgId) async {
    if (employees.isEmpty) return;
    final db = await AppDatabase.database;
    final batch = db.batch();
    for (final e in employees) {
      batch.insert('employees', _entityToRow(e, orgId), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> saveEmployee(EmployeeEntity employee, String orgId) async {
    final db = await AppDatabase.database;
    await db.insert('employees', _entityToRow(employee, orgId), conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
