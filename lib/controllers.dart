import "package:shared_preferences/shared_preferences.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "./models.dart" as models;
import "./events.dart";
import "package:dio/dio.dart";
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import "package:path_provider/path_provider.dart";
import "./collectors.dart";

part 'controllers.g.dart';

final processNameFilterProvider = StateProvider<String>((ref) => "");
final choosedProcessProvider = StateProvider<String>((ref) => "");

@riverpod
class SelectedGroups extends _$SelectedGroups {
  @override
  List<String> build() => [];

  deleteRemovedGroups() {
    final groups = ref.read(processGroupsListProvider);
    state = state.where((group) => groups.contains(group)).toList();
  }

  toggleGroup(String group) {
    deleteRemovedGroups();
    if (state.contains(group)) {
      state = state.where((g) => g != group).toList();
    } else {
      state = [...state, group];
    }
  }
}

@riverpod
class SelectedProcesses extends _$SelectedProcesses {
  @override
  List<String> build() => [];

  toggleProcess(String processId) {
    if (state.contains(processId)) {
      state = state.where((id) => id != processId).toList();
    } else {
      state = [...state, processId];
    }
  }

  cleanState() {
    state = [];
  }
}

@riverpod
class ProcessList extends _$ProcessList {
  @override
  List<models.Process> build() {
    ref.listen<List<Event>>(eventControllerProvider, (prev, events) {
      for (final event in events) {
        _handleEvent(event);
      }
    });
    return [];
  }

  _handleEvent(Event event) {
    if (event.executedOn.contains(ExecutedOn.local)) return;

    switch (event) {
      case CreateProcessEvent(:final process):
        appendProcess(process);
        break;
      case DeleteProcessEvent(:final processId):
        removeProcess([processId]);
        break;
      case UpdateProcessEvent(:final process):
        appendOrReplaceProcess(process);
        break;
      case UpdateProcessStepsEvent(:final processId, :final steps):
        updateProcessSteps(processId, steps);
        break;
    }
  }

  setProcesses(List<models.Process> processes) {
    debugPrint("Processes set");
    state = processes;
  }

  updateProcessSteps(String processId, List<models.Step> steps) {
    state =
        state
            .map(
              (process) =>
                  (process.id == processId)
                      ? process.copyWith(steps: steps)
                      : process,
            )
            .toList();
  }

  appendProcess(models.Process process) {
    state = [...state, process];
  }

  appendOrReplaceProcess(models.Process process) {
    if (state.contains(process)) {
      var processToReplace = state.firstWhere((p) => p.id == process.id);
      var newSteps =
          process.steps.map((p) {
            var stepToReplace =
                processToReplace.steps
                    .where((s) => s.text == p.text)
                    .firstOrNull;
            if (stepToReplace == null) return p;
            return p.copyWith(id: stepToReplace.id, done: stepToReplace.done);
          }).toList();
      process = process.copyWith(steps: newSteps);
    }
    final newState = state.where((p) => p.id != process.id).toList();
    state = [...newState, process];
  }

  removeProcess(List<String> processIds) {
    state = state.where((process) => !processIds.contains(process.id)).toList();
  }
}

@riverpod
class UserController extends _$UserController {
  @override
  models.User build() {
    final prefs = ref
        .watch(prefsProvider)
        .maybeWhen(data: (d) => d, orElse: () => null);
    final token = prefs?.getString("token") ?? "";
    final username = prefs?.getString("username") ?? "";

    return models.User(
      username: username,
      password: "",
      token: token,
      isLoggedIn: token.isNotEmpty,
    );
  }

  updateUser(models.User user) {
    state = user;
    final prefs = ref
        .watch(prefsProvider)
        .maybeWhen(data: (d) => d, orElse: () => null);
    if (prefs != null) {
      prefs.setString("token", user.token ?? "");
      prefs.setString("username", user.username);
    }
  }

  cleanUser() {
    state = models.User.empty();
  }
}

@riverpod
Future<SharedPreferences> prefs(Ref ref) async {
  return await SharedPreferences.getInstance();
}

@riverpod
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: "https://api.example.com",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
}

@riverpod
Future<Database> database(Ref ref) async {
  final directory = await getApplicationDocumentsDirectory();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  return openDatabase(
    "${directory.path}/processes.db",
    version: 1,
    onCreate: (db, version) {
      db.execute("""
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
      db.execute("""
            CREATE TABLE IF NOT EXISTS steps (
                id TEXT PRIMARY KEY,
                text TEXT,
                done INTEGER,
                isMandatory INTEGER,
                processId TEXT,
                FOREIGN KEY (processId) REFERENCES processes (id)
                )
        """);
    },
  );
}

@riverpod
class EventController extends _$EventController {
  @override
  List<Event> build() {
    return [];
  }

  addEvent(Event event) {
    state = [...state, event];
  }

  cleanEvents() {
    state = [];
  }
}
