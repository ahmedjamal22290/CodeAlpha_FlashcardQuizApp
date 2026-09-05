import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:code_alpha_flashcard_quiz/main.dart';
import 'package:code_alpha_flashcard_quiz/screens/home_screen.dart';

void main() {
  testWidgets('App shows empty state when no flashcards exist',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const FlashcardApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('No flashcards yet'), findsOneWidget);
  });
}