import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:habits_application/features/data/habit.dart';


@immutable
abstract class HabitsState extends Equatable{
  const HabitsState();

}

class HabitLoadingState extends HabitsState{
  const HabitLoadingState();
  @override

  List<Object> get props => [];
}

class HabitLoadedState extends HabitsState{
  final List<Habit> habits;
  const HabitLoadedState(this.habits);
    @override

  List<Object> get props => [habits];
}

class HabitErrorState extends HabitsState{
  final String error;
  const HabitErrorState(this.error);
    @override

  List<Object> get props => [error];
}

class HabitOperationSuccess extends HabitsState{
  const HabitOperationSuccess();
    @override

  List<Object> get props => [];
}