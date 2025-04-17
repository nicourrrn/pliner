import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'models.g.dart';
part 'models.freezed.dart';

enum ProcessType { parrallel, focus }

@freezed
@JsonSerializable()
class Process with _$Process {
  Process({
    required this.id,
    required this.name,
    required this.description,
    required this.isMendatary,
    required this.processType,
    required this.group,
    required this.timeNeeded,
    required this.deadline,
    required this.assignedAt,
    required this.steps,
  });
  final String id;
  final String name;
  final String description;
  final bool isMendatary;
  final ProcessType processType;
  final Duration timeNeeded;
  final String group;
  final DateTime deadline;
  final DateTime assignedAt;
  final List<Step> steps;

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);
  Map<String, dynamic> toJson() => _$ProcessToJson(this);

  factory Process.zero() => Process(
    id: Uuid().v1(),
    name: '[]',
    description: '',
    isMendatary: false,
    processType: ProcessType.focus,
    deadline: DateTime.now().add(const Duration(days: 7)),
    group: '',
    timeNeeded: const Duration(hours: 3),
    assignedAt: DateTime.now(),
    steps: [],
  );
}

@freezed
@JsonSerializable()
class Step with _$Step {
  Step({
    required this.id,
    required this.text,
    required this.done,
    required this.isMendatary,
  });
  final String id;
  final String text;
  final bool done;
  final bool isMendatary;

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
  Map<String, dynamic> toJson() => _$StepToJson(this);
}
