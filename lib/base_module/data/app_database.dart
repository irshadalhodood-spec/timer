import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Local SQLite database for offline-first storage.
/// All attendance, org, employees, session and sync queue stored here.
class AppDatabase {
  static const _dbName = 'employee_track.db';
  static const _dbVersion = 3;

  static Database? _db;
  static final _lock = _DatabaseLock();

  static Future<Database> get database async {
    if (_db != null && _db!.isOpen) return _db!;
    return _lock.synchronized(() async {
      if (_db != null && _db!.isOpen) return _db!;
      _db = await _initDb();
      return _db!;
    });
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE attendances ADD COLUMN early_checkout_note TEXT');
      await db.execute('ALTER TABLE attendances ADD COLUMN is_early_checkout INTEGER DEFAULT 0');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE break_records ADD COLUMN start_address TEXT');
      await db.execute('ALTER TABLE break_records ADD COLUMN end_address TEXT');
    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE auth_session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        access_token TEXT NOT NULL,
        refresh_token TEXT,
        user_json TEXT NOT NULL,
        organization_id TEXT,
        organization_invite_url TEXT,
        expires_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE organization (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        logo_url TEXT,
        industry TEXT,
        registered_address TEXT,
        total_headcount INTEGER,
        departments_json TEXT,
        updated_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE employees (
        id TEXT PRIMARY KEY,
        org_id TEXT NOT NULL,
        full_name TEXT NOT NULL,
        job_title TEXT,
        department_id TEXT,
        department_name TEXT,
        email TEXT,
        phone TEXT,
        profile_photo_url TEXT,
        join_date TEXT,
        reporting_manager_id TEXT,
        is_online INTEGER DEFAULT 0,
        updated_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE attendances (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        check_in_at TEXT NOT NULL,
        check_out_at TEXT,
        check_in_lat REAL,
        check_in_lng REAL,
        check_in_address TEXT,
        check_out_lat REAL,
        check_out_lng REAL,
        check_out_address TEXT,
        break_seconds INTEGER DEFAULT 0,
        early_checkout_note TEXT,
        is_early_checkout INTEGER DEFAULT 0,
        device_info TEXT,
        synced INTEGER DEFAULT 0,
        synced_at TEXT,
        created_at TEXT,
        updated_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE break_records (
        id TEXT PRIMARY KEY,
        attendance_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        start_at TEXT NOT NULL,
        end_at TEXT,
        start_address TEXT,
        end_address TEXT,
        synced INTEGER DEFAULT 0,
        synced_at TEXT,
        created_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE sync_queue (
        id TEXT PRIMARY KEY,
        entity_type TEXT NOT NULL,
        action TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        created_at TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0,
        last_error TEXT,
        last_attempt_at TEXT
      )
    ''');
    await db.execute('''
      CREATE INDEX idx_attendances_user_id ON attendances(user_id)
    ''');
    await db.execute('''
      CREATE INDEX idx_attendances_check_in_at ON attendances(check_in_at)
    ''');
    await db.execute('''
      CREATE INDEX idx_sync_queue_created_at ON sync_queue(created_at)
    ''');
    await db.execute('''
      CREATE INDEX idx_employees_org_id ON employees(org_id)
    ''');
  }

  static Future<void> close() async {
    final db = _db;
    _db = null;
    if (db != null && db.isOpen) await db.close();
  }
}

class _DatabaseLock {
  Future<T> synchronized<T>(Future<T> Function() fn) => fn();
}
