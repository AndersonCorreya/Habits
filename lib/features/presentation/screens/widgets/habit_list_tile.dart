import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_application/features/data/habit.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_bloc.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_events.dart';
import 'package:habits_application/features/presentation/screens/widgets/edit_habit_dialog.dart';
import 'package:habits_application/features/presentation/screens/widgets/delete_confirmation_dialog.dart';

class HabitListTile extends StatelessWidget {
  final Habit habit;

  const HabitListTile({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 16, right: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: Color(0xFF606060),
        title: Text(
          habit.name,
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: habit.reminderTime != null
            ? Text(
                '⏱️ ${TimeOfDay.fromDateTime(habit.reminderTime!).format(context)}',
                style: TextStyle(color: Colors.white70),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => EditHabitDialog(habit: habit),
                );
              },
              icon: Icon(Icons.edit, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DeleteConfirmationDialog(habit: habit),
                );
              },
              icon: Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}