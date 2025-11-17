import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habits_application/features/data/habit.dart';




@immutable
abstract class HabitsEvent extends Equatable {
  const HabitsEvent();
} 


class LoadHabits extends HabitsEvent {
  const LoadHabits();
  @override
  List<Object> get props => [];
}


class AddHabit extends HabitsEvent {
  final Habit habit;
  const AddHabit(this.habit);
  @override
  List<Object> get props => [habit];
}


class UpdateHabit extends HabitsEvent {
  final Habit habit;
  const UpdateHabit(this.habit);
  @override
  List<Object> get props => [habit];
}


class DeleteHabit extends HabitsEvent {
  final String habitId;
  const DeleteHabit(this.habitId);
  @override
  List<Object> get props => [habitId];
}


class SetHabitReminder extends HabitsEvent {
  final String habitId;
  final TimeOfDay reminderTime;
  const SetHabitReminder({required this.habitId, required this.reminderTime});
  @override
  List<Object> get props => [habitId, reminderTime];
}


// events that happen in the app
// get the habits, add a habit, delete a habit, edit a habit, set a reminder in habit, toggle completion of a habit