import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

import 'contacts_list.dart';

void main() {
  enableFlutterDriverExtension();
  runApp(new MaterialApp(home: new ContactsList(),));
}
