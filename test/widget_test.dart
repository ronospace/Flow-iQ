// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flow_iq/main.dart';
import 'package:flow_iq/services/flow_iq_sync_service.dart';

void main() {
  testWidgets('App loads home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FlowIQSyncService()),
        ],
        child: const FlowiQApp(),
      ),
    );

    // Wait for app to fully load
    await tester.pumpAndSettle();

    // Verify that our app loads successfully
    expect(find.byType(FlowiQApp), findsOneWidget);
    
    // Check that navigation bar is present
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
