import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "package:collection/collection.dart";
import './controllers.dart';
import "./models.dart";
import "./sources.dart";

part "collectors.g.dart";

@riverpod
Future<List<Process>> databaseProcessList(Ref ref) async {
  final db = await ref.watch(databaseProvider.future);
  final processes = await loadProcessesFromSqlite(db);
  return processes;
}

@riverpod
int processesToUpload(Ref ref) {
  return ref.watch(eventControllerProvider).length;
}

@riverpod
List<String> processGroupsList(Ref ref) {
  return ref
      .watch(processListProvider)
      .map((process) => process.groupName)
      .toSet()
      .toList();
}

enum SortBy { name, deadline, group }

final sortByProvider = StateProvider<SortBy>((ref) => SortBy.deadline);

List<Process> filterByName(List<Process> processes, String nameFilter) {
  if (nameFilter.isEmpty) return processes;
  return processes
      .where(
        (process) =>
            process.name.toLowerCase().contains(nameFilter.toLowerCase()),
      )
      .toList();
}

List<Process> filterByGroup(
  List<Process> processes,
  List<String> selectedGroups,
) {
  if (selectedGroups.isEmpty) return processes;
  return processes
      .where((process) => selectedGroups.contains(process.groupName))
      .toList();
}

List<Process> sortProcesses(List<Process> processes, SortBy sortBy) {
  switch (sortBy) {
    case SortBy.name:
      return processes.sorted((a, b) => a.name.compareTo(b.name));
    case SortBy.deadline:
      return processes.sorted((a, b) => a.deadline.compareTo(b.deadline));
    case SortBy.group:
      return processes.sorted((a, b) => a.groupName.compareTo(b.groupName));
  }
}

@riverpod
List<Process> sortedProcess(Ref ref) {
  final processes = ref.watch(processListProvider);
  final sortBy = ref.watch(sortByProvider);
  final selectedGroups = ref.watch(selectedGroupsProvider);
  final nameFilter = ref.watch(processNameFilterProvider);

  return sortProcesses(
    filterByName(filterByGroup(processes, selectedGroups), nameFilter),
    sortBy,
  );
}
