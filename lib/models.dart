import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.g.dart';
part 'models.freezed.dart';

@freezed
@JsonSerializable()
class Process with _$Process {
  Process({
    required this.id,
    required this.name,
    required this.description,
    required this.isMendatary,
    required this.difficultLevel,
    required this.group,
    required this.assignedAt,
    required this.steps,
  });
  final String id;
  final String name;
  final String description;
  final bool isMendatary;
  final int difficultLevel;
  final String group;
  final DateTime assignedAt;
  final List<Step> steps;

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);
  Map<String, dynamic> toJson() => _$ProcessToJson(this);
}

@freezed
@JsonSerializable()
class Step with _$Step {
  Step({
    required this.id,
    required this.text,
    required this.done,
    required this.deadline,
    required this.isMendatary,
  });
  final String id;
  final String text;
  final bool done;
  final DateTime deadline;
  final bool isMendatary;

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
  Map<String, dynamic> toJson() => _$StepToJson(this);
}
