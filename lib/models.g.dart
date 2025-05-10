// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Process _$ProcessFromJson(Map<String, dynamic> json) => Process(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  isMandatory: _intToBoolean(json['isMandatory']),
  processType: $enumDecode(_$ProcessTypeEnumMap, json['processType']),
  groupName: json['groupName'] as String,
  timeNeeded: Duration(microseconds: (json['timeNeeded'] as num).toInt()),
  deadline: DateTime.parse(json['deadline'] as String),
  assignedAt: DateTime.parse(json['assignedAt'] as String),
  steps:
      (json['steps'] as List<dynamic>)
          .map((e) => Step.fromJson(e as Map<String, dynamic>))
          .toList(),
  editAt: DateTime.parse(json['editAt'] as String),
);

Map<String, dynamic> _$ProcessToJson(Process instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'isMandatory': _booleanToInt(instance.isMandatory),
  'processType': _$ProcessTypeEnumMap[instance.processType]!,
  'timeNeeded': instance.timeNeeded.inMicroseconds,
  'groupName': instance.groupName,
  'deadline': instance.deadline.toIso8601String(),
  'assignedAt': instance.assignedAt.toIso8601String(),
  'steps': instance.steps,
  'editAt': instance.editAt.toIso8601String(),
};

const _$ProcessTypeEnumMap = {
  ProcessType.parallel: 'parallel',
  ProcessType.focus: 'focus',
};

Step _$StepFromJson(Map<String, dynamic> json) => Step(
  id: json['id'] as String,
  text: json['text'] as String,
  done: _intToBoolean(json['done']),
  isMandatory: _intToBoolean(json['isMandatory']),
);

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'done': _booleanToInt(instance.done),
  'isMandatory': _booleanToInt(instance.isMandatory),
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

EditAt _$EditAtFromJson(Map<String, dynamic> json) => EditAt(
  id: json['id'] as String,
  editAt: DateTime.parse(json['editAt'] as String),
);

Map<String, dynamic> _$EditAtToJson(EditAt instance) => <String, dynamic>{
  'id': instance.id,
  'editAt': instance.editAt.toIso8601String(),
};

CreateProcessEvent _$CreateProcessEventFromJson(Map<String, dynamic> json) =>
    CreateProcessEvent(
      Process.fromJson(json['process'] as Map<String, dynamic>),
      json['owner'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$CreateProcessEventToJson(CreateProcessEvent instance) =>
    <String, dynamic>{
      'process': instance.process,
      'owner': instance.owner,
      'runtimeType': instance.$type,
    };

DeleteProcessEvent _$DeleteProcessEventFromJson(Map<String, dynamic> json) =>
    DeleteProcessEvent(
      json['processId'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$DeleteProcessEventToJson(DeleteProcessEvent instance) =>
    <String, dynamic>{
      'processId': instance.processId,
      'runtimeType': instance.$type,
    };

UpdateProcessEvent _$UpdateProcessEventFromJson(Map<String, dynamic> json) =>
    UpdateProcessEvent(
      Process.fromJson(json['process'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UpdateProcessEventToJson(UpdateProcessEvent instance) =>
    <String, dynamic>{
      'process': instance.process,
      'runtimeType': instance.$type,
    };

UpdateProcessStepsEvent _$UpdateProcessStepsEventFromJson(
  Map<String, dynamic> json,
) => UpdateProcessStepsEvent(
  json['processId'] as String,
  (json['steps'] as List<dynamic>)
      .map((e) => Step.fromJson(e as Map<String, dynamic>))
      .toList(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$UpdateProcessStepsEventToJson(
  UpdateProcessStepsEvent instance,
) => <String, dynamic>{
  'processId': instance.processId,
  'steps': instance.steps,
  'runtimeType': instance.$type,
};
