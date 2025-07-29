import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urban_rest/constants/widgetConstants.dart';
import 'package:urban_rest/database/service/durationService.dart';
import 'package:urban_rest/database/service/transitionService.dart';
import 'package:urban_rest/model/duration_hour.dart';
import 'package:urban_rest/model/transition.dart';
import 'package:urban_rest/pages/splash_screen/animation_page.dart';
import 'package:urban_rest/providers/transition_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeData();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransitionProvider()..load()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urban Rest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AnimationPage(),
    );
  }
}

Future<void> initializeData() async {
  final prefs = await SharedPreferences.getInstance();

  await initializeDurationHours(prefs);
  await initializeTransitions(prefs);
}

Future<void> initializeDurationHours(SharedPreferences prefs) async {
  const key = 'duration_initialized';
  if (prefs.getBool(key) == true) return;

  final service = DurationHourService();
  final existing = await service.getDurationHours();

  if (existing.isEmpty) {
    int id = 1;
    for (var entry in Widgetconstants.durationOptions.entries) {
      await service.insertDurationHour(
        DurationHour(
          id: id++,
          key: entry.key,
          value: entry.value,
          status: DurationHour.ACTIVE,
        ),
      );
    }
  }

  await prefs.setBool(key, true);
}

Future<void> initializeTransitions(SharedPreferences prefs) async {
  const key = 'transition_initialized';
  if (prefs.getBool(key) == true) return;

  final service = Transitionservice();
  final existing = await service.getAllTransitions();

  if (existing.isEmpty) {
    for (int i = 0; i < Widgetconstants.transitionStyles.length; i++) {
      await service.insertTransition(
        Transition(
          id: i + 1,
          style: Widgetconstants.transitionStyles[i],
          isActive: i == 1 ? Transition.VALUE_YES : Transition.VALUE_NO,
        ),
      );
    }
  }

  await prefs.setBool(key, true);
}
