import 'package:contacts_json/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:contacts_json/main.dart';

void main() {
  enableFlutterDriverExtension();
  app.main();

  runApp(new MyApp(true));
}