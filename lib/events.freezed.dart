// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
Event _$EventFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'createProcess':
          return CreateProcessEvent.fromJson(
            json
          );
                case 'deleteProcess':
          return DeleteProcessEvent.fromJson(
            json
          );
                case 'updateProcess':
          return UpdateProcessEvent.fromJson(
            json
          );
                case 'updateProcessSteps':
          return UpdateProcessStepsEvent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'Event',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$Event {



  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Event()';
}


}

/// @nodoc
class $EventCopyWith<$Res>  {
$EventCopyWith(Event _, $Res Function(Event) __);
}


/// @nodoc
@JsonSerializable()

class CreateProcessEvent implements Event {
   CreateProcessEvent(this.process, this.owner, {final  String? $type}): $type = $type ?? 'createProcess';
  factory CreateProcessEvent.fromJson(Map<String, dynamic> json) => _$CreateProcessEventFromJson(json);

 final  Process process;
 final  String owner;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProcessEventCopyWith<CreateProcessEvent> get copyWith => _$CreateProcessEventCopyWithImpl<CreateProcessEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProcessEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProcessEvent&&(identical(other.process, process) || other.process == process)&&(identical(other.owner, owner) || other.owner == owner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,process,owner);

@override
String toString() {
  return 'Event.createProcess(process: $process, owner: $owner)';
}


}

/// @nodoc
abstract mixin class $CreateProcessEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $CreateProcessEventCopyWith(CreateProcessEvent value, $Res Function(CreateProcessEvent) _then) = _$CreateProcessEventCopyWithImpl;
@useResult
$Res call({
 Process process, String owner
});


$ProcessCopyWith<$Res> get process;

}
/// @nodoc
class _$CreateProcessEventCopyWithImpl<$Res>
    implements $CreateProcessEventCopyWith<$Res> {
  _$CreateProcessEventCopyWithImpl(this._self, this._then);

  final CreateProcessEvent _self;
  final $Res Function(CreateProcessEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? process = null,Object? owner = null,}) {
  return _then(CreateProcessEvent(
null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as Process,null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProcessCopyWith<$Res> get process {
  
  return $ProcessCopyWith<$Res>(_self.process, (value) {
    return _then(_self.copyWith(process: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class DeleteProcessEvent implements Event {
   DeleteProcessEvent(this.processId, {final  String? $type}): $type = $type ?? 'deleteProcess';
  factory DeleteProcessEvent.fromJson(Map<String, dynamic> json) => _$DeleteProcessEventFromJson(json);

 final  String processId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteProcessEventCopyWith<DeleteProcessEvent> get copyWith => _$DeleteProcessEventCopyWithImpl<DeleteProcessEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteProcessEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteProcessEvent&&(identical(other.processId, processId) || other.processId == processId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processId);

@override
String toString() {
  return 'Event.deleteProcess(processId: $processId)';
}


}

/// @nodoc
abstract mixin class $DeleteProcessEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $DeleteProcessEventCopyWith(DeleteProcessEvent value, $Res Function(DeleteProcessEvent) _then) = _$DeleteProcessEventCopyWithImpl;
@useResult
$Res call({
 String processId
});




}
/// @nodoc
class _$DeleteProcessEventCopyWithImpl<$Res>
    implements $DeleteProcessEventCopyWith<$Res> {
  _$DeleteProcessEventCopyWithImpl(this._self, this._then);

  final DeleteProcessEvent _self;
  final $Res Function(DeleteProcessEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? processId = null,}) {
  return _then(DeleteProcessEvent(
null == processId ? _self.processId : processId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UpdateProcessEvent implements Event {
   UpdateProcessEvent(this.process, {final  String? $type}): $type = $type ?? 'updateProcess';
  factory UpdateProcessEvent.fromJson(Map<String, dynamic> json) => _$UpdateProcessEventFromJson(json);

 final  Process process;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProcessEventCopyWith<UpdateProcessEvent> get copyWith => _$UpdateProcessEventCopyWithImpl<UpdateProcessEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProcessEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProcessEvent&&(identical(other.process, process) || other.process == process));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,process);

@override
String toString() {
  return 'Event.updateProcess(process: $process)';
}


}

/// @nodoc
abstract mixin class $UpdateProcessEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $UpdateProcessEventCopyWith(UpdateProcessEvent value, $Res Function(UpdateProcessEvent) _then) = _$UpdateProcessEventCopyWithImpl;
@useResult
$Res call({
 Process process
});


$ProcessCopyWith<$Res> get process;

}
/// @nodoc
class _$UpdateProcessEventCopyWithImpl<$Res>
    implements $UpdateProcessEventCopyWith<$Res> {
  _$UpdateProcessEventCopyWithImpl(this._self, this._then);

  final UpdateProcessEvent _self;
  final $Res Function(UpdateProcessEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? process = null,}) {
  return _then(UpdateProcessEvent(
null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as Process,
  ));
}

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProcessCopyWith<$Res> get process {
  
  return $ProcessCopyWith<$Res>(_self.process, (value) {
    return _then(_self.copyWith(process: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class UpdateProcessStepsEvent implements Event {
   UpdateProcessStepsEvent(this.processId, final  List<Step> steps, {final  String? $type}): _steps = steps,$type = $type ?? 'updateProcessSteps';
  factory UpdateProcessStepsEvent.fromJson(Map<String, dynamic> json) => _$UpdateProcessStepsEventFromJson(json);

 final  String processId;
 final  List<Step> _steps;
 List<Step> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProcessStepsEventCopyWith<UpdateProcessStepsEvent> get copyWith => _$UpdateProcessStepsEventCopyWithImpl<UpdateProcessStepsEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProcessStepsEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProcessStepsEvent&&(identical(other.processId, processId) || other.processId == processId)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processId,const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'Event.updateProcessSteps(processId: $processId, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $UpdateProcessStepsEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $UpdateProcessStepsEventCopyWith(UpdateProcessStepsEvent value, $Res Function(UpdateProcessStepsEvent) _then) = _$UpdateProcessStepsEventCopyWithImpl;
@useResult
$Res call({
 String processId, List<Step> steps
});




}
/// @nodoc
class _$UpdateProcessStepsEventCopyWithImpl<$Res>
    implements $UpdateProcessStepsEventCopyWith<$Res> {
  _$UpdateProcessStepsEventCopyWithImpl(this._self, this._then);

  final UpdateProcessStepsEvent _self;
  final $Res Function(UpdateProcessStepsEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? processId = null,Object? steps = null,}) {
  return _then(UpdateProcessStepsEvent(
null == processId ? _self.processId : processId // ignore: cast_nullable_to_non_nullable
as String,null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<Step>,
  ));
}


}

// dart format on
