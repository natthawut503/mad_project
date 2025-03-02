import 'package:account/model/GameSession.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PlayScreen extends StatefulWidget {
  final GameSession session;

  const PlayScreen({Key? key, required this.session}) : super(key: key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  List<Color> colors = [];
  List<int> sequence = [];
  int currentStep = 0;
  bool isPlayerTurn = false;

  int highlightedIndex = -1;
  int? pressedIndex; // เพิ่มตัวแปรเก็บสถานะการกดปุ่ม

  @override
  void initState() {
    super.initState();
    colors = getColorsForLevel(widget.session.difficulty);
    generateSequence(widget.session.difficulty);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        showSequence();
      }
    });
  }

  List<Color> getColorsForLevel(int difficulty) {
    List<Color> baseColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.brown
    ];
    return baseColors.take(4 + (difficulty - 1)).toList();
  }

  void generateSequence(int level) {
    int colorCount = colors.length;
    sequence = [];

    var rng = Random();
    for (int i = 0; i < level + 2; i++) {
      sequence.add(rng.nextInt(colorCount));
    }
  }

  void showSequence() async {
    if (!mounted) return;
    setState(() {
      isPlayerTurn = false;
    });

    for (var colorIndex in sequence) {
      if (!mounted) return;
      setState(() {
        highlightedIndex = colorIndex;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      setState(() {
        highlightedIndex = -1;
      });

      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (!mounted) return;
    setState(() {
      isPlayerTurn = true;
      currentStep = 0;
    });
  }

  void handlePlayerTap(int index) {
    if (!isPlayerTurn) return;

    setState(() {
      pressedIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        pressedIndex = null;
      });

      if (sequence[currentStep] == index) {
        setState(() {
          currentStep++;
        });

        if (currentStep >= sequence.length) {
          showResultDialog(true);
        }
      } else {
        showResultDialog(false);
      }
    });
  }

  void showResultDialog(bool isWin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isWin ? "ยินดีด้วย!" : "ผิดพลาด!"),
        content: Text(isWin ? "คุณผ่านเลเวลนี้แล้ว" : "ลองใหม่อีกครั้งนะ"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isWin) {
                Navigator.pop(context);
              } else {
                showSequence();
              }
            },
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  Widget buildColorButton(int index) {
    bool isHighlighted = highlightedIndex == index;
    bool isPressed = pressedIndex == index;  // ตรวจสอบว่าปุ่มไหนถูกกด

    return GestureDetector(
      onTap: () => handlePlayerTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: isPressed ? 90 : (isHighlighted ? 110 : 100),
        height: isPressed ? 90 : (isHighlighted ? 110 : 100),
        decoration: BoxDecoration(
          color: isPressed
              ? colors[index].withOpacity(0.6)
              : colors[index],
          border: Border.all(
            color: isHighlighted ? Colors.white : Colors.transparent,
            width: isHighlighted ? 6 : 0,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isHighlighted || isPressed)
              const BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              )
          ],
        ),
        margin: const EdgeInsets.all(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เล่นเกม: ${widget.session.title}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD6EEFF), Color(0xFFFFD6E0)], // ฟ้าพาสเทล -> ชมพูพาสเทล
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'เลเวล: ${widget.session.difficulty}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(colors.length, (index) => buildColorButton(index)),
                ),
                if (!isPlayerTurn)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'กำลังแสดงลำดับสี...',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
