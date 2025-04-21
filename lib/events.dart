import "package:freezed_annotation/freezed_annotation.dart";
import "package:json_annotation/json_annotation.dart";
import "./models.dart";

part "events.freezed.dart";

enum ExecutedOn { local, server }

@freezed
@JsonSerializable()
sealed class Event with _$Event {
  factory Event.createProcess(Process process, List<ExecutedOn> executedOn) =
      CreateProcessEvent;
  factory Event.deleteProcess(String processId, List<ExecutedOn> executedOn) =
      DeleteProcessEvent;
  factory Event.updateProcess(Process process, List<ExecutedOn> executedOn) =
      UpdateProcessEvent;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
