// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProcessEvent _$CreateProcessEventFromJson(Map<String, dynamic> json) =>
    CreateProcessEvent(
      Process.fromJson(json['process'] as Map<String, dynamic>),
      executedOn:
          (json['executedOn'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ExecutedOnEnumMap, e))
              .toList() ??
          const [],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$CreateProcessEventToJson(CreateProcessEvent instance) =>
    <String, dynamic>{
      'process': instance.process,
      'executedOn':
          instance.executedOn.map((e) => _$ExecutedOnEnumMap[e]!).toList(),
      'runtimeType': instance.$type,
    };

const _$ExecutedOnEnumMap = {
  ExecutedOn.local: 'local',
  ExecutedOn.server: 'server',
};

DeleteProcessEvent _$DeleteProcessEventFromJson(Map<String, dynamic> json) =>
    DeleteProcessEvent(
      json['processId'] as String,
      executedOn:
          (json['executedOn'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ExecutedOnEnumMap, e))
              .toList() ??
          const [],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$DeleteProcessEventToJson(DeleteProcessEvent instance) =>
    <String, dynamic>{
      'processId': instance.processId,
      'executedOn':
          instance.executedOn.map((e) => _$ExecutedOnEnumMap[e]!).toList(),
      'runtimeType': instance.$type,
    };

UpdateProcessEvent _$UpdateProcessEventFromJson(Map<String, dynamic> json) =>
    UpdateProcessEvent(
      Process.fromJson(json['process'] as Map<String, dynamic>),
      executedOn:
          (json['executedOn'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ExecutedOnEnumMap, e))
              .toList() ??
          const [],
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UpdateProcessEventToJson(UpdateProcessEvent instance) =>
    <String, dynamic>{
      'process': instance.process,
      'executedOn':
          instance.executedOn.map((e) => _$ExecutedOnEnumMap[e]!).toList(),
      'runtimeType': instance.$type,
    };

UpdateProcessStepsEvent _$UpdateProcessStepsEventFromJson(
  Map<String, dynamic> json,
) => UpdateProcessStepsEvent(
  json['processId'] as String,
  (json['steps'] as List<dynamic>)
      .map((e) => Step.fromJson(e as Map<String, dynamic>))
      .toList(),
  executedOn:
      (json['executedOn'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$ExecutedOnEnumMap, e))
          .toList() ??
      const [],
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$UpdateProcessStepsEventToJson(
  UpdateProcessStepsEvent instance,
) => <String, dynamic>{
  'processId': instance.processId,
  'steps': instance.steps,
  'executedOn':
      instance.executedOn.map((e) => _$ExecutedOnEnumMap[e]!).toList(),
  'runtimeType': instance.$type,
};
