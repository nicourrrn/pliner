import "package:freezed_annotation/freezed_annotation.dart";
import "package:sqflite/sqflite.dart";
import "package:json_annotation/json_annotation.dart";
import "package:dio/dio.dart";
import "./models.dart";
import "./sources.dart";

part "events.freezed.dart";
part "events.g.dart";

@freezed
sealed class Event with _$Event {
  factory Event.createProcess(Process process, String owner) =
      CreateProcessEvent;
  factory Event.deleteProcess(String processId) = DeleteProcessEvent;
  factory Event.updateProcess(Process process) = UpdateProcessEvent;
  factory Event.updateProcessSteps(String processId, List<Step> steps) =
      UpdateProcessStepsEvent;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

handleEventOnLocal(Event event, Database db) async {
  switch (event) {
    case CreateProcessEvent(:final process):
      await createProcessFromSqlite(db, process);
      break;
    case DeleteProcessEvent(:final processId):
      await deleteProcessFromSqlite(db, processId);
      break;
    case UpdateProcessEvent(:final process):
      await updateProcessFromSqlite(db, process);
      break;
    case UpdateProcessStepsEvent(:final processId, :final steps):
      await updateProcessStepsFromSqlite(db, processId, steps);
      break;
  }
}

handleEventOnServer(Event event, Dio dio) async {
  switch (event) {
    case CreateProcessEvent(:final process, :final owner):
      await createProcessFromServer(dio, process, owner);
      break;
    case DeleteProcessEvent(:final processId):
      await deleteProcessFromServer(dio, processId);
      break;
    case UpdateProcessEvent(:final process):
      await updateProcessFromServer(dio, process);
      break;
    case UpdateProcessStepsEvent(:final processId, :final steps):
      await updateProcessStepsFromServer(dio, processId, steps);
      break;
  }
}
