import 'package:flutter/material.dart';
import 'package:parking/core/database/tables/table_app.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabase {
  static AppDatabase? _instance;
  AppDatabase._();
  static AppDatabase get instance => _instance ??= AppDatabase._();

  late final Database _db;
  late final BriteDatabase briteDb;

  Future<BriteDatabase> init() async {
    _db = await openDb();
    briteDb = BriteDatabase(_db);
    return briteDb;
  }

  Future<Database> openDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'parking.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(settingsTable);
        await db.execute(modelsTicket);
        await db.execute(orderTicket);

        final batch = db.batch();

        final list = await batch.commit(continueOnError: true, noResult: false);
        debugPrint('Batch result: $list');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {}
      },
    );
  }
}
