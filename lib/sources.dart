import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';
import "package:dio/dio.dart";
import "package:sqflite/sqflite.dart";

import "./models.dart";

// File part

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

// Server part

//      Utils

Stream<Event> syncWithServer(
  Dio dio,
  Database db,
  String username,
  List<Process> processes,
) async* {
  final deletedProcessIds = await deletedProcessFromServer(dio);
  for (final processId in deletedProcessIds) {
    final localProcess = processes.firstWhereOrNull((p) => p.id == processId);
    if (localProcess != null) {
      yield Event.deleteProcess(processId);
    }
  }
  await deletedProcessesToServer(dio, await getDeletedProcessesFromSqlite(db));

  var editAtMap = <String, DateTime>{};
  for (final editAt in await editAtListFromServer(dio, username)) {
    editAtMap[editAt.id] = editAt.editAt;
  }

  await updateProcessFromServer(
    dio,
    processes
        .where(
          (p) =>
              editAtMap.containsKey(p.id) &&
              editAtMap[p.id]!.isBefore(p.editAt),
        )
        .toList(),
    username,
  );

  await createProcessFromServer(
    dio,
    processes.where((p) => !editAtMap.containsKey(p.id)).toList(),
    username,
  );

  final toUpdateFromServer = processes.where(
    (p) => editAtMap.containsKey(p.id) && editAtMap[p.id]!.isAfter(p.editAt),
  );
  for (final process in toUpdateFromServer) {
    yield Event.updateProcess(await getProcessFromServer(dio, process.id));
  }

  final toLoadFromServer = editAtMap.keys.where(
    (id) => !processes.any((p) => p.id == id),
  );
  for (final id in toLoadFromServer) {
    yield Event.createProcess(await getProcessFromServer(dio, id), username);
  }
}

Future<bool> pingServer(Dio dio) async {
  try {
    await dio.get("ping");
    return true;
  } catch (e) {
    return false;
  }
}

signupFromServer(Dio dio, String username, String password) async {
  final resp = await dio.post(
    "users/",
    data: {"username": username, "password": password},
  );
  return resp.data;
}

//      Get

Future<List<Process>> loadProcessFromServer(Dio dio, String username) async {
  final resp = await dio.get(
    "processes/",
    queryParameters: {"owner": username},
  );
  final List<dynamic> jsonList = resp.data;
  return jsonList.map((json) => Process.fromJson(json)).toList();
}

Future<List<String>> deletedProcessFromServer(Dio dio) async {
  final response = await dio.get("processes/deleted/");
  final List<dynamic> jsonList = response.data;
  return jsonList.map((json) => json.toString()).toList();
}

Future<List<EditAt>> editAtListFromServer(Dio dio, String owner) async {
  final response = await dio.get(
    "processes/last_edites",
    queryParameters: {"owner": owner},
  );
  final List<dynamic> jsonList = response.data;
  return jsonList.map((json) => EditAt.fromJson(json)).toList().cast<EditAt>();
}

Future<Process> getProcessFromServer(Dio dio, String processId) async {
  final response = await dio.get("processes/$processId/");
  return Process.fromJson(response.data);
}

//      Post
createProcessFromServer(Dio dio, List<Process> processes, String owner) async {
  await dio.post(
    "processes/",
    data: processes.map((process) => process.toJson()).toList(),
    queryParameters: {"owner": owner},
  );
}

updateProcessFromServer(
  Dio dio,
  List<Process> processes,
  String username,
) async {
  await dio.put(
    "processes/",
    data: processes.map((p) => p.toJson()).toList(),
    queryParameters: {"owner": username},
  );
}

deleteProcessFromServer(Dio dio, String processId) async {
  await dio.delete("processes/$processId");
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

deletedProcessesToServer(Dio dio, List<String> processIds) async {
  await dio.delete("processes/", data: jsonEncode(processIds));
}

// SQLite part
//      Utils

initDatabase(Database db, int version) async {
  await db.execute("""
            CREATE TABLE IF NOT EXISTS processes (
                id TEXT PRIMARY KEY,
                name TEXT,
                description TEXT,
                isMandatory BOOLEAN,
                processType TEXT,
                timeNeeded INTEGER,
                groupName TEXT,
                deadline TEXT,
                assignedAt TEXT,
                owner TEXT,
                editAt TEXT
            )
            """);
  await db.execute("""
            CREATE TABLE IF NOT EXISTS steps (
                id TEXT PRIMARY KEY,
                text TEXT,
                done INTEGER,
                isMandatory INTEGER,
                processId TEXT,
                FOREIGN KEY (processId) REFERENCES processes (id)
                )
        """);
  await db.execute("""
            CREATE TABLE IF NOT EXISTS deletedProcesses (
                id TEXT PRIMARY KEY
            )
        """);
}
//      Get

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

Future<List<String>> getDeletedProcessesFromSqlite(Database db) async {
  final rawProcesses = await db.query('deletedProcesses');
  return rawProcesses.map((e) => e['id'].toString()).toList();
}

//      Post

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
