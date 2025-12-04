import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ScanHistoryDatabase {
  static final ScanHistoryDatabase instance = ScanHistoryDatabase._init();
  static Database? _database;

  ScanHistoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scan_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scan_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        classification TEXT NOT NULL,
        ai_description TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // Insert a new scan record
  Future<int> insertScan({
    required String imagePath,
    required String classification,
    required String aiDescription,
  }) async {
    final db = await database;
    return await db.insert('scan_history', {
      'image_path': imagePath,
      'classification': classification,
      'ai_description': aiDescription,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Get all scan history (newest first)
  Future<List<Map<String, dynamic>>> getAllScans() async {
    final db = await database;
    return await db.query(
      'scan_history',
      orderBy: 'timestamp DESC',
    );
  }

  // Get scan by id
  Future<Map<String, dynamic>?> getScan(int id) async {
    final db = await database;
    final results = await db.query(
      'scan_history',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    return results.isNotEmpty ? results.first : null;
  }

  // Get scans by classification
  Future<List<Map<String, dynamic>>> getScansByClassification(String classification) async {
    final db = await database;
    return await db.query(
      'scan_history',
      where: 'classification = ?',
      whereArgs: [classification],
      orderBy: 'timestamp DESC',
    );
  }

  // Get scans by date range
  Future<List<Map<String, dynamic>>> getScansByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    return await db.query(
      'scan_history',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'timestamp DESC',
    );
  }

  // Update a scan
  Future<int> updateScan(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      'scan_history',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a scan
  Future<int> deleteScan(int id) async {
    final db = await database;
    return await db.delete(
      'scan_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    final db = await database;
    await db.delete('scan_history');
  }

  // Get total count
  Future<int> getCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM scan_history');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Close database
  Future close() async {
    final db = await _database;
    db?.close();
  }
}

// Model class for easier data handling
class ScanRecord {
  final int? id;
  final String imagePath;
  final String classification;
  final String aiDescription;
  final DateTime timestamp;

  ScanRecord({
    this.id,
    required this.imagePath,
    required this.classification,
    required this.aiDescription,
    required this.timestamp,
  });

  // Convert from database map
  factory ScanRecord.fromMap(Map<String, dynamic> map) {
    return ScanRecord(
      id: map['id'] as int?,
      imagePath: map['image_path'] as String,
      classification: map['classification'] as String,
      aiDescription: map['ai_description'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  // Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'image_path': imagePath,
      'classification': classification,
      'ai_description': aiDescription,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}