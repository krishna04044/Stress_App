import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:flutter_fastapi/app/app.dart';
import 'package:flutter_fastapi/screens/login_screen.dart';
import 'package:flutter_fastapi/screens/self_tests_screen.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('renders self-tests screen on launch with top-left login button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const Application());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(SelfTestsScreen), findsOneWidget);
    expect(find.text('Discover Yourself'), findsOneWidget);
    expect(find.text('with Self-Tests'), findsOneWidget);
    expect(find.byKey(const Key('top_left_login_btn')), findsOneWidget);
    expect(find.text('Personality Type'), findsOneWidget);
    expect(find.text('ADHD'), findsOneWidget);
  });

  testWidgets('clicking top-left login button navigates to login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const Application());
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.byKey(const Key('top_left_login_btn')));
    for (int i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
  });

  testWidgets('tapping card selects it and opens bottom sheet on double tap',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const Application());
    await tester.pump(const Duration(milliseconds: 200));

    // Tap ADHD card
    await tester.tap(find.byKey(const Key('test_card_adhd')));
    await tester.pump(const Duration(milliseconds: 200));

    // Tap it again to trigger modal preview
    await tester.tap(find.byKey(const Key('test_card_adhd')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Start Assessment'), findsOneWidget);
    await tester.tap(find.text('Start Assessment'), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('renders the login screen and all core elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: LoginScreen()));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember me'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('validates empty inputs on submit', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: LoginScreen()));
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.byKey(const Key('sign_in_submit_btn')));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
