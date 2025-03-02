import 'package:flutter/material.dart';
import 'package:account/model/GameSession.dart';
import 'package:account/database/gameSessionDB.dart';

class GameProvider with ChangeNotifier {
  List<GameSession> gameSessions = [];

  Future<void> initData() async {
    var db = GameSessionDB();
    gameSessions = await db.loadAllGameSessions();
    notifyListeners();
  }

  List<GameSession> getGameSessions() {
    return gameSessions;
  }

  Future<void> addGameSession(GameSession gameSession) async {
    var db = GameSessionDB();
    int newKeyID = await db.insertGameSession(gameSession);  // ดึง keyID กลับมา
    gameSession.keyID = newKeyID;  // เซ็ต keyID ให้ object ใน List ด้วย

    gameSessions.add(gameSession);
    gameSessions.sort((a, b) => a.difficulty.compareTo(b.difficulty));
    notifyListeners();
  }

  Future<void> updateGameSession(GameSession gameSession) async {
    var db = GameSessionDB();
    await db.updateGameSession(gameSession);

    int index = gameSessions.indexWhere((element) => element.keyID == gameSession.keyID);
    if (index != -1) {
      gameSessions[index] = gameSession;
    }

    gameSessions.sort((a, b) => a.difficulty.compareTo(b.difficulty));
    notifyListeners();
  }

  Future<void> deleteGameSession(GameSession gameSession) async {
    if (gameSession.keyID == null) {
      debugPrint("❌ keyID is null, cannot delete this session.");
      return;
    }

    var db = GameSessionDB();
    await db.deleteGameSession(gameSession.keyID!);
    gameSessions.removeWhere((element) => element.keyID == gameSession.keyID);
    notifyListeners();
  }
}
