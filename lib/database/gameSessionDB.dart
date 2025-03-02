import 'dart:io';
import 'package:account/model/GameSession.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class GameSessionDB {
  final String dbName = 'gameSessions_v2.db';

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertGameSession(GameSession gameSession) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('gameSessions');

    int keyID = await store.add(db, {
      'title': gameSession.title,
      'difficulty': gameSession.difficulty,
      
      'date': gameSession.date?.toIso8601String(),
    });

    await db.close();
    return keyID;
  }

  Future<List<GameSession>> loadAllGameSessions() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('gameSessions');

    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder('date', false)]));

    List<GameSession> gameSessions = [];

    for (var record in snapshot) {
      GameSession gameSession = GameSession(
        keyID: record.key,
        title: record['title'].toString(),
        difficulty: record['difficulty'] as int,
        
        date: DateTime.parse(record['date'].toString()),
      );
      gameSessions.add(gameSession);
    }

    await db.close();
    return gameSessions;
  }

  Future<void> deleteGameSession(int keyID) async {  // แก้ตรงนี้
    var db = await openDatabase();
    var store = intMapStoreFactory.store('gameSessions');

    await store.delete(
      db,
      finder: Finder(filter: Filter.equals(Field.key, keyID)),
    );

    await db.close();
  }

  Future<void> updateGameSession(GameSession gameSession) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('gameSessions');

    await store.update(
      db,
      {
        'title': gameSession.title,
        'difficulty': gameSession.difficulty,
        
        'date': gameSession.date?.toIso8601String(),
      },
      finder: Finder(filter: Filter.equals(Field.key, gameSession.keyID)),
    );

    await db.close();
  }
}
