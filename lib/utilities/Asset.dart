// this utility is used to load assets like images, csv files, etc.

import 'package:flutter/services.dart' show rootBundle;
import 'package:gtr_app/utilities/Debug.dart';

Future<List<List<String>>> load_csv(String path) async {
  // load the CSV file as a string
  final csvString = await rootBundle.loadString(path);

  // parse the CSV string
  final lines = csvString.split('\n');
  final data = lines
      .where((line) => line.trim().isNotEmpty) // Remove empty lines
      .map((line) => line.split(','))
      .toList();

  return data;
}
