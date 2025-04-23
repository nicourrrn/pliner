// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$prefsHash() => r'72c810c81ec4e71574d451a1a915ba427ad6af98';

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
String _$dioHash() => r'e438ce1c2e57f03d8401c38c9e83aaed6689c6ca';

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
String _$databaseHash() => r'5b617b7287a9aa079742ff29ab99cfb63e73165e';

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
String _$selectedGroupsHash() => r'838db0373ca9aef6c5ef094477ad43ba02ab707d';

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
String _$selectedProcessesHash() => r'96e257f82d599b349240ec9d9dffbc9a61496091';

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
String _$processListHash() => r'6a2b0cbd8d7de4a9d0c8b502d79545a4bf81a0cc';

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
String _$userControllerHash() => r'c19d1f0a72d2c64615c771caa61bd15de1f36305';

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
String _$eventControllerHash() => r'ed5a494f737cabb8c988d9a6e636a99fb2ef8669';

/// See also [EventController].
@ProviderFor(EventController)
final eventControllerProvider =
    AutoDisposeNotifierProvider<EventController, List<Event>>.internal(
      EventController.new,
      name: r'eventControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$eventControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EventController = AutoDisposeNotifier<List<Event>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
