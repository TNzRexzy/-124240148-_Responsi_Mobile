import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:responsi124240148/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('login requires a valid email and password', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      GetMaterialApp(home: LoginPage(preferences: preferences)),
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('Password wajib diisi'), findsOneWidget);
  });
}
