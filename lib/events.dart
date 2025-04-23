import "package:freezed_annotation/freezed_annotation.dart";
import "package:json_annotation/json_annotation.dart";
import "./models.dart";

part "events.freezed.dart";
part "events.g.dart";

enum ExecutedOn { local, server }

@freezed
sealed class Event with _$Event {
  factory Event.createProcess(
    Process process, {
    @Default([]) List<ExecutedOn> executedOn,
  }) = CreateProcessEvent;
  factory Event.deleteProcess(
    String processId, {
    @Default([]) List<ExecutedOn> executedOn,
  }) = DeleteProcessEvent;
  factory Event.updateProcess(
    Process process, {
    @Default([]) List<ExecutedOn> executedOn,
  }) = UpdateProcessEvent;
  factory Event.updateProcessSteps(
    String processId,
    List<Step> steps, {
    @Default([]) List<ExecutedOn> executedOn,
  }) = UpdateProcessStepsEvent;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
