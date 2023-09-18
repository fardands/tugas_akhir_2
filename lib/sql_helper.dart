import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE murid(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nama TEXT,
        kelas TEXT,
        sekolah TEXT,
        telp TEXT
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'les.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // buat murid
  static Future<int> createItem(
      String nama, String? kelas, String? sekolah, String? telp) async {
    final db = await SQLHelper.db();

    final data = {
      'nama': nama,
      'kelas': kelas,
      'sekolah': sekolah,
      'telp': telp
    };
    final id = await db.insert('murid', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // baca murid
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('murid', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('murid', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // update murid
  static Future<int> updateItem(
      int id, String nama, String? kelas, String? sekolah, String? telp) async {
    final db = await SQLHelper.db();

    final data = {
      'nama': nama,
      'kelas': kelas,
      'sekolah': sekolah,
      'telp': telp,
    };

    final result =
        await db.update('murid', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // yeet
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("murid", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
