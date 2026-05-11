import 'package:flutter_test/flutter_test.dart';
import 'package:lab/main.dart';

void main() {
  testWidgets('navigates from splash screen to onboarding', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Сайн уу?'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Ухаалаг Зарцуулж\nИлүү Хэмнээ'), findsOneWidget);
  });
}
