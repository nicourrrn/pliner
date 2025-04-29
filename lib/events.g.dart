// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
