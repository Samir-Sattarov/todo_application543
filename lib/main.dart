import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'application.dart';
import 'locator.dart';

void main() async {
  await Hive.initFlutter();

  setup();

  runApp(const Application());
}
