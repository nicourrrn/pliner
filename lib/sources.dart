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

Future<List<Process>> loadProcessFromFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/processes.json');
  if (!file.existsSync()) {
    return [];
  }
  final jsonString = await file.readAsString();
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList
      .map((json) => Process.fromJson(json))
      .toList()
      .cast<Process>();
}
