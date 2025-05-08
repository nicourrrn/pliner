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
  return await loadProcessesFromSqlite(db);
}

@riverpod
int processesToUpload(Ref ref) => ref.watch(eventControllerProvider).length;

@riverpod
List<String> processGroupsList(Ref ref) =>
    ref
        .watch(processListProvider)
        .map((process) => process.groupName)
        .toSet()
        .toList();

final sortByProvider = StateProvider<SortBy>((ref) => SortBy.deadline);

List<Process> filterByName(List<Process> processes, String nameFilter) =>
    nameFilter.isEmpty
        ? processes
        : processes
            .where(
              (process) =>
                  process.name.toLowerCase().contains(nameFilter.toLowerCase()),
            )
            .toList();

List<Process> filterByGroup(
  List<Process> processes,
  List<String> selectedGroups,
) =>
    selectedGroups.isEmpty
        ? processes
        : processes
            .where((process) => selectedGroups.contains(process.groupName))
            .toList();

List<Process> sortProcesses(List<Process> processes, SortBy sortBy) {
  switch (sortBy) {
    case SortBy.name:
      return processes.sorted((a, b) => a.name.compareTo(b.name));
    case SortBy.deadline:
      return processes.sorted((a, b) => a.deadline.compareTo(b.deadline));
    case SortBy.editAt:
      return processes.sorted((a, b) => a.editAt.compareTo(b.editAt));
  }
}

@riverpod
List<Process> sortedProcess(Ref ref) {
  final processes = ref.watch(processListProvider);
  final sortBy = ref.watch(sortByProvider);
  final nameFilter = ref.watch(processNameFilterProvider);

  return sortProcesses(filterByName(processes, nameFilter), sortBy);
}

@riverpod
syncEventsWithDatabase(Ref ref) async {
  final db = await ref.read(databaseProvider.future);
  final dio = ref.read(dioProvider);
  ref.listen<List<Event>>(eventControllerProvider, (prev, next) async {
    for (final event in next) {
      handleEventOnLocal(event, db);
      if (await pingServer(dio)) handleEventOnServer(event, dio);
    }
  });
}
