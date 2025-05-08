import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import "package:sqflite/sqflite.dart";
import "package:json_annotation/json_annotation.dart";
import "package:dio/dio.dart";
import "./sources.dart";

part 'models.g.dart';
part 'models.freezed.dart';

enum SortBy { name, deadline, editAt }

enum ProcessType {
  parallel("Parallel"),
  focus("Focus");

  final String name;
  const ProcessType(this.name);
}

int _booleanToInt(dynamic value) =>
    value is bool
        ? value
            ? 1
            : 0
        : value;
bool _intToBoolean(dynamic value) => value is int ? value == 1 : value;

@freezed
@JsonSerializable()
class Process with _$Process {
  Process({
    required this.id,
    required this.name,
    required this.description,
    required this.isMandatory,
    required this.processType,
    required this.groupName,
    required this.timeNeeded,
    required this.deadline,
    required this.assignedAt,
    required this.steps,
    required this.editAt,
  });
  final String id;
  final String name;
  final String description;
  @JsonKey(fromJson: _intToBoolean, toJson: _booleanToInt)
  final bool isMandatory;
  final ProcessType processType;
  final Duration timeNeeded;
  final String groupName;
  final DateTime deadline;
  final DateTime assignedAt;
  final List<Step> steps;
  final DateTime editAt;

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);
  Map<String, dynamic> toJson() => _$ProcessToJson(this);

  factory Process.zero() => Process(
    id: Uuid().v1(),
    name: '[]',
    description: '',
    isMandatory: false,
    processType: ProcessType.focus,
    deadline: DateTime.now().add(const Duration(days: 7)),
    groupName: '',
    timeNeeded: const Duration(hours: 3),
    assignedAt: DateTime.now(),
    steps: [],
    editAt: DateTime.now(),
  );
}

@freezed
@JsonSerializable()
class Step with _$Step {
  Step({
    required this.id,
    required this.text,
    required this.done,
    required this.isMandatory,
  });
  final String id;
  final String text;
  @JsonKey(fromJson: _intToBoolean, toJson: _booleanToInt)
  final bool done;
  @JsonKey(fromJson: _intToBoolean, toJson: _booleanToInt)
  final bool isMandatory;

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
  Map<String, dynamic> toJson() => _$StepToJson(this);
}

@freezed
@JsonSerializable()
class User with _$User {
  User({
    required this.username,
    required this.password,
    this.token,
    this.isLoggedIn = false,
  });
  final String username;
  final String password;
  final String? token;
  final bool isLoggedIn;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.empty() =>
      User(username: "", password: "", token: null, isLoggedIn: false);
}

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

String processToText(Process process) {
  var text =
      "${process.name} +${process.deadline.difference(DateTime.now()).inDays}d +${process.timeNeeded.inHours}h${process.processType == ProcessType.focus ? "f" : "p"}\n";
  if (process.description.isNotEmpty) {
    text += "${process.description}\n";
  }
  text += process.steps
      .map((step) => "${step.isMandatory ? "-" : "+"} ${step.text}")
      .join("\n");
  return text;
}

Process processFromText(
  String text, [
  String? group,
  bool? isMandatory,
  String? id,
  List<Step> steps = const [],
]) {
  var lines = text.split("\n");
  lines = lines.map((line) => line.trim()).where((s) => s.isNotEmpty).toList();
  var name = lines[0];
  var description = "";

  final deadLineExp = RegExp(r"\+(\d+)d");

  var deadline = DateTime.now().add(
    Duration(days: int.parse(deadLineExp.firstMatch(name)?.group(1) ?? "7")),
  );

  if (deadLineExp.hasMatch(name)) {
    name = name.replaceAll(deadLineExp, "");
  }

  final timeNeededExp = RegExp(r"\+(\d+)h(p|f)");
  var processType = ProcessType.focus;
  var timeNeeded = const Duration(hours: 3);
  if (timeNeededExp.hasMatch(name)) {
    timeNeeded = Duration(
      hours: int.parse(timeNeededExp.firstMatch(name)?.group(1) ?? "3"),
    );
    processType =
        timeNeededExp.firstMatch(name)?.group(2) == "p"
            ? ProcessType.parallel
            : ProcessType.focus;
    name = name.replaceAll(timeNeededExp, "");
  }

  var newSteps = <Step>[];
  if (lines.length > 1) {
    description = lines
        .sublist(1)
        .where(
          (line) =>
              !(line.startsWith("-") || line.startsWith("+") || line.isEmpty),
        )
        .join("\n");
    newSteps =
        lines.where((line) => line.startsWith("-") || line.startsWith("+")).map(
          (line) {
            var step = steps.firstWhere(
              (s) => s.text == line.substring(1).trim(),
              orElse:
                  () => Step(
                    id: Uuid().v1(),
                    text: line.substring(1).trim(),
                    done: false,
                    isMandatory: line.startsWith("-") ? true : false,
                  ),
            );
            return step.copyWith(
              isMandatory: line.startsWith("-") ? true : false,
            );
          },
        ).toList();
  }

  return Process(
    id: id ?? Uuid().v1(),
    name: name.trim(),
    description: description.trim(),
    isMandatory: isMandatory ?? false,
    processType: processType,
    deadline: deadline,
    timeNeeded: timeNeeded,
    groupName: group ?? "",
    assignedAt: DateTime.now(),
    editAt: DateTime.now(),
    steps: newSteps,
  );
}
