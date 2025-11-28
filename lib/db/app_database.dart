import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_item.dart';
import '../models/plan_entry.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _db;

  AppDatabase._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB("food_app.db");
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create 2 tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cost REAL NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE plan_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        foodName TEXT NOT NULL,
        foodCost REAL NOT NULL
      );
    ''');

    // Insert 20 default foods
    List<Map<String, dynamic>> defaultFoods = List.generate(20, (i) {
      return {
        'name': 'Food Item ${i + 1}',
        'cost': (5 + i).toDouble(),
      };
    });

    for (var item in defaultFoods) {
      await db.insert("food_items", item);
    }
  }

  // ---- FOOD CRUD ----
  Future<List<FoodItem>> getFoodItems() async {
    final db = await instance.database;
    final result = await db.query("food_items");
    return result.map((e) => FoodItem.fromMap(e)).toList();
  }

  Future<int> addFood(FoodItem item) async {
    final db = await instance.database;
    return await db.insert("food_items", item.toMap());
  }

  Future<int> updateFood(FoodItem item) async {
    final db = await instance.database;
    return await db.update("food_items", item.toMap(),
        where: "id = ?", whereArgs: [item.id]);
  }

  Future<int> deleteFood(int id) async {
    final db = await instance.database;
    return await db.delete("food_items", where: "id = ?", whereArgs: [id]);
  }

  // ---- PLAN CRUD ----
  Future<int> savePlan(PlanEntry entry) async {
    final db = await instance.database;
    return await db.insert("plan_entries", entry.toMap());
  }

  Future<List<PlanEntry>> getPlanByDate(String date) async {
    final db = await instance.database;
    final result = await db.query("plan_entries",
        where: "date = ?", whereArgs: [date]);
    return result.map((e) => PlanEntry.fromMap(e)).toList();
  }
}
