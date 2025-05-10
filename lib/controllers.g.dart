// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deadlinesHash() => r'2dba6bf16c85f485136f14780808d2a6afb96e0b';

/// See also [deadlines].
@ProviderFor(deadlines)
final deadlinesProvider = AutoDisposeProvider<List<DateTime>>.internal(
  deadlines,
  name: r'deadlinesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$deadlinesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeadlinesRef = AutoDisposeProviderRef<List<DateTime>>;
String _$prefsHash() => r'5e2d3760c67ad5e43dda1c598879b6b771bb40c0';

/// See also [prefs].
@ProviderFor(prefs)
final prefsProvider = AutoDisposeFutureProvider<SharedPreferences>.internal(
  prefs,
  name: r'prefsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$prefsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PrefsRef = AutoDisposeFutureProviderRef<SharedPreferences>;
String _$dioHash() => r'362703008cb49bcb07a3e800b25bec7b4df41ee4';

/// See also [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = AutoDisposeProviderRef<Dio>;
String _$databaseHash() => r'4c723b831d62544eeb3262144f68cb79ff9b4f15';

/// See also [database].
@ProviderFor(database)
final databaseProvider = AutoDisposeFutureProvider<Database>.internal(
  database,
  name: r'databaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$databaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DatabaseRef = AutoDisposeFutureProviderRef<Database>;
String _$selectedGroupsHash() => r'7b034f35243919249a2246d35e935d482b219de1';

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
String _$selectedProcessesHash() => r'1f3e64b54bc35667a49a7e0f06e6e325dc0cecc0';

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
String _$processListHash() => r'2e3d175d34bc0fadaf40a9925152f030dc18cdf8';

/// See also [ProcessList].
@ProviderFor(ProcessList)
final processListProvider =
    AutoDisposeNotifierProvider<ProcessList, List<models.Process>>.internal(
      ProcessList.new,
      name: r'processListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$processListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProcessList = AutoDisposeNotifier<List<models.Process>>;
String _$userControllerHash() => r'fade36e2b06ebbb857056fcf56c127aa768f2ea3';

/// See also [UserController].
@ProviderFor(UserController)
final userControllerProvider =
    AutoDisposeNotifierProvider<UserController, models.User>.internal(
      UserController.new,
      name: r'userControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserController = AutoDisposeNotifier<models.User>;
String _$eventControllerHash() => r'8fa4369ecf6adec7db91590822216e593e114420';

/// See also [EventController].
@ProviderFor(EventController)
final eventControllerProvider =
    AutoDisposeNotifierProvider<EventController, List<models.Event>>.internal(
      EventController.new,
      name: r'eventControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$eventControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EventController = AutoDisposeNotifier<List<models.Event>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
