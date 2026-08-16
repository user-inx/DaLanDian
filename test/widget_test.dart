import 'package:flutter_test/flutter_test.dart';
import 'package:app/app.dart';

void main() {
  testWidgets('大蓝典 App 启动测试', (WidgetTester tester) async {
    await tester.pumpWidget(const DaLanDianApp());
    expect(find.text('大蓝典'), findsWidgets);
  });
}