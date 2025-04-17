import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import "./models.dart";

saveProcessesToFile(List<Process> processes) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/processes.json');
  final jsonString = jsonEncode(
    processes.map((process) => process.toJson()).toList(),
  );
  await file.writeAsString(jsonString);
}
