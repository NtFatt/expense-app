import 'app_database.dart';

AppDatabase? _sharedAppDatabase;

AppDatabase getSharedAppDatabase() {
  return _sharedAppDatabase ??= AppDatabase();
}
