import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import "package:dio/dio.dart";
import "./models.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:sqflite/sqflite.dart";
import "./controllers.dart";

const String baseUrl = "http://192.168.0.101:8000/";

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

Future<List<Process>> loadProcessFromServer(String username) async {
  final dio = Dio();
  final resp = await dio.get("${baseUrl}processes/user/$username");
  final List<dynamic> jsonList = resp.data;
  return jsonList.map((json) => Process.fromJson(json)).toList();
}

saveProcessesToServer(String username, List<Process> process) async {
  final dio = Dio();
  for (var p in process) {
    await dio.post("${baseUrl}processes/?owner=$username", data: p.toJson());
  }
}

@riverpod
Future<List<Process>> loadProcessesFromSqlite(Ref ref) async {
  final db = ref.watch(databaseProvider).value;
  final processes = await db?.query('processes');
  if (processes == null) {
    return [];
  }
  for (var process in processes) {
    final steps = await db?.query(
      'steps',
      where: 'processId = ?',
      whereArgs: [process['id']],
    );
    process['steps'] = steps;
  }
  return processes.map((t) => Process.fromJson(t)).toList();
}

saveProcessesToSqlite(WidgetRef ref) {
  final db = ref.watch(databaseProvider).value;
  final processes = ref.watch(processListProvider);
  if (db != null) {
    for (var process in processes) {
      db.insert(
        'processes',
        process.toJson(),
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
  }
}
