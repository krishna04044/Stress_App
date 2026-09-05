import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_fastapi/app/app.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('renders the login screen and all core elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(Application());
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember me'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Or With'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
  });

  testWidgets('validates empty inputs on submit', (WidgetTester tester) async {
    await tester.pumpWidget(Application());
    await tester.pumpAndSettle();

    // Tap submit without typing anything
    await tester.tap(find.byKey(const Key('sign_in_submit_btn')));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('validates invalid email format', (WidgetTester tester) async {
    await tester.pumpWidget(Application());
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('login_email_input')), 'invalidemail');
    await tester.enterText(
        find.byKey(const Key('login_password_input')), '123456');
    await tester.tap(find.byKey(const Key('sign_in_submit_btn')));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a valid email address'), findsOneWidget);
  });

  testWidgets('successful dummy login navigates to existing HomeScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(Application());
    await tester.pumpAndSettle();

    // Enter valid dummy credentials
    await tester.enterText(
        find.byKey(const Key('login_email_input')), 'user@wellness.app');
    await tester.enterText(
        find.byKey(const Key('login_password_input')), 'secret123');

    await tester.tap(find.byKey(const Key('sign_in_submit_btn')));
    // Fast-forward the simulated network delay
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Zen LoadingScreen is shown
    expect(find.text('ZEN MODE ACTIVE'), findsOneWidget);

    // Fast-forward loading duration
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();

    // Should now be on the existing HomeScreen
    expect(find.text('Flutter FastAPI'), findsOneWidget);
    expect(find.text('clicked 0 times'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Test logout returns to LoginScreen
    await tester.tap(find.byTooltip('Log Out'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('sign_in_submit_btn')), findsOneWidget);
  });

  testWidgets('opens Forgot Password and Sign Up dialogs',
      (WidgetTester tester) async {
    await tester.pumpWidget(Application());
    await tester.pumpAndSettle();

    // Tap forgot password
    await tester.tap(find.byKey(const Key('forgot_password_btn')));
    await tester.pumpAndSettle();

    expect(find.text('Reset Password'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Tap sign up
    await tester.tap(find.byKey(const Key('sign_up_btn')));
    await tester.pumpAndSettle();

    expect(find.text('Join Stress App'), findsOneWidget);
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
  });
}
