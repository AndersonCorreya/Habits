import 'package:habits_application/features/data/habit.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_states.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_events.dart';
import 'package:bloc/bloc.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  final List<Habit> _habits = [];

  HabitsBloc() : super(const HabitLoadingState()) {
    // Handle loading habits
    on<LoadHabits>((event, emit) {
      emit(HabitLoadingState());
      emit(HabitLoadedState(List.from(_habits)));
    });

    // Handle adding habits
    on<AddHabit>((event, emit) {
      _habits.add(event.habit);
      emit(HabitLoadedState(List.from(_habits)));
    });

    on<UpdateHabit>((event,emit){
      final index = _habits.indexWhere((h) => h.habitId == event.habit.habitId);
      if(index != -1){
        _habits[index] = event.habit;
        emit(HabitLoadedState(List.from(_habits)));

      }
      else{
        emit(const HabitErrorState('Habit not found'));
      }});

      on<DeleteHabit>((event, emit){
        _habits.removeWhere((h) => h.habitId == event.habitId);
        emit ( HabitLoadedState(List.from(_habits)));
      });
    }
}

