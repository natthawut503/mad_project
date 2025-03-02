import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/model/GameSession.dart';
import 'package:account/provider/gameProvider.dart';

class EditScreen extends StatefulWidget {
  final GameSession gameSession;

  const EditScreen({Key? key, required this.gameSession}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _titleController;
  late int _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.gameSession.title);
    _selectedDifficulty = widget.gameSession.difficulty;
  }

  void _saveSession() {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final updatedSession = widget.gameSession.copyWith(
      title: _titleController.text,
      difficulty: _selectedDifficulty,
    );

    provider.updateGameSession(updatedSession);
    Navigator.pop(context);
  }

  void _deleteSession() {
    final provider = Provider.of<GameProvider>(context, listen: false);
    provider.deleteGameSession(widget.gameSession);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('แก้ไขเกมจำสี')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'ชื่อเกม'),
            ),
            DropdownButton<int>(
              value: _selectedDifficulty,
              items: List.generate(5, (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('ระดับ ${index + 1}'),
              )),
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSession,
              child: const Text('บันทึก'),
            ),
            TextButton(
              onPressed: _deleteSession,
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('ลบเกมนี้'),
            ),
          ],
        ),
      ),
    );
  }
}
