import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'models.g.dart';
part 'models.freezed.dart';

enum ProcessType {
  parallel("Parallel"),
  focus("Focus");

  final String name;
  const ProcessType(this.name);
}

@freezed
@JsonSerializable()
class Process with _$Process {
  Process({
    required this.id,
    required this.name,
    required this.description,
    required this.isMandatory,
    required this.processType,
    required this.group,
    required this.timeNeeded,
    required this.deadline,
    required this.assignedAt,
    required this.steps,
    required this.editAt,
  });
  final String id;
  final String name;
  final String description;
  final bool isMandatory;
  final ProcessType processType;
  final Duration timeNeeded;
  final String group;
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
    group: '',
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
  final bool done;
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
}
