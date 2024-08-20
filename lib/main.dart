import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/bloc/app_bloc.dart';
import 'app/config/app_initializator.dart';
import 'core/di/injector.dart';
import 'expenses_tracker_app.dart';

void main() async {
  await initializeApp();
  runApp(
    BlocProvider(
      create: (_) => AppBloc(
        authRepository: getIt(),
        settingsRepository: getIt(),
      )..add(const AppEvent.initialized()),
      child: const ExpensesTrackerApp(),
    ),
  );
}
