import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
part 'database.g.dart';

class Note extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().named('description')();
  IntColumn get priority => integer().nullable()();
  IntColumn get color => integer().nullable()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [Note])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<NoteData>> getNoteList() async {
    return select(note).get();
  }

  Future<void> insertNote(NoteCompanion note) async {
    into(this.note).insert(note);
  }

  Future<void> updateNote(NoteCompanion note) async {
    update(this.note).replace(note);
  }

  Future<void> deleteNoteById(int id) async {
    (delete(this.note)..where((tbl) => tbl.id.equals(id))).go();
  }
}
