import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/gameProvider.dart';
// import 'package:account/model/GameSession.dart';
import 'package:account/screens/addcolorgame.dart';
import 'package:account/screens/colorEditScreen.dart';
import 'package:account/screens/colorplayscreen.dart';

class ColorMemoScreen extends StatelessWidget {
  const ColorMemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<GameProvider>(context);
    var gameSessions = provider.getGameSessions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('เกมจำสี'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD6EEFF), Color(0xFFFFD6E0)], // ฟ้า-ชมพูพาสเทล
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            itemCount: gameSessions.length,
            itemBuilder: (context, index) {
              var session = gameSessions[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: Colors.white,
                  title: Text(
                    session.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'ระดับ: ${session.difficulty}',
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow, color: Colors.blueAccent),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlayScreen(session: session)),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditScreen(gameSession: session)),
                          );
                        },
                      ),
                    ],
                  ),
                  onLongPress: () {
                    provider.deleteGameSession(session);
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
