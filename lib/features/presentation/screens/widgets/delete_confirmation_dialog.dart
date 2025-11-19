import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_application/features/data/habit.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_bloc.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_events.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Habit habit;

  const DeleteConfirmationDialog({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Do you really want to delete this Habit?',
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      content: Row(
        children: [
          TextButton(
            onPressed: () {
              context.read<HabitsBloc>().add(DeleteHabit(habit.habitId));
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          Spacer(),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }
}