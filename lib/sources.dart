import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import "package:dio/dio.dart";
import "package:sqflite/sqflite.dart";

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

Future<bool> pingServer(Dio dio) async {
  try {
    await dio.get("ping");
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<Process>> loadProcessFromServer(Dio dio, String username) async {
  final resp = await dio.get("processes/user/$username");
  final List<dynamic> jsonList = resp.data;
  return jsonList.map((json) => Process.fromJson(json)).toList();
}

signupFromServer(Dio dio, String username, String password) async {
  final resp = await dio.post(
    "users/",
    data: {"username": username, "password": password},
  );
  return resp.data;
}

createProcessFromServer(Dio dio, Process process, String owner) async {
  await dio.post(
    "processes/",
    data: process.toJson(),
    queryParameters: {"owner": owner},
  );
}

deleteProcessFromServer(Dio dio, String processId) async {
  await dio.delete("processes/$processId");
}

updateProcessFromServer(Dio dio, Process process) async {
  await dio.put("processes/", data: process.toJson());
}

updateProcessStepsFromServer(
  Dio dio,
  String processId,
  List<Step> steps,
) async {
  await dio.put(
    "processes/$processId/steps",
    data: steps.map((s) => s.toJson()).toList(),
  );
}

Future<List<String>> deletedProcessFromServer(Dio dio) async {
  final response = await dio.get("processes/deleted");
  final List<dynamic> jsonList = response.data;
  return jsonList.map((json) => json.toString()).toList();
}

deletedProcessesToServer(Dio dio, List<String> processIds) async {
  await dio.post("processes/deleted", data: processIds);
}

Future<List<Process>> loadProcessesFromSqlite(Database db) async {
  final rawProcesses = await db.query('processes');
  var processes = [];
  for (final rawProcess in rawProcesses) {
    var process = Map<String, dynamic>.from(rawProcess);
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
    var stepJson = step.toJson();
    stepJson["processId"] = process.id;
    db.insert('steps', stepJson, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

deleteProcessFromSqlite(Database db, String processId) {
  db.delete('processes', where: 'id = ?', whereArgs: [processId]);
  db.delete('steps', where: 'processId = ?', whereArgs: [processId]);
  db.insert("deletedProcesses", {"id": processId});
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

Future<List<String>> getDeletedProcessesFromSqlite(Database db) async {
  final rawProcesses = await db.query('deletedProcesses');
  return rawProcesses.map((e) => e['id'].toString()).toList();
}
