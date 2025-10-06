class DataFormat {
  final int userId;
  final int id;
  final String title;
  final String body;

  
  final int initialDuration;
  int remainingDuration;
  bool isVisible;
  bool isPaused;

  DataFormat({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    required this.initialDuration,
    required this.remainingDuration,
    this.isVisible = false,
    this.isPaused = false,
  });

  factory DataFormat.fromJson(Map<String, dynamic> json) {
    final random = [10, 20, 25]..shuffle();
    final randTime = random.first;
    return DataFormat(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
      initialDuration: randTime,
      remainingDuration: randTime,
    );
  }
  DataFormat copyWith({
    int? remainingDuration,
    bool? isVisible,
    bool? isPaused,
  }) {
    return DataFormat(
      userId: userId,
      id: id,
      title: title,
      body: body,
      initialDuration: initialDuration,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      isVisible: isVisible ?? this.isVisible,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}
