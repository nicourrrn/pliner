import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "package:file_picker/file_picker.dart";
import "dart:convert";
import "package:path_provider/path_provider.dart";
import "./models.dart" as models;

part 'controllers.g.dart';

final processNameFilterProvider = StateProvider<String>((ref) => "");

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
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/processes.json');
    if (!file.existsSync()) {
      return;
    }
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    state =
        jsonList
            .map((json) => models.Process.fromJson(json))
            .toList()
            .cast<models.Process>();
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
    if (a.isMendatary && b.isMendatary) return 0;
    if (a.isMendatary) return -1;
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

loadProcesses(WidgetRef ref) async {
  final result = await FilePicker.platform.pickFiles();
  if (result == null) return;
  var file = jsonDecode(await File(result.files.single.path!).readAsString());
  for (var process in file) {
    final newProcess = models.Process.fromJson(process);
    ref.read(processListProvider.notifier).appendProcess(newProcess);
  }
}
