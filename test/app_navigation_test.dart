import 'package:flutter_application_1/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUpAll(() {
    Get.testMode = true;
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CounterApp()));
    await tester.pumpAndSettle();
  }

  testWidgets('home screen offers both implementations', (tester) async {
    await pumpApp(tester);

    expect(find.text('GetX Counter'), findsOneWidget);
    expect(find.text('Riverpod Counter'), findsOneWidget);
  });

  testWidgets('GetX screen increments, decrements and resets', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('GetX Counter'));
    await tester.pumpAndSettle();

    expect(find.text('Interactive Counter'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Increment'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Increment'));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('Decrement'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Riverpod screen is independent and floors at zero', (tester) async {
    await pumpApp(tester);

    // Give the GetX screen some state first.
    await tester.tap(find.text('GetX Counter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Increment'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Riverpod Counter'), findsOneWidget);

    await tester.tap(find.text('Riverpod Counter'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Decrement'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Increment'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });
}
