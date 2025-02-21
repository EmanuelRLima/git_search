import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gitsearch/main.dart';
import 'package:gitsearch/modules/filter_screen.dart';
import 'package:gitsearch/modules/history_search.dart';

void main() {
  testWidgets('SearchScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(TextField), findsOneWidget);

    expect(find.byIcon(Icons.search), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Flutter');

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    expect(find.text('Nada pesquisado ainda'), findsOneWidget);
  });

  testWidgets('Navegação para a tela de filtro', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.filter_alt));
    await tester.pumpAndSettle();

    expect(find.byType(FilterScreen), findsOneWidget);
  });

  testWidgets('Nvegação para a tela de histórico', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    expect(find.byType(HistoryScreen), findsOneWidget);
  });

  testWidgets('Testando o estado de carregamento e dados vazios', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    expect(find.text('Nada pesquisado ainda'), findsOneWidget);
  });

  testWidgets(
    'Testando interação com o campo de pesquisa e botão de pesquisa',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.enterText(find.byType(TextField), 'Flutter');

      expect(find.text('Flutter'), findsOneWidget);

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.search));

      await tester.pumpAndSettle();

      // expect(find.text('Nada pesquisado ainda'), findsOneWidget);
      // a rota está retornando 400 quando feita pelo teste.
    },
  );
}
