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

 List<ExecutedOn> get executedOn;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&const DeepCollectionEquality().equals(other.executedOn, executedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(executedOn));

@override
String toString() {
  return 'Event(executedOn: $executedOn)';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 List<ExecutedOn> executedOn
});




}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? executedOn = null,}) {
  return _then(_self.copyWith(
executedOn: null == executedOn ? _self.executedOn : executedOn // ignore: cast_nullable_to_non_nullable
as List<ExecutedOn>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class CreateProcessEvent implements Event {
   CreateProcessEvent(this.process, final  List<ExecutedOn> executedOn, {final  String? $type}): _executedOn = executedOn,$type = $type ?? 'createProcess';
  factory CreateProcessEvent.fromJson(Map<String, dynamic> json) => _$CreateProcessEventFromJson(json);

 final  Process process;
 final  List<ExecutedOn> _executedOn;
@override List<ExecutedOn> get executedOn {
  if (_executedOn is EqualUnmodifiableListView) return _executedOn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_executedOn);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProcessEventCopyWith<CreateProcessEvent> get copyWith => _$CreateProcessEventCopyWithImpl<CreateProcessEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProcessEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProcessEvent&&(identical(other.process, process) || other.process == process)&&const DeepCollectionEquality().equals(other._executedOn, _executedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,process,const DeepCollectionEquality().hash(_executedOn));

@override
String toString() {
  return 'Event.createProcess(process: $process, executedOn: $executedOn)';
}


}

/// @nodoc
abstract mixin class $CreateProcessEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $CreateProcessEventCopyWith(CreateProcessEvent value, $Res Function(CreateProcessEvent) _then) = _$CreateProcessEventCopyWithImpl;
@override @useResult
$Res call({
 Process process, List<ExecutedOn> executedOn
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
@override @pragma('vm:prefer-inline') $Res call({Object? process = null,Object? executedOn = null,}) {
  return _then(CreateProcessEvent(
null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as Process,null == executedOn ? _self._executedOn : executedOn // ignore: cast_nullable_to_non_nullable
as List<ExecutedOn>,
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
   DeleteProcessEvent(this.processId, final  List<ExecutedOn> executedOn, {final  String? $type}): _executedOn = executedOn,$type = $type ?? 'deleteProcess';
  factory DeleteProcessEvent.fromJson(Map<String, dynamic> json) => _$DeleteProcessEventFromJson(json);

 final  String processId;
 final  List<ExecutedOn> _executedOn;
@override List<ExecutedOn> get executedOn {
  if (_executedOn is EqualUnmodifiableListView) return _executedOn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_executedOn);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteProcessEventCopyWith<DeleteProcessEvent> get copyWith => _$DeleteProcessEventCopyWithImpl<DeleteProcessEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeleteProcessEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteProcessEvent&&(identical(other.processId, processId) || other.processId == processId)&&const DeepCollectionEquality().equals(other._executedOn, _executedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,processId,const DeepCollectionEquality().hash(_executedOn));

@override
String toString() {
  return 'Event.deleteProcess(processId: $processId, executedOn: $executedOn)';
}


}

/// @nodoc
abstract mixin class $DeleteProcessEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $DeleteProcessEventCopyWith(DeleteProcessEvent value, $Res Function(DeleteProcessEvent) _then) = _$DeleteProcessEventCopyWithImpl;
@override @useResult
$Res call({
 String processId, List<ExecutedOn> executedOn
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
@override @pragma('vm:prefer-inline') $Res call({Object? processId = null,Object? executedOn = null,}) {
  return _then(DeleteProcessEvent(
null == processId ? _self.processId : processId // ignore: cast_nullable_to_non_nullable
as String,null == executedOn ? _self._executedOn : executedOn // ignore: cast_nullable_to_non_nullable
as List<ExecutedOn>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class UpdateProcessEvent implements Event {
   UpdateProcessEvent(this.process, final  List<ExecutedOn> executedOn, {final  String? $type}): _executedOn = executedOn,$type = $type ?? 'updateProcess';
  factory UpdateProcessEvent.fromJson(Map<String, dynamic> json) => _$UpdateProcessEventFromJson(json);

 final  Process process;
 final  List<ExecutedOn> _executedOn;
@override List<ExecutedOn> get executedOn {
  if (_executedOn is EqualUnmodifiableListView) return _executedOn;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_executedOn);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProcessEventCopyWith<UpdateProcessEvent> get copyWith => _$UpdateProcessEventCopyWithImpl<UpdateProcessEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProcessEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProcessEvent&&(identical(other.process, process) || other.process == process)&&const DeepCollectionEquality().equals(other._executedOn, _executedOn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,process,const DeepCollectionEquality().hash(_executedOn));

@override
String toString() {
  return 'Event.updateProcess(process: $process, executedOn: $executedOn)';
}


}

/// @nodoc
abstract mixin class $UpdateProcessEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $UpdateProcessEventCopyWith(UpdateProcessEvent value, $Res Function(UpdateProcessEvent) _then) = _$UpdateProcessEventCopyWithImpl;
@override @useResult
$Res call({
 Process process, List<ExecutedOn> executedOn
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
@override @pragma('vm:prefer-inline') $Res call({Object? process = null,Object? executedOn = null,}) {
  return _then(UpdateProcessEvent(
null == process ? _self.process : process // ignore: cast_nullable_to_non_nullable
as Process,null == executedOn ? _self._executedOn : executedOn // ignore: cast_nullable_to_non_nullable
as List<ExecutedOn>,
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

// dart format on
