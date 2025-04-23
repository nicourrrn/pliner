import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "./sources.dart";
import "./events.dart";
import "./controllers.dart";

part 'watchers.g.dart';

@riverpod
syncEventsWithDatabase(Ref ref) {
  final db = ref.read(databaseProvider).value;
  ref.listen<List<Event>>(eventControllerProvider, (prev, next) {
    if (db == null) return;
    for (final event in next) {
      if (event.executedOn.contains(ExecutedOn.local)) {
        continue;
      }
      switch (event) {
        case CreateProcessEvent(:final process):
          createProcessFromSqlite(db, process);
          break;
        case DeleteProcessEvent(:final processId):
          deleteProcessFromSqlite(db, processId);
          break;
        case UpdateProcessEvent(:final process):
          updateProcessFromSqlite(db, process);
          break;
        case UpdateProcessStepsEvent(:final processId, :final steps):
          updateProcessStepsFromSqlite(db, processId, steps);
          break;
      }
    }
  });
}
