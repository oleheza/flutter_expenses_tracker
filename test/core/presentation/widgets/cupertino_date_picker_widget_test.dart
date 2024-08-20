import 'package:expenses_tracker/core/presentation/widgets/cupertino_date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/third_party_mocks.mocks.dart';
import '../cupertino_testable_widget.dart';
import 'robots/cupertino_date_picker_widget_robot.dart';

void main() {
  late GoRouter goRouter;

  setUp(() {
    goRouter = MockGoRouter();
  });

  Widget createTestableWidget({
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required String confirmText,
    required String cancelText,
  }) {
    return CupertinoTestableWidget(
      mockGoRouter: goRouter,
      child: CupertinoDatePickerWidget(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  testWidgets(
    'test cancel button hides date picker',
    (tester) async {
      DateTime lastDate = DateTime.now();
      DateTime firstDate = lastDate.subtract(const Duration(days: 20));

      await tester.pumpWidget(createTestableWidget(
        firstDate: firstDate,
        lastDate: lastDate,
        confirmText: 'Confirm',
        cancelText: 'Cancel',
      ));

      final robot = CupertinoDatePickerWidgetRobot(tester: tester);

      await robot.clickCancelButton();
      verify(goRouter.pop()).called(1);
    },
  );
}
