import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sat_scraping/main.dart';

void main() {
  group('MyApp', () {
    testWidgets('Renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(MyApp), findsOneWidget);
    });
  });

  group('MyHomePage', () {
    testWidgets('Renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: MyHomePage(title: 'Test Title'),
      ));
      expect(find.byType(MyHomePage), findsOneWidget);
    });

    testWidgets('Displays title', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: MyHomePage(title: 'Test Title'),
      ));
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('Loading indicator shown when loading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MyHomePage(title: 'Test Title'),
      ));

      final MyHomePageState state = tester.state(find.byType(MyHomePage));

      state.loading = true;
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Add more tests as needed
  });

  group('InfoSat', () {
    testWidgets('Renders without crashing', (WidgetTester tester) async {
      final infoFiscal = InfoFiscal.getDefault();
      await tester.pumpWidget(MaterialApp(
        home: InfoSat(infoFiscal: infoFiscal),
      ));
      expect(find.byType(InfoSat), findsOneWidget);
    });

    // Add more tests as needed
  });

  // Add more test groups for other widgets
}
