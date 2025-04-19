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

 String get id; String get name; String get description; bool get isMendatary; ProcessType get processType; Duration get timeNeeded; String get group; DateTime get deadline; DateTime get assignedAt; List<Step> get steps;
/// Create a copy of Process
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessCopyWith<Process> get copyWith => _$ProcessCopyWithImpl<Process>(this as Process, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Process&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isMendatary, isMendatary) || other.isMendatary == isMendatary)&&(identical(other.processType, processType) || other.processType == processType)&&(identical(other.timeNeeded, timeNeeded) || other.timeNeeded == timeNeeded)&&(identical(other.group, group) || other.group == group)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,isMendatary,processType,timeNeeded,group,deadline,assignedAt,const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'Process(id: $id, name: $name, description: $description, isMendatary: $isMendatary, processType: $processType, timeNeeded: $timeNeeded, group: $group, deadline: $deadline, assignedAt: $assignedAt, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $ProcessCopyWith<$Res>  {
  factory $ProcessCopyWith(Process value, $Res Function(Process) _then) = _$ProcessCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, bool isMendatary, ProcessType processType, String group, Duration timeNeeded, DateTime deadline, DateTime assignedAt, List<Step> steps
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? isMendatary = null,Object? processType = null,Object? group = null,Object? timeNeeded = null,Object? deadline = null,Object? assignedAt = null,Object? steps = null,}) {
  return _then(Process(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isMendatary: null == isMendatary ? _self.isMendatary : isMendatary // ignore: cast_nullable_to_non_nullable
as bool,processType: null == processType ? _self.processType : processType // ignore: cast_nullable_to_non_nullable
as ProcessType,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,timeNeeded: null == timeNeeded ? _self.timeNeeded : timeNeeded // ignore: cast_nullable_to_non_nullable
as Duration,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<Step>,
  ));
}

}



/// @nodoc
mixin _$Step {

 String get id; String get text; bool get done; bool get isMendatary;
/// Create a copy of Step
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepCopyWith<Step> get copyWith => _$StepCopyWithImpl<Step>(this as Step, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Step&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.done, done) || other.done == done)&&(identical(other.isMendatary, isMendatary) || other.isMendatary == isMendatary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,done,isMendatary);

@override
String toString() {
  return 'Step(id: $id, text: $text, done: $done, isMendatary: $isMendatary)';
}


}

/// @nodoc
abstract mixin class $StepCopyWith<$Res>  {
  factory $StepCopyWith(Step value, $Res Function(Step) _then) = _$StepCopyWithImpl;
@useResult
$Res call({
 String id, String text, bool done, bool isMendatary
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? done = null,Object? isMendatary = null,}) {
  return _then(Step(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,isMendatary: null == isMendatary ? _self.isMendatary : isMendatary // ignore: cast_nullable_to_non_nullable
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


// dart format on
