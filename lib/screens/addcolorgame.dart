import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/gameProvider.dart';
import '../model/GameSession.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _titleController = TextEditingController();
  int _selectedDifficulty = 1;

  void _saveSession() {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final newSession = GameSession(
      title: _titleController.text,
      difficulty: _selectedDifficulty,
    );
    provider.addGameSession(newSession);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มเกมจำสี'),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'ชื่อเกมจำสี',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _selectedDifficulty,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(5, (index) => index + 1)
                      .map((level) => DropdownMenuItem(
                    value: level,
                    child: Text('ระดับ: $level'),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDifficulty = value!;
                    });
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  ),
                  onPressed: _saveSession,
                  child: const Text('บันทึก', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
