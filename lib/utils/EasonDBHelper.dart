import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EasonDBHelper {
  static Database? _database;
  static late String _dbName;
  static late String _tableName;
  static late String _createTableSQL;

  /// 初始化：外部传入数据库名称、表名和建表 SQL
  static Future<void> init({
    required String dbName,
    required String tableName,
    required String createTableSQL,
  }) async {
    _dbName = dbName;
    _tableName = tableName;
    _createTableSQL = createTableSQL;
    _database = await _initDB(_dbName);
  }

  // 获取数据库实例
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  // 初始化数据库
  static Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // 创建表：使用外部传入的 SQL
  static Future _createDB(Database db, int version) async {
    await db.execute(_createTableSQL);
  }

  // 插入数据
  static Future<int> insert(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(_tableName, data);
  }

  // 更新数据
  static Future<int> update(int id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(_tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  // 删除数据
  static Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // 查询所有数据
  static Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await database;
    return await db.query(_tableName);
  }

  // 关闭数据库
  static Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}