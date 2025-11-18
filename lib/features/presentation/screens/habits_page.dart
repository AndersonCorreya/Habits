import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_application/features/data/habit.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_bloc.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_events.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_states.dart';


class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      appBar: AppBar(title: Text('Habits Application', style: TextStyle(fontFamily: 'StackSans', fontSize: 16, color: Colors.white),), backgroundColor: Color(0xFF2D2D2D),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<HabitsBloc,HabitsState>(builder: (context, state){
          if(state is HabitLoadingState){
            return const Center(child: CircularProgressIndicator(),);
          }else if (state is HabitLoadedState){
            if(state.habits.isEmpty){
              return const Center(
                child: Text('No Habits', style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.w600)),
              );
            }
          
          return ListView.builder(itemCount: state.habits.length,
          itemBuilder: (context,index){
            final habit = state.habits[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
              contentPadding: EdgeInsets.only(left: 16,right: 0),
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
          showDialog(context: context, builder: (dialogContext){
            final TextEditingController controller = TextEditingController(text: habit.name);
            TimeOfDay? selectedTime = habit.reminderTime != null ? TimeOfDay.fromDateTime(habit.reminderTime!) : null;
            return StatefulBuilder(builder: (context, setState){
              return AlertDialog(
                title: const Text('Edit Habit'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                    textCapitalization: TextCapitalization.words,
                controller: controller,
                decoration: InputDecoration(hintText: 'Habit Name'),
                autofocus: true,
              ),
              SizedBox(height: 16,),
              Row(
                    children: [
                      Text(selectedTime == null 
                          ? 'No time set' 
                          : selectedTime!.format(context)),
                      const SizedBox(width: 8),
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
                        habitId: habit.habitId,  // Keep the same ID!
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
            });


          });

          
        },
        icon: Icon(Icons.edit, color: Colors.white),
      ),
      IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Do you really want to delete this Habit?',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                content: TextButton(
                  onPressed: () {
                    context.read<HabitsBloc>().add(DeleteHabit(habit.habitId));
                    Navigator.pop(context);
                  },
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              );
            },
          );
        },
        icon: Icon(Icons.delete, color: Colors.white),
      ),
    ],
  ),
),
            );

        
          },);
        }else if(state is HabitErrorState){
          return Center(child: Text(state.error),);
        
        }
        return const SizedBox.shrink();
        }),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (dialogContext){
          TimeOfDay? selectedTime;
          final TextEditingController controller = TextEditingController();
          return StatefulBuilder(
            builder: (context, setState){
            return AlertDialog(
              title: const Text('Add Habit'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    textCapitalization: TextCapitalization.words,
                controller: controller,
                decoration: InputDecoration(hintText: 'Habit Name'),
                autofocus: true,
              ),
              SizedBox(height: 16,),
              Row(
                children: [
                  Text(selectedTime == null ? 'No time set' : selectedTime!.format(context)),
                  Spacer(),
                  ElevatedButton(onPressed: () async{
                    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (picked != null){
                      setState((){  
                        selectedTime = picked;
                      });
                    }
                  }, child: const Text('Pick Time'))
            
                ],
              )
                ],
              ),
              
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: const Text('Cancel')),
                ElevatedButton(onPressed: (){
                  final name = controller.text.trim();
                  if(name.isNotEmpty){
                    // Convert TimeOfDay to DateTime for today
                    DateTime? reminderDateTime;
                    if(selectedTime != null){
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
                }, child: const Text('Add')
            )],
            );},
          );
        });
      },
      child: const Icon(Icons.add),),
    );
  }
}