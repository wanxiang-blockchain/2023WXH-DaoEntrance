import 'package:dtim/router.dart';
import 'package:dtim/application/store/theme.dart';
import 'package:dtim/domain/utils/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dtim/infra/components/loading_dialog.dart';

void main() {
  testWidgets("test loading", (WidgetTester tester) async {
    initScreen(1200);
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: rootNavigatorKey,
        theme: getDefaultTheme(),
        home: Scaffold(
          body: Column(
            children: [
              InkWell(
                key: const Key('auto_test'),
                child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.blue,
                ),
                onTap: () {
                  print("test");
                  waitFutureLoading(
                    context: rootNavigatorKey!.currentContext!,
                    future: () async {
                      await Future.delayed(const Duration(seconds: 1));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    // 触发注册按钮点击
    await tester.tap(find.byKey(const Key('auto_test')));
    await tester.pumpAndSettle();
  });
}
