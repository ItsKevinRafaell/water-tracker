class WaterIntakeModel {
  final DateTime date; // This should be serialized to a String
  double dailyGoal;
  double consumed;
  List<Map<String, dynamic>> intakeHistory; // Should be a List of Maps

  WaterIntakeModel({
    required this.date,
    required this.dailyGoal,
    this.consumed = 0,
    List<Map<String, dynamic>>? intakeHistory,
  }) : intakeHistory = intakeHistory ?? [];

  double get remaining => dailyGoal - consumed;

  bool get isGoalMet => consumed >= dailyGoal;

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(), // Correctly converts DateTime to String
      'dailyGoal': dailyGoal,
      'consumed': consumed,
      'intakeHistory':
          intakeHistory, // Ensure all items are Map<String, dynamic>
    };
  }

  factory WaterIntakeModel.fromJson(Map<String, dynamic> json) {
    return WaterIntakeModel(
      date: DateTime.parse(json['date']),
      dailyGoal: json['dailyGoal'],
      consumed: json['consumed'],
      intakeHistory:
          List<Map<String, dynamic>>.from(json['intakeHistory'] ?? []),
    );
  }
}

// Function to generate dummy data
List<WaterIntakeModel> generateDummyData() {
  return List<WaterIntakeModel>.generate(10, (index) {
    return WaterIntakeModel(
      date: DateTime.now().subtract(Duration(days: index)),
      dailyGoal: 2000 + index * 100,
      consumed: 1500 + index * 50,
      intakeHistory: List<Map<String, dynamic>>.generate(5, (i) {
        return {
          'time':
              DateTime.now().subtract(Duration(hours: i * 2)).toIso8601String(),
          'amount': 200 + i * 10,
        };
      }),
    );
  });
}
