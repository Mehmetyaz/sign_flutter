import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_flutter/sign_flutter.dart';

void main() {
  testWidgets('Works with single signal', (tester) async {
    var counter = 0.signal;

    var buildCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SlotBuilder(
            signal: counter,
            builder: (v) {
              buildCount++;
              return Text(v.toString());
            },
          ),
        ),
      ),
    );

    /// first build
    expect(buildCount, 1);
    expect(find.text('0'), findsOneWidget);

    /// wait other frame
    await tester.pump();
    expect(buildCount, 1);

    counter.value++;

    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('1'), findsOneWidget);

    ///
    counter.value = 50;
    await tester.pump();
    expect(buildCount, 3);
    expect(find.text('50'), findsOneWidget);

    ///
    await tester.pump();
    expect(buildCount, 3);
  });

  testWidgets('Works with multiple variable', (tester) async {
    var counter1 = 0.signal;
    var counter2 = 0.signal;
    var buildCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SlotBuilder(
            signal: [counter1, counter2].multiSignal,
            builder: (v) {
              buildCount++;
              return Text((counter1.value + counter2.value).toString());
            },
          ),
        ),
      ),
    );

    /// first build
    expect(buildCount, 1);
    expect(find.text('0'), findsOneWidget);

    counter2.value++;
    await tester.pump();

    /// first build
    expect(buildCount, 2);
    expect(find.text('1'), findsOneWidget);

    counter1.value++;
    await tester.pump();

    /// first build
    expect(buildCount, 3);
    expect(find.text('2'), findsOneWidget);

    counter1.value = 10;
    await tester.pump();

    /// first build
    expect(buildCount, 4);
    expect(find.text('11'), findsOneWidget);
  });

  int sum(List<int> l) {
    var i = 0;
    for (var o in l) {
      i += o;
    }
    return i;
  }

  testWidgets('Works collections (list) 2. Way', (tester) async {
    var signalList = <int>[0, 0].signalList;
    var buildCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SlotBuilder<List<int>>(
            signal: signalList,
            builder: (v) {
              buildCount++;
              return Text((sum(v)).toString());
            },
          ),
        ),
      ),
    );

    /// first build
    expect(buildCount, 1);
    expect(find.text('0'), findsOneWidget);

    signalList[1]++;
    await tester.pump();

    expect(buildCount, 2);
    expect(find.text('1'), findsOneWidget);

    signalList[0]++;
    await tester.pump();

    expect(buildCount, 3);
    expect(find.text('2'), findsOneWidget);

    signalList[1] = 10;
    await tester.pump();

    expect(buildCount, 4);
    expect(find.text('11'), findsOneWidget);

    signalList.add(30);
    await tester.pump();

    expect(buildCount, 5);
    expect(find.text('41'), findsOneWidget);

    signalList.remove(10);
    await tester.pump();

    expect(buildCount, 6);
    expect(find.text('31'), findsOneWidget);
  });
}
