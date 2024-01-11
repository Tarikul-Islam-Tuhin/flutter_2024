import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bs23_flutter_task/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'end to end test',
    () {
      testWidgets(
        'verfiy ListViewScreen Found',
        (tester) async {
          app.main();
          await tester
              .pumpAndSettle(); // wait until there are no more frames to execute

          expect(find.byType(ListView), findsOneWidget);
        },
      );

      testWidgets(
        'verfiy 10 items found initially',
        (tester) async {
          app.main();
          await tester
              .pumpAndSettle(); // wait until there are no more frames to execute
          int count = 1;
          for (var element in tester.allWidgets) {
            if (element.key == const Key('Test-Column-Key')) {
              count++;
            }
          }

          expect(count, equals(10));
        },
      );
    },
  );
}
