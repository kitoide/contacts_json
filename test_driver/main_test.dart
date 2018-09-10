// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {

  const List<String> _listNames = <String>[
    "Fred F",
    "Wilma F",
    "Barney R",
    "Bambam",
    "Betty R",
    "Dino",
  ];

  group("tests", () {
    final int start = DateTime.now().millisecondsSinceEpoch;
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });

//    test("Checking if ListView is not empty", () async {
//      await driver.waitForAbsent(find.text(EMPTY));
//    });

    test("Checking if my ListView shows the items in my List?", () async {
      for (var i = 0; i < _listNames.length; i++) {
        SerializableFinder item = find.text(_listNames[i]);
        print("Searching for ${_listNames[i]}");

        expect(await driver.getText(item), isNotEmpty);
        await driver.tap(item);

//        await driver.waitFor(item);

        await driver.scrollUntilVisible(item, find.text(_listNames[i]));
      }

      final int end = DateTime.now().millisecondsSinceEpoch;
      final int duration = end - start;
      print('time: ${(duration).toStringAsFixed(2)} ms');
    }, timeout: Timeout(Duration(minutes: 1)));
  });
}
