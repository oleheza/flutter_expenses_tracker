import 'package:expenses_tracker/core/presentation/widgets/stateful_cupertino_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../mocks/third_party_mocks.mocks.dart';
import '../cupertino_testable_widget.dart';
import 'robots/stateful_cupertino_segmented_control_robot.dart';

void main() {
  late GoRouter goRouter;

  setUp(() {
    goRouter = MockGoRouter();
  });

  Widget createTestableWidget(
    List<String> labels,
    List<String> tabTags,
    List<Widget> children,
  ) {
    return CupertinoTestableWidget(
      mockGoRouter: goRouter,
      child: StatefulCupertinoSegmentedControl(
        labels: labels,
        tabTags: tabTags,
        children: children,
      ),
    );
  }

  testWidgets(
    'test segmented control tabs switch is correct',
    (tester) async {
      final labels = <String>['label 1', 'label 2'];
      final tags = <String>['tag 1', 'tag 2'];
      final children = <Widget>[
        const Placeholder(),
        FilledButton(
          onPressed: () {},
          child: const Text('Button'),
        )
      ];

      await tester.pumpWidget(createTestableWidget(
        labels,
        tags,
        children,
      ));

      final robot = StatefulCupertinoSegmentedControlRobot(tester: tester);

      expect(find.text(labels[0]), findsOneWidget);
      expect(find.text(labels[1]), findsOneWidget);

      await robot.selectSegmentWithLabel(labels[1]);

      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(Placeholder), findsNothing);

      await robot.selectSegmentWithLabel(labels[0]);

      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(Placeholder), findsOneWidget);
    },
  );
}
