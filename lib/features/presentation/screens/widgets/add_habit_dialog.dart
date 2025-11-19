import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_application/features/data/habit.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_bloc.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_events.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  late TextEditingController controller;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Habit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: controller,
            decoration: InputDecoration(hintText: 'Habit Name'),
            autofocus: true,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(selectedTime == null
                  ? 'No time set'
                  : selectedTime!.format(context)),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      selectedTime = picked;
                    });
                  }
                },
                child: const Text('Pick Time'),
              )
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              // Convert TimeOfDay to DateTime for today
              DateTime? reminderDateTime;
              if (selectedTime != null) {
                final now = DateTime.now();
                reminderDateTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );
              }
              final newHabit = Habit(
                habitId: DateTime.now().toString(),
                name: name,
                reminderTime: reminderDateTime,
              );
              context.read<HabitsBloc>().add(AddHabit(newHabit));
            }
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}