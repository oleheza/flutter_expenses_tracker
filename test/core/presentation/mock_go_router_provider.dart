import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class MockGoRouterProvider extends StatelessWidget {
  final GoRouter mockGoRouter;
  final Widget child;

  const MockGoRouterProvider({
    super.key,
    required this.mockGoRouter,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InheritedGoRouter(
      goRouter: mockGoRouter,
      child: child,
    );
  }
}
