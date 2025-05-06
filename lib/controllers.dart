import 'dart:io';
import "package:self_process_manager/sources.dart";
import "package:self_process_manager/theme.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "package:dio/dio.dart";
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import "package:path_provider/path_provider.dart";
import "package:collection/collection.dart";
import "./collectors.dart";
import "./models.dart" as models;

part 'controllers.g.dart';

const String _baseUrl = "http://192.168.0.103:8000/";

final baseUrlProvider = StateProvider<String>((ref) => _baseUrl);
final processNameFilterProvider = StateProvider<String>((ref) => "");
final choosedProcessProvider = StateProvider<String>((ref) => "");

@riverpod
List<DateTime> deadlines(Ref ref) =>
    ref.watch(processListProvider).map((process) => process.deadline).toList();

@riverpod
Future<SharedPreferences> prefs(Ref ref) async =>
    await SharedPreferences.getInstance();

@riverpod
Dio dio(Ref ref) => Dio(
  BaseOptions(
    baseUrl: ref.watch(baseUrlProvider),
    connectTimeout: const Duration(seconds: 3),
    receiveTimeout: const Duration(seconds: 3),
  ),
);

@riverpod
Future<Database> database(Ref ref) async {
  final directory = await getApplicationDocumentsDirectory();

  if (isDesktop()) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  return openDatabase(
    "${directory.path}/processes.db",
    version: 1,
    onCreate: initDatabase,
  );
}

@riverpod
class SelectedGroups extends _$SelectedGroups {
  @override
  List<String> build() => [];

  toggleGroup(String group) {
    final groups = ref.read(processGroupsListProvider);
    var temp = state.where((group) => groups.contains(group)).toList();
    state =
        temp.contains(group)
            ? temp.where((g) => g != group).toList()
            : [...temp, group];
  }

  clear() {
    state = [];
  }
}

@riverpod
class SelectedProcesses extends _$SelectedProcesses {
  @override
  List<String> build() => [];

  toggleProcess(String processId) {
    final processes = ref.read(processListProvider).map((p) => p.id);
    var temp = state.where((id) => processes.contains(id));
    state =
        temp.contains(processId)
            ? temp.where((id) => id != processId).toList()
            : [...temp, processId];
  }

  clear() {
    state = [];
  }
}

@riverpod
class ProcessList extends _$ProcessList {
  @override
  List<models.Process> build() {
    ref.listen<List<models.Event>>(
      eventControllerProvider,
      (prev, events) => events.forEach(_handleEvent),
    );
    return [];
  }

  _handleEvent(models.Event event) {
    switch (event) {
      case models.CreateProcessEvent(:final process):
        append(process);
        break;
      case models.DeleteProcessEvent(:final processId):
        remove([processId]);
        break;
      case models.UpdateProcessEvent(:final process):
        update(process);
        break;
      case models.UpdateProcessStepsEvent(:final processId, :final steps):
        updateSteps(processId, steps);
        break;
    }
  }

  setProcesses(List<models.Process> processes) {
    state = processes;
  }

  updateSteps(String processId, List<models.Step> steps) {
    state = [
      ...state.map(
        (process) =>
            (process.id == processId)
                ? process.copyWith(steps: steps)
                : process,
      ),
    ];
  }

  append(models.Process process) {
    state = [...state.where((p) => p.id != process.id), process];
  }

  update(models.Process process) {
    if (state.contains(process)) {
      var oldProcess = state.firstWhere((p) => p.id == process.id);
      var newSteps =
          process.steps.map((newStep) {
            var stepToReplace = oldProcess.steps.firstWhereOrNull(
              (s) => s.text == newStep.text,
            );
            return stepToReplace == null
                ? newStep
                : newStep.copyWith(
                  id: stepToReplace.id,
                  done: stepToReplace.done,
                );
          }).toList();
      process = process.copyWith(steps: newSteps);
    }
    state = [...state.where((p) => p.id != process.id), process];
  }

  remove(List<String> processIds) {
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

  update(models.User user) {
    state = user;
    final prefs = ref
        .watch(prefsProvider)
        .maybeWhen(data: (d) => d, orElse: () => null);
    if (prefs != null) {
      prefs.setString("token", user.token ?? "");
      prefs.setString("username", user.username);
    }
  }

  clear() {
    state = models.User.empty();
  }
}

@riverpod
class EventController extends _$EventController {
  @override
  List<models.Event> build() => [];

  add(models.Event event) {
    state = [...state, event];
  }
  clear() {
    state = [];
  }
}
