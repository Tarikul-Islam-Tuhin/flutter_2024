import 'package:bs23_flutter_task/features/git_repos_flutter/presentation/pages/details_page.dart';
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
        'verfiy more than 1 items found initially',
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

          expect(count, greaterThan(1));
        },
      );
      testWidgets(
        'verfiy Details Page Screen',
        (tester) async {
          app.main();
          await tester
              .pumpAndSettle(); // wait until there are no more frames to execute

          expect(find.byType(ListView), findsOneWidget);
          await tester.tap(find.byKey(const Key('Test-InkWell-Key')).at(0));
          await tester
              .pumpAndSettle(); // wait until there are no more frames to execute
          expect(find.byType(DetailsPage), findsOneWidget);
        },
      );
    },
  );
}
