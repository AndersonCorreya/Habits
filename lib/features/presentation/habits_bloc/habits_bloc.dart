import 'package:habits_application/features/data/habit.dart';
import 'package:habits_application/features/data/habit_repository.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_states.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_events.dart';
import 'package:bloc/bloc.dart';
import 'package:habits_application/features/core/notification_service.dart';

class HabitsBloc extends Bloc<HabitsEvent, HabitsState> {
  final List<Habit> _habits = [];
  final NotificationService _notificationService = NotificationService();
  final HabitRepository _repository = HabitRepository();

  HabitsBloc() : super(const HabitLoadingState()) {
    // Handle loading habits - NOW LOADS FROM HIVE!
    on<LoadHabits>((event, emit) async {
      emit(HabitLoadingState());
      try {
        final loadedHabits = _repository.loadHabits();
        _habits.clear();
        _habits.addAll(loadedHabits);
        
        // Sync notifications: Cancel all and reschedule only for current habits
        await _notificationService.cancelAllNotifications();
        for (final habit in _habits) {
          if (habit.reminderTime != null) {
            await _notificationService.scheduleHabitReminder(
              habitId: habit.habitId,
              habitName: habit.name,
              reminderTime: habit.reminderTime!,
            );
          }
        }
        
        emit(HabitLoadedState(List.from(_habits)));
      } catch (e) {
        emit(HabitErrorState('Failed to load habits: $e'));
      }
    });

    // Handle adding habits - NOW SAVES TO HIVE!
    on<AddHabit>((event, emit) async {
      try {
        _habits.add(event.habit);
        await _repository.addHabit(event.habit);

        if(event.habit.reminderTime != null){
          await _notificationService.scheduleHabitReminder(
            habitId: event.habit.habitId, 
            habitName: event.habit.name, 
            reminderTime: event.habit.reminderTime!
          );
        }
        emit(HabitLoadedState(List.from(_habits)));
      } catch (e) {
        emit(HabitErrorState('Failed to add habit: $e'));
      }
    });

    // Handle updating habits - NOW UPDATES IN HIVE!
    on<UpdateHabit>((event, emit) async {
      try {
        final index = _habits.indexWhere((h) => h.habitId == event.habit.habitId);
        if(index != -1){
          await _notificationService.cancelHabitReminder(event.habit.habitId);
          _habits[index] = event.habit;
          await _repository.updateHabit(event.habit);

          if (event.habit.reminderTime != null) {
            await _notificationService.scheduleHabitReminder(
              habitId: event.habit.habitId,
              habitName: event.habit.name,
              reminderTime: event.habit.reminderTime!,
            );
          }
          emit(HabitLoadedState(List.from(_habits)));
        }
        else{
          emit(const HabitErrorState('Habit not found'));
        }
      } catch (e) {
        emit(HabitErrorState('Failed to update habit: $e'));
      }
    });

    // Handle deleting habits - NOW DELETES FROM HIVE!
    on<DeleteHabit>((event, emit) async {
      try {
        await _notificationService.cancelHabitReminder(event.habitId);
        _habits.removeWhere((h) => h.habitId == event.habitId);
        await _repository.deleteHabit(event.habitId);
        emit(HabitLoadedState(List.from(_habits)));
      } catch (e) {
        emit(HabitErrorState('Failed to delete habit: $e'));
      }
    });
  }
}