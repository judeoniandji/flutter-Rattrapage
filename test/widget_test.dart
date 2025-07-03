// Test pour l'application de gestion d'employés

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_employes/main.dart';

void main() {
  testWidgets('Login screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that login screen elements are present
    expect(find.text('Gestion Informatique'), findsOneWidget);
    expect(find.text('Connexion Administrateur'), findsOneWidget);
    expect(find.text('Identifiant'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);

    // Verify that login form fields are present
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Login form validation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Try to submit empty form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Should show validation errors
    expect(find.text('Veuillez saisir votre identifiant'), findsOneWidget);
    expect(find.text('Veuillez saisir votre mot de passe'), findsOneWidget);
  });
}
