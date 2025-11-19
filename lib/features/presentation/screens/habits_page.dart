import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_bloc.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_states.dart';
import 'package:habits_application/features/presentation/screens/widgets/habit_list_tile.dart';
import 'package:habits_application/features/presentation/screens/widgets/add_habit_dialog.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      appBar: AppBar(
        title: Text(
          'Habits Application',
          style: TextStyle(
            fontFamily: 'StackSans',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF2D2D2D),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HabitsBloc, HabitsState>(
          builder: (context, state) {
            if (state is HabitLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is HabitLoadedState) {
              if (state.habits.isEmpty) {
                return const Center(
                  child: Text(
                    'No Habits',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: state.habits.length,
                itemBuilder: (context, index) {
                  final habit = state.habits[index];
                  return HabitListTile(habit: habit);
                },
              );
            } else if (state is HabitErrorState) {
              return Center(child: Text(state.error));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (dialogContext) => AddHabitDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}