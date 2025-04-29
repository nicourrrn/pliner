import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "./events.dart";
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

@riverpod
List<Process> sortedProcess(Ref ref) {
  var processes = ref.watch(processListProvider);
  processes.sort((a, b) {
    if (a.isMandatory && b.isMandatory) return 0;
    if (a.isMandatory) return -1;
    return 1;
  });

  final selectedGroups = ref.watch(selectedGroupsProvider);
  if (selectedGroups.isNotEmpty) {
    processes =
        processes
            .where((process) => selectedGroups.contains(process.groupName))
            .toList();
  }

  final nameFilter = ref.watch(processNameFilterProvider);
  if (nameFilter.isNotEmpty) {
    processes =
        processes
            .where(
              (process) =>
                  process.name.toLowerCase().contains(nameFilter.toLowerCase()),
            )
            .toList();
  }

  return processes;
}
