import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // init table
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE murid(
        id_murid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nama TEXT,
        kelas TEXT,
        sekolah TEXT,
        telp TEXT
      )
      """);
    await database.execute("""CREATE TABLE aktivitas(
        id_aktivitas INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        id_murid INTEGER,
        aktivitas TEXT,
        aktivitasDesc TEXT,
        tanggal TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  //init db
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

  // buat aktivitas
  static Future<int> createAct(
      int idMurid, String aktivitas, String? aktivitasDesc) async {
    final db = await SQLHelper.db();
    final data = {
      'id_murid': idMurid,
      'aktivitas': aktivitas,
      'aktivitasDesc': aktivitasDesc,
    };
    final id = await db.insert('aktivitas', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // get murid
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query(
      'murid',
      orderBy: "id_murid",
    );
  }

  //get aktivitas
  static Future<List<Map<String, dynamic>>> getAct(int id) async {
    final db = await SQLHelper.db();
    return db.query(
      'aktivitas',
      where: "id_murid = ?",
      whereArgs: [id],
      orderBy: 'id_aktivitas',
    );
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
        await db.update('murid', data, where: "id_murid = ?", whereArgs: [id]);
    return result;
  }

  // update aktivitas
  static Future<int> updateAct(
      int id, String aktivitas, String? aktivitasDesc) async {
    final db = await SQLHelper.db();

    final data = {
      'aktivitas': aktivitas,
      'aktivitasDesc': aktivitasDesc,
    };

    final result = await db
        .update('aktivitas', data, where: "id_aktivitas = ?", whereArgs: [id]);
    return result;
  }

  // yeet
  static Future<void> deleteItem(String table, int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(table, where: "id_$table = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
