import 'package:flutter/material.dart';
import 'package:account/screens/colormemo.dart';
import 'package:account/screens/picmemo.dart';
import 'package:account/screens/game2048.dart';  // เพิ่ม import ไฟล์เกม 2048

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD6E0), Color(0xFFD6EEFF)], // ชมพูพาสเทล + ฟ้าพาสเทล
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            /// ข้อความซ้ายบน
            const Positioned(
              top: 20,
              left: 20,
              child: Text(
                '🧠 แบบฝึกหัดพัฒนาสมอง',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            /// เนื้อหาหลัก (ปุ่มเลือกเกม)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'เลือกเกมที่ต้องการเล่น',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ColorMemoScreen()),
                      );
                    },
                    child: const Text('🧠 เกมจำสี'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PicMemoScreen()),
                      );
                    },
                    child: const Text('🃏 เกมจับคู่ภาพ'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(200, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Game2048Screen()),
                      );
                    },
                    child: const Text('🔢 เกม 2048'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
