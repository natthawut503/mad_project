import 'package:flutter/material.dart';

class PicMemoScreen extends StatefulWidget {
  const PicMemoScreen({super.key});

  @override
  State<PicMemoScreen> createState() => _PicMemoScreenState();
}

class _PicMemoScreenState extends State<PicMemoScreen> {
  List<String> images = [
    '🍎', '🍎',
    '🍌', '🍌',
    '🍒', '🍒',
    '🍇', '🍇',
    '🍍', '🍍',
    '🥝', '🥝'
  ];

  late List<bool> isFlipped;
  int? firstIndex;
  int? secondIndex;

  @override
  void initState() {
    super.initState();
    images.shuffle();
    isFlipped = List.generate(images.length, (index) => false);
  }

  void flipCard(int index) {
    if (isFlipped[index] || secondIndex != null) return;

    setState(() {
      isFlipped[index] = true;

      if (firstIndex == null) {
        firstIndex = index;
      } else {
        secondIndex = index;

        // เช็คคู่
        Future.delayed(const Duration(seconds: 1), checkMatch);
      }
    });
  }

  void checkMatch() {
    if (firstIndex != null && secondIndex != null) {
      if (images[firstIndex!] != images[secondIndex!]) {
        setState(() {
          isFlipped[firstIndex!] = false;
          isFlipped[secondIndex!] = false;
        });
      }

      firstIndex = null;
      secondIndex = null;
    }

    // ✅ เช็คว่าชนะครบทุกคู่หรือยัง
    if (isFlipped.every((element) => element == true)) {
      showWinDialog();
    }
  }

  void showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยินดีด้วยครับ!'),
        content: const Text('คุณจับคู่ภาพครบทั้งหมดแล้ว'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);  // กลับไปหน้าเลือกเกม
            },
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เกมจับคู่ภาพ'),
        backgroundColor: Colors.pink[200],  // สีชมพูพาสเทล
      ),
      backgroundColor: Colors.blue[50],  // สีพื้นหลังฟ้าพาสเทล
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => flipCard(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: isFlipped[index] ? Colors.pink[100] : Colors.blue[300],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // ตำแหน่งเงา
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  isFlipped[index] ? images[index] : '❓',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
