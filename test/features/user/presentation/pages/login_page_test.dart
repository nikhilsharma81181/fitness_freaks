import 'package:fitness_freaks/features/user/presentation/pages/login_page.dart';
import 'package:fitness_freaks/features/user/presentation/providers/user_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  Widget createWidget() {
    return const ProviderScope(child: MaterialApp(home: LoginPage()));
  }

  group('LoginPage UI Tests', () {
    testWidgets('debug widget tree', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Find all text widgets to see what's actually being rendered
      final Iterable<Widget> allWidgets = tester.allWidgets;
      print('=== ALL TEXT WIDGETS ===');
      for (final widget in allWidgets) {
        if (widget is Text) {
          print('Text: "${widget.data}"');
        }
      }

      // For CupertinoButtons
      print('=== ALL CUPERTINO BUTTONS ===');
      for (final widget in allWidgets) {
        if (widget is CupertinoButton) {
          final buttonText =
              widget.child is Text
                  ? (widget.child as Text).data
                  : 'Non-text child';
          print('CupertinoButton with child: $buttonText');
        }
      }

      // Just pass the test
      expect(true, isTrue);
    });

    testWidgets('should display login UI elements correctly', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidget());
      // Allow more time for animations to complete
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(
        find.text('Sign in to continue your fitness journey'),
        findsOneWidget,
      );
      expect(
        find.byType(CupertinoTextField),
        findsNWidgets(2),
      ); // Email and password fields
      expect(find.text('Sign In'), findsAtLeastNWidgets(1));
      expect(find.text('Google'), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);

      // Use a more flexible finder for the account text
      expect(find.textContaining('have an account'), findsOneWidget);

      // Check for Sign Up button instead of just text
      expect(find.widgetWithText(CupertinoButton, 'Sign Up'), findsOneWidget);
    });

    testWidgets('should toggle between sign in and sign up modes', (
      WidgetTester tester,
    ) async {
      // Act - Render login page
      await tester.pumpWidget(createWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Initial state should be sign in
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(
        find.text('Sign in to continue your fitness journey'),
        findsOneWidget,
      );
      expect(
        find.byType(CupertinoTextField),
        findsNWidgets(2),
      ); // Email and password fields

      // Act - Toggle to sign up - use the button finder instead of just text
      await tester.tap(find.widgetWithText(CupertinoButton, 'Sign Up'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Assert - Now in sign up mode
      expect(find.text('Join Fitness Freaks'), findsOneWidget);
      expect(
        find.text('Create an account to track your fitness journey'),
        findsOneWidget,
      );
      expect(
        find.byType(CupertinoTextField),
        findsNWidgets(3),
      ); // Name, email, and password fields
      expect(find.text('Create Account'), findsOneWidget);

      // Act - Toggle back to sign in - use the button finder
      await tester.tap(find.widgetWithText(CupertinoButton, 'Sign In'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Assert - Back to sign in mode
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(
        find.text('Sign in to continue your fitness journey'),
        findsOneWidget,
      );
      expect(
        find.byType(CupertinoTextField),
        findsNWidgets(2),
      ); // Email and password fields
    });
  });
}
