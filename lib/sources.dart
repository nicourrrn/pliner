import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import "package:dio/dio.dart";
import "package:sqflite/sqflite.dart";

import "./models.dart";

// const String baseUrl = "http://192.168.0.101:8000/";
const String baseUrl = "http://localhost:8000/";

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

Future<List<Process>> loadProcessFromServer(Dio dio, String username) async {
  final resp = await dio.get("${baseUrl}processes/user/$username");
  final List<dynamic> jsonList = resp.data;
  return jsonList.map((json) => Process.fromJson(json)).toList();
}

createProcessFromServer(Dio dio, Process process, String owner) async {
  await dio.post(
    "${baseUrl}processes/",
    data: process.toJson(),
    queryParameters: {"owner": owner},
  );
}

deleteProcessFromServer(Dio dio, String processId) async {
  await dio.delete("${baseUrl}processes/$processId");
}

updateProcessFromServer(Dio dio, Process process) async {
  await dio.put("$baseUrl/processes/", data: process.toJson());
}

updateProcessStepsFromServer(
  Dio dio,
  String processId,
  List<Step> steps,
) async {
  await dio.put(
    "$baseUrl/processes/$processId/steps",
    data: steps.map((s) => s.toJson()).toList(),
  );
}

Future<List<Process>> loadProcessesFromSqlite(Database db) async {
  final rawProcesses = await db.query('processes');
  var processes = [];
  for (final rawProcess in rawProcesses) {
    final process = Map<String, dynamic>.from(rawProcess);
    process['steps'] = await db.query(
      'steps',
      where: 'processId = ?',
      whereArgs: [process['id']],
    );
    processes.add(process);
  }
  return processes.map((t) => Process.fromJson(t)).toList();
}

createProcessFromSqlite(Database db, Process process) {
  var processJson = process.toJson();
  processJson.remove('steps');
  db.insert(
    'processes',
    processJson,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  for (var step in process.steps) {
    db.insert(
      'steps',
      step.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

deleteProcessFromSqlite(Database db, String processId) {
  db.delete('processes', where: 'id = ?', whereArgs: [processId]);
  db.delete('steps', where: 'processId = ?', whereArgs: [processId]);
}

updateProcessFromSqlite(Database db, Process process) {
  var processJson = process.toJson();
  processJson.remove('steps');
  db.update('processes', processJson, where: 'id = ?', whereArgs: [process.id]);
  for (var step in process.steps) {
    db.update('steps', step.toJson(), where: 'id = ?', whereArgs: [step.id]);
  }
}

updateProcessStepsFromSqlite(Database db, String processId, List<Step> steps) {
  for (var step in steps) {
    db.update('steps', step.toJson(), where: 'id = ?', whereArgs: [step.id]);
  }
}
