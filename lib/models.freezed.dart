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

 String get id; String get name; String get description; bool get isMendatary; int get difficultLevel; String get group; DateTime get assignedAt; List<Step> get steps;
/// Create a copy of Process
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcessCopyWith<Process> get copyWith => _$ProcessCopyWithImpl<Process>(this as Process, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Process&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.isMendatary, isMendatary) || other.isMendatary == isMendatary)&&(identical(other.difficultLevel, difficultLevel) || other.difficultLevel == difficultLevel)&&(identical(other.group, group) || other.group == group)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,isMendatary,difficultLevel,group,assignedAt,const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'Process(id: $id, name: $name, description: $description, isMendatary: $isMendatary, difficultLevel: $difficultLevel, group: $group, assignedAt: $assignedAt, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $ProcessCopyWith<$Res>  {
  factory $ProcessCopyWith(Process value, $Res Function(Process) _then) = _$ProcessCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, bool isMendatary, int difficultLevel, String group, DateTime assignedAt, List<Step> steps
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? isMendatary = null,Object? difficultLevel = null,Object? group = null,Object? assignedAt = null,Object? steps = null,}) {
  return _then(Process(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isMendatary: null == isMendatary ? _self.isMendatary : isMendatary // ignore: cast_nullable_to_non_nullable
as bool,difficultLevel: null == difficultLevel ? _self.difficultLevel : difficultLevel // ignore: cast_nullable_to_non_nullable
as int,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<Step>,
  ));
}

}



/// @nodoc
mixin _$Step {

 String get id; String get text; bool get done; DateTime get deadline; bool get isMendatary;
/// Create a copy of Step
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepCopyWith<Step> get copyWith => _$StepCopyWithImpl<Step>(this as Step, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Step&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.done, done) || other.done == done)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.isMendatary, isMendatary) || other.isMendatary == isMendatary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,done,deadline,isMendatary);

@override
String toString() {
  return 'Step(id: $id, text: $text, done: $done, deadline: $deadline, isMendatary: $isMendatary)';
}


}

/// @nodoc
abstract mixin class $StepCopyWith<$Res>  {
  factory $StepCopyWith(Step value, $Res Function(Step) _then) = _$StepCopyWithImpl;
@useResult
$Res call({
 String id, String text, bool done, DateTime deadline, bool isMendatary
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? done = null,Object? deadline = null,Object? isMendatary = null,}) {
  return _then(Step(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,isMendatary: null == isMendatary ? _self.isMendatary : isMendatary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


// dart format on
