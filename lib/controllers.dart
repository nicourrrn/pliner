import "package:shared_preferences/shared_preferences.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "./models.dart" as models;
import "./sources.dart";
import "./events.dart";
import "package:dio/dio.dart";
import "package:sqflite/sqflite.dart";
import "package:path_provider/path_provider.dart";

part 'controllers.g.dart';

final processNameFilterProvider = StateProvider<String>((ref) => "");
final choosedProcessProvider = StateProvider<String>((ref) => "");
final newProcessesToUploadProvider = StateProvider<List<models.Process>>(
  (ref) => [],
);

final deleteProcessProvider = StateProvider<List<String>>((ref) => []);

@riverpod
class SelectedGroups extends _$SelectedGroups {
  @override
  List<String> build() {
    return [];
  }

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

  addGroup(String group) {
    state = [...state, group];
  }

  removeGroup(String group) {
    state = state.where((g) => g != group).toList();
  }

  cleanState() {
    state = [];
  }
}

@riverpod
class SelectedProcesses extends _$SelectedProcesses {
  @override
  List<String> build() {
    return [];
  }

  toggleProcess(String processId) {
    if (state.contains(processId)) {
      state = state.where((id) => id != processId).toList();
    } else {
      state = [...state, processId];
    }
  }

  addProcess(String processId) {
    state = [...state, processId];
  }

  removeProcess(String processId) {
    state = state.where((id) => id != processId).toList();
  }

  cleanState() {
    state = [];
  }
}

@riverpod
List<String> processGroupsList(Ref ref) {
  return ref
      .watch(processListProvider)
      .map((process) => process.group)
      .toSet()
      .toList();
}

@riverpod
class ProcessList extends _$ProcessList {
  @override
  List<models.Process> build() {
    _loadProcesses();
    return [];
  }

  _loadProcesses() async {
    var processes = await loadProcessFromFile();
    processes =
        processes
            .map(
              (process) => process.copyWith(
                steps: {for (final s in process.steps) s.id: s}.values.toList(),
              ),
            )
            .toList();

    state = processes;
  }

  setProcesses(List<models.Process> processes) {
    state = processes;
  }

  updateProcessSteps(String processId, List<models.Step> steps) {
    state =
        state.map((process) {
          if (process.id == processId) {
            return process.copyWith(steps: steps);
          }
          return process;
        }).toList();
  }

  appendProcess(models.Process process) {
    state = [...state, process];
  }

  appendOrReplaceProcess(models.Process process) {
    if (state.any((p) => p.id == process.id)) {
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
    state = state.where((p) => p.id != process.id).toList();
    state = [...state, process];
  }

  removeProcess(List<String> processIds) {
    state = state.where((process) => !processIds.contains(process.id)).toList();
  }
}

@riverpod
List<models.Process> sortedProcess(Ref ref) {
  var processes = ref.watch(processListProvider);
  processes.sort((a, b) {
    if (a.isMandatory && b.isMandatory) return 0;
    if (a.isMandatory) return -1;
    return 1;
  });
  if (ref.watch(selectedGroupsProvider).isNotEmpty) {
    processes =
        processes
            .where(
              (process) =>
                  ref.watch(selectedGroupsProvider).contains(process.group),
            )
            .toList();
  }

  if (ref.watch(processNameFilterProvider).isNotEmpty) {
    processes =
        processes
            .where(
              (process) => process.name.toLowerCase().contains(
                ref.watch(processNameFilterProvider).toLowerCase(),
              ),
            )
            .toList();
  }

  return processes;
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
    state = models.User(
      username: "",
      password: "",
      isLoggedIn: false,
      token: "",
    );
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
                group_name TEXT,
                deadline TEXT,
                assignedAt TEXT,
                owner TEXT,
                editAt TEXT,
                FOREIGN KEY (owner) REFERENCES users (username)
            )
            """);
      db.execute("""
            CREATE TABLE IF NOT EXISTS steps (
                id TEXT PRIMARY KEY,
                text TEXT,
                done BOOLEAN,
                isMandatory BOOLEAN,
                process_id TEXT,
                FOREIGN KEY (process_id) REFERENCES processes (id)
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

  executeEventsOnLocal() {
    for (final event in state) {
      if (event.executedOn.contains(ExecutedOn.local)) {
        continue;
      }
      switch (event) {
        case CreateProcessEvent(:final process):
          ref
              .read(processListProvider.notifier)
              .appendOrReplaceProcess(process);
          break;
        case DeleteProcessEvent(:final processId):
          ref.read(processListProvider.notifier).removeProcess([processId]);
          break;
        case UpdateProcessEvent(:final process):
          ref
              .read(processListProvider.notifier)
              .appendOrReplaceProcess(process);
          break;
      }
    }
  }

  executeEventsOnServer() {
    final dio = ref.read(dioProvider);
    for (final events in state) {
      if (events.executedOn.contains(ExecutedOn.server)) {
        continue;
      }
      switch (events) {
        case CreateProcessEvent(:final process):
          createProcessFromServer(dio, process);
          break;
        case DeleteProcessEvent(:final processId):
          deleteProcessFromServer(dio, processId);
          break;
        case UpdateProcessEvent(:final process):
          updateProcessFromServer(dio, process);
          break;
      }
    }
  }
}
