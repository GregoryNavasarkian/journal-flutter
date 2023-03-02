import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/journal_entry.dart';

class JournalDatabase {
  static final JournalDatabase instance = JournalDatabase._init();
  // ignore: constant_identifier_names
  static const String CREATE_DB = 'assets/schema_1.sql.txt';

  static Database? _database;
  
  JournalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('journal.db');
    return _database!;
  }
  
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE $journal (
      ${JournalFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${JournalFields.title} TEXT NOT NULL,
      ${JournalFields.body} TEXT NOT NULL,
      ${JournalFields.rating} INTEGER NOT NULL
    )''');
  }

  Future<JournalEntry> create(JournalEntry journalEntry) async {
    final db = await instance.database;

    final id = await db.insert(journal, journalEntry.toJson());
    return journalEntry.copy(id: id);
  }

  Future<JournalEntry> readJournal(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      journal,
      columns: JournalFields.values,
      where: '${JournalFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return JournalEntry.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<JournalEntry>> readAllJournalEntries() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT * FROM $journal');
    return result.map( (json) => JournalEntry.fromJson(json)).toList();
  }

  Future<int> update(JournalEntry journalEntry) async {
    final db = await instance.database;

    return db.update(
      journal,
      journalEntry.toJson(),
      where: '${JournalFields.id} = ?',
      whereArgs: [journalEntry.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      journal,
      where: '${JournalFields.id} = ?',
      whereArgs: [id],
    );
  }
  
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
