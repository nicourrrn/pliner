// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Process _$ProcessFromJson(Map<String, dynamic> json) => Process(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  isMendatary: json['isMendatary'] as bool,
  difficultLevel: (json['difficultLevel'] as num).toInt(),
  group: json['group'] as String,
  assignedAt: DateTime.parse(json['assignedAt'] as String),
  steps:
      (json['steps'] as List<dynamic>)
          .map((e) => Step.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ProcessToJson(Process instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'isMendatary': instance.isMendatary,
  'difficultLevel': instance.difficultLevel,
  'group': instance.group,
  'assignedAt': instance.assignedAt.toIso8601String(),
  'steps': instance.steps,
};

Step _$StepFromJson(Map<String, dynamic> json) => Step(
  id: json['id'] as String,
  text: json['text'] as String,
  done: json['done'] as bool,
  deadline: DateTime.parse(json['deadline'] as String),
  isMendatary: json['isMendatary'] as bool,
);

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'done': instance.done,
  'deadline': instance.deadline.toIso8601String(),
  'isMendatary': instance.isMendatary,
};
