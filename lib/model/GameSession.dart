class GameSession {
  int? keyID;
  String title;
  int difficulty;
  
  DateTime? date;

  GameSession({
    this.keyID,
    required this.title,
    required this.difficulty,
    
    this.date,
  });

  // เพิ่มเมธอด copyWith
  GameSession copyWith({
    int? keyID,
    String? title,
    int? difficulty,
    double? score,
    DateTime? date,
  }) {
    return GameSession(
      keyID: keyID ?? this.keyID,
      title: title ?? this.title,
      difficulty: difficulty ?? this.difficulty,
      
      date: date ?? this.date,
    );
  }
}
