import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_application/features/data/habit.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_bloc.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_events.dart';

class EditHabitDialog extends StatefulWidget {
  final Habit habit;

  const EditHabitDialog({
    super.key,
    required this.habit,
  });

  @override
  State<EditHabitDialog> createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
  late TextEditingController controller;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.habit.name);
    selectedTime = widget.habit.reminderTime != null
        ? TimeOfDay.fromDateTime(widget.habit.reminderTime!)
        : null;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Habit'),
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
                    initialTime: selectedTime ?? TimeOfDay.now(),
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
              // Convert TimeOfDay to DateTime
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

              // Create updated habit with same ID
              final updatedHabit = Habit(
                habitId: widget.habit.habitId, // Keep the same ID!
                name: name,
                reminderTime: reminderDateTime,
              );

              // Dispatch update event
              context.read<HabitsBloc>().add(UpdateHabit(updatedHabit));
            }
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        )
      ],
    );
  }
}