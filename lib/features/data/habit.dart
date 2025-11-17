class Habit {
  final String habitId;
  final String name;
  final String? description;
  final DateTime? reminderTime;
  final bool isCompleted;

  Habit({
    required this.habitId,
    required this.name,
    this.description,
    this.isCompleted = false,
    this.reminderTime
  });

}