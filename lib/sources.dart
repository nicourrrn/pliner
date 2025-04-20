import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import "package:dio/dio.dart";
import "./models.dart";

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
  try {
    final resp = await dio.get("${baseUrl}processes/user/$username");
    final List<dynamic> jsonList = resp.data;
    return jsonList.map((json) => Process.fromJson(json)).toList();
  } catch (e) {
    print(e);
    throw e;
  }
}

saveProcessesToServer(String username, List<Process> process) async {
  final dio = Dio();
  try {
    for (var p in process) {
      await dio.post("${baseUrl}processes/?owner=$username", data: p.toJson());
    }
  } catch (e) {
    print(e);
    throw e;
  }
}
