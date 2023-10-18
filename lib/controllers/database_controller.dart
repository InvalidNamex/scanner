import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner/constants.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/file_model.dart';

class DataBaseController extends GetxController {
  static DataBaseController instance = Get.find();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    List<Directory>? dbDirectory = await getExternalStorageDirectories();
    String dbString = dbDirectory![0].path;

    final path = join(dbString, filePath);
    final options = OpenDatabaseOptions(version: 1, onCreate: _createDB);
    return await databaseFactoryFfi.openDatabase(path, options: options);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';
    await db.execute('''
    CREATE TABLE file_table(
    file_id $idType,
    file_counter_code $intType,
    file_title $textType,
    file_subject $textType,
    file_link $textType,
    file_image $textType,
    file_date $textType
    )
    ''');
  }

  // create/insert into tables
  Future<FileModel> createFile(FileModel fileModel) async {
    final db = await instance.database;
    final id = await db.insert('file_table', fileModel.toJson());
    await homeController.populateFilesList();
    return fileModel.copy(fileId: id);
  }

  // read all records from table
  Future<List<FileModel>> readFiles() async {
    final db = await instance.database;
    // example of available options final result = await db.query(areasTable, where: );
    final result = await db.query('file_table');
    // final result = await db.rawQuery() <----- for sql queries
    return result.map((json) => FileModel.fromJson(json)).toList();
  }

  // update record
  Future updateFile(String value, int id, String field) async {
    final db = await instance.database;
    return db.rawUpdate(
        'UPDATE file_table SET $field = ? WHERE file_id = ?', [value, id]);
  }

  // delete record
  Future deleteFile(int id) async {
    final db = await instance.database;
    await db.delete('file_table', where: 'file_id = ?', whereArgs: [id]);
  }

  Future closeDatabase() async {
    final db = await instance.database;
    await db.close();
  }
}
