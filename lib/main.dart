import 'package:flutter/material.dart';
import 'package:habits_application/features/core/notification_service.dart';
import 'package:habits_application/features/data/habit.dart';
import 'package:habits_application/features/data/hive_adapter.dart';
import 'package:habits_application/features/presentation/screens/habits_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_bloc.dart';
import 'package:habits_application/features/presentation/habits_bloc/habits_events.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
    await Hive.initFlutter();

  // Register adapter
  Hive.registerAdapter(HabitAdapter());

  // Open the box
  await Hive.openBox<Habit>('habits');
  runApp(
    BlocProvider(
      create: (_) => HabitsBloc()..add(LoadHabits()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        fontFamily: 'SanFrancisco'
      ),
      home: const HabitsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


