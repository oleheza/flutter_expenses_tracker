import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'mock_go_router_provider.dart';

class TestableWidget extends StatelessWidget {
  final GoRouter mockGoRouter;
  final Widget child;

  const TestableWidget({
    super.key,
    required this.mockGoRouter,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    //debugDefaultTargetPlatformOverride = TargetPlatform.android;

    return MockGoRouterProvider(
      mockGoRouter: mockGoRouter,
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: child,
      ),
    );
  }
}
