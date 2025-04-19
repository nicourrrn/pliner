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
  processType: $enumDecode(_$ProcessTypeEnumMap, json['processType']),
  group: json['group'] as String,
  timeNeeded: Duration(microseconds: (json['timeNeeded'] as num).toInt()),
  deadline: DateTime.parse(json['deadline'] as String),
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
  'processType': _$ProcessTypeEnumMap[instance.processType]!,
  'timeNeeded': instance.timeNeeded.inMicroseconds,
  'group': instance.group,
  'deadline': instance.deadline.toIso8601String(),
  'assignedAt': instance.assignedAt.toIso8601String(),
  'steps': instance.steps,
};

const _$ProcessTypeEnumMap = {
  ProcessType.parrallel: 'parrallel',
  ProcessType.focus: 'focus',
};

Step _$StepFromJson(Map<String, dynamic> json) => Step(
  id: json['id'] as String,
  text: json['text'] as String,
  done: json['done'] as bool,
  isMendatary: json['isMendatary'] as bool,
);

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'done': instance.done,
  'isMendatary': instance.isMendatary,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  username: json['username'] as String,
  password: json['password'] as String,
  token: json['token'] as String?,
  isLoggedIn: json['isLoggedIn'] as bool? ?? false,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
  'token': instance.token,
  'isLoggedIn': instance.isLoggedIn,
};
