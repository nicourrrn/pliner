// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Process {

 String get id; String get name; String get description; bool get isMandatory; ProcessType get processType; Duration get timeNeeded; String get groupName; DateTime get deadline; DateTime get assignedAt; List<Step> get steps; DateTime get editAt;
/// Create a copy of Process
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessCopyWith<Process> get copyWith => _$ProcessCopyWithImpl<Process>(this as Process, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Process&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isMandatory, isMandatory) || other.isMandatory == isMandatory)&&(identical(other.processType, processType) || other.processType == processType)&&(identical(other.timeNeeded, timeNeeded) || other.timeNeeded == timeNeeded)&&(identical(other.groupName, groupName) || other.groupName == groupName)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&const DeepCollectionEquality().equals(other.steps, steps)&&(identical(other.editAt, editAt) || other.editAt == editAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,isMandatory,processType,timeNeeded,groupName,deadline,assignedAt,const DeepCollectionEquality().hash(steps),editAt);

@override
String toString() {
  return 'Process(id: $id, name: $name, description: $description, isMandatory: $isMandatory, processType: $processType, timeNeeded: $timeNeeded, groupName: $groupName, deadline: $deadline, assignedAt: $assignedAt, steps: $steps, editAt: $editAt)';
}


}

/// @nodoc
abstract mixin class $ProcessCopyWith<$Res>  {
  factory $ProcessCopyWith(Process value, $Res Function(Process) _then) = _$ProcessCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, bool isMandatory, ProcessType processType, String groupName, Duration timeNeeded, DateTime deadline, DateTime assignedAt, List<Step> steps, DateTime editAt
});




}
/// @nodoc
class _$ProcessCopyWithImpl<$Res>
    implements $ProcessCopyWith<$Res> {
  _$ProcessCopyWithImpl(this._self, this._then);

  final Process _self;
  final $Res Function(Process) _then;

/// Create a copy of Process
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? isMandatory = null,Object? processType = null,Object? groupName = null,Object? timeNeeded = null,Object? deadline = null,Object? assignedAt = null,Object? steps = null,Object? editAt = null,}) {
  return _then(Process(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isMandatory: null == isMandatory ? _self.isMandatory : isMandatory // ignore: cast_nullable_to_non_nullable
as bool,processType: null == processType ? _self.processType : processType // ignore: cast_nullable_to_non_nullable
as ProcessType,groupName: null == groupName ? _self.groupName : groupName // ignore: cast_nullable_to_non_nullable
as String,timeNeeded: null == timeNeeded ? _self.timeNeeded : timeNeeded // ignore: cast_nullable_to_non_nullable
as Duration,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<Step>,editAt: null == editAt ? _self.editAt : editAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}



/// @nodoc
mixin _$Step {

 String get id; String get text; bool get done; bool get isMandatory;
/// Create a copy of Step
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepCopyWith<Step> get copyWith => _$StepCopyWithImpl<Step>(this as Step, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Step&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.done, done) || other.done == done)&&(identical(other.isMandatory, isMandatory) || other.isMandatory == isMandatory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,done,isMandatory);

@override
String toString() {
  return 'Step(id: $id, text: $text, done: $done, isMandatory: $isMandatory)';
}


}

/// @nodoc
abstract mixin class $StepCopyWith<$Res>  {
  factory $StepCopyWith(Step value, $Res Function(Step) _then) = _$StepCopyWithImpl;
@useResult
$Res call({
 String id, String text, bool done, bool isMandatory
});




}
/// @nodoc
class _$StepCopyWithImpl<$Res>
    implements $StepCopyWith<$Res> {
  _$StepCopyWithImpl(this._self, this._then);

  final Step _self;
  final $Res Function(Step) _then;

/// Create a copy of Step
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? done = null,Object? isMandatory = null,}) {
  return _then(Step(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,isMandatory: null == isMandatory ? _self.isMandatory : isMandatory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}



/// @nodoc
mixin _$User {

 String get username; String get password; String? get token; bool get isLoggedIn;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.token, token) || other.token == token)&&(identical(other.isLoggedIn, isLoggedIn) || other.isLoggedIn == isLoggedIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password,token,isLoggedIn);

@override
String toString() {
  return 'User(username: $username, password: $password, token: $token, isLoggedIn: $isLoggedIn)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String username, String password, String? token, bool isLoggedIn
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = null,Object? token = freezed,Object? isLoggedIn = null,}) {
  return _then(User(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,isLoggedIn: null == isLoggedIn ? _self.isLoggedIn : isLoggedIn // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


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
