import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'mock_go_router_provider.dart';

class CupertinoTestableWidget extends StatefulWidget {
  final GoRouter mockGoRouter;
  final Widget child;

  const CupertinoTestableWidget({
    super.key,
    required this.mockGoRouter,
    required this.child,
  });

  @override
  State<CupertinoTestableWidget> createState() => _CupertinoTestableWidgetState();
}

class _CupertinoTestableWidgetState extends State<CupertinoTestableWidget> {



  @override
  Widget build(BuildContext context) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    return MockGoRouterProvider(
      mockGoRouter: widget.mockGoRouter,
      child: CupertinoApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: widget.child,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  }

  @override
  void dispose() {
    debugDefaultTargetPlatformOverride = null;
    super.dispose();
  }
}
