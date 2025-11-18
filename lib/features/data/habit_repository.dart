import 'package:hive/hive.dart';
import 'package:habits_application/features/data/habit.dart';

class HabitRepository {
  static const String _boxName = 'habits';

  // Get the Hive box
  Box<Habit> _getBox() {
    return Hive.box<Habit>(_boxName);
  }

  // Load all habits from Hive
  List<Habit> loadHabits() {
    final box = _getBox();
    return box.values.toList();
  }

  // Add a habit to Hive
  Future<void> addHabit(Habit habit) async {
    final box = _getBox();
    await box.put(habit.habitId, habit); // Use habitId as key
  }

  // Update a habit in Hive
  Future<void> updateHabit(Habit habit) async {
    final box = _getBox();
    await box.put(habit.habitId, habit);
  }

  // Delete a habit from Hive
  Future<void> deleteHabit(String habitId) async {
    final box = _getBox();
    await box.delete(habitId);
  }

  // Clear all habits (optional)
  Future<void> clearAllHabits() async {
    final box = _getBox();
    await box.clear();
  }
}