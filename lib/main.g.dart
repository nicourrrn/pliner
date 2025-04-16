// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

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

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$processGroupsListHash() => r'f2e7a3f2e7cc9601270919ac417f61b3f4b56321';

/// See also [processGroupsList].
@ProviderFor(processGroupsList)
final processGroupsListProvider = AutoDisposeProvider<List<String>>.internal(
  processGroupsList,
  name: r'processGroupsListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$processGroupsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProcessGroupsListRef = AutoDisposeProviderRef<List<String>>;
String _$sortedProcessHash() => r'054f4899c667017b06e0c9dd6a13ae7bbd0d4f94';

/// See also [sortedProcess].
@ProviderFor(sortedProcess)
final sortedProcessProvider = AutoDisposeProvider<List<Process>>.internal(
  sortedProcess,
  name: r'sortedProcessProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sortedProcessHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SortedProcessRef = AutoDisposeProviderRef<List<Process>>;
String _$selectedGroupsHash() => r'6399dc494adf7091112038032aa75c20799c666f';

/// See also [SelectedGroups].
@ProviderFor(SelectedGroups)
final selectedGroupsProvider =
    AutoDisposeNotifierProvider<SelectedGroups, List<String>>.internal(
      SelectedGroups.new,
      name: r'selectedGroupsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedGroupsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedGroups = AutoDisposeNotifier<List<String>>;
String _$selectedProcessesHash() => r'cadd3de7acc6d21e06eeb35cd2741bfa739100b5';

/// See also [SelectedProcesses].
@ProviderFor(SelectedProcesses)
final selectedProcessesProvider =
    AutoDisposeNotifierProvider<SelectedProcesses, List<String>>.internal(
      SelectedProcesses.new,
      name: r'selectedProcessesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedProcessesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedProcesses = AutoDisposeNotifier<List<String>>;
String _$processListHash() => r'd29d0184e055bfdcb566539e3e208bc8aa1bbabb';

/// See also [ProcessList].
@ProviderFor(ProcessList)
final processListProvider =
    AutoDisposeNotifierProvider<ProcessList, List<Process>>.internal(
      ProcessList.new,
      name: r'processListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$processListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProcessList = AutoDisposeNotifier<List<Process>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
