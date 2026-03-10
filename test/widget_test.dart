import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:competition_manager/app/app.dart';

void main() {
  testWidgets('App should render login screen', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const App());

    // Verify that login screen elements are present
    expect(find.text('Sistema de Competencias'), findsOneWidget);
    expect(find.byIcon(Icons.email), findsOneWidget);
    expect(find.byIcon(Icons.lock), findsOneWidget);
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });

  testWidgets('Login button should show loading state', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Find and tap the login button
    final loginButton = find.text('Iniciar Sesión');
    expect(loginButton, findsOneWidget);
    
    await tester.tap(loginButton);
    await tester.pump();

    // Should show CircularProgressIndicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}