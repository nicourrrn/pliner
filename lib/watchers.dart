import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "./sources.dart";
import "./events.dart";
import "./controllers.dart";

part 'watchers.g.dart';

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
