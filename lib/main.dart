import 'dart:io';

import "package:gap/gap.dart";
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import "package:go_router/go_router.dart";
import 'package:date_format/date_format.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import "package:file_picker/file_picker.dart";
import "dart:convert";
import "package:path_provider/path_provider.dart";
import "package:uuid/uuid.dart";

part 'main.g.dart';
part 'main.freezed.dart';

final processNameFilterProvider = StateProvider<String>((ref) => "");

@riverpod
class SelectedGroups extends _$SelectedGroups {
  @override
  List<String> build() {
    return [];
  }

  deleteRemovedGroups() {
    final groups = ref.read(processGroupsListProvider);
    state = state.where((group) => groups.contains(group)).toList();
  }

  toggleGroup(String group) {
    deleteRemovedGroups();
    if (state.contains(group)) {
      state = state.where((g) => g != group).toList();
    } else {
      state = [...state, group];
    }
  }

  addGroup(String group) {
    state = [...state, group];
  }

  removeGroup(String group) {
    state = state.where((g) => g != group).toList();
  }

  cleanState() {
    state = [];
  }
}

@riverpod
class SelectedProcesses extends _$SelectedProcesses {
  @override
  List<String> build() {
    return [];
  }

  toggleProcess(String processId) {
    if (state.contains(processId)) {
      state = state.where((id) => id != processId).toList();
    } else {
      state = [...state, processId];
    }
  }

  addProcess(String processId) {
    state = [...state, processId];
  }

  removeProcess(String processId) {
    state = state.where((id) => id != processId).toList();
  }

  cleanState() {
    state = [];
  }
}

@riverpod
List<String> processGroupsList(Ref ref) {
  return ref
      .watch(processListProvider)
      .map((process) => process.group)
      .toSet()
      .toList();
}

@riverpod
class ProcessList extends _$ProcessList {
  @override
  List<Process> build() {
    _loadProcesses();
    return [];
  }

  _loadProcesses() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/processes.json');
    if (!file.existsSync()) {
      return;
    }
    final jsonString = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(jsonString);
    state =
        jsonList.map((json) => Process.fromJson(json)).toList().cast<Process>();
  }

  updateProcessSteps(String processId, List<Step> steps) {
    state =
        state.map((process) {
          if (process.id == processId) {
            return process.copyWith(steps: steps);
          }
          return process;
        }).toList();
  }

  appendProcess(Process process) {
    state = [...state, process];
  }

  appendOrReplaceProcess(Process process) {
    state = state.where((p) => p.id != process.id).toList();
    state = [...state, process];
  }

  removeProcess(List<String> processIds) {
    state = state.where((process) => !processIds.contains(process.id)).toList();
  }
}

@riverpod
List<Process> sortedProcess(Ref ref) {
  var processes = ref.watch(processListProvider);
  processes.sort((a, b) {
    if (a.isMendatary && b.isMendatary) return 0;
    if (a.isMendatary) return -1;
    return 1;
  });
  if (ref.watch(selectedGroupsProvider).isNotEmpty) {
    processes =
        processes
            .where(
              (process) =>
                  ref.watch(selectedGroupsProvider).contains(process.group),
            )
            .toList();
  }

  if (ref.watch(processNameFilterProvider).isNotEmpty) {
    processes =
        processes
            .where(
              (process) => process.name.toLowerCase().contains(
                ref.watch(processNameFilterProvider).toLowerCase(),
              ),
            )
            .toList();
  }

  return processes;
}

loadProcesses(WidgetRef ref) async {
  final result = await FilePicker.platform.pickFiles();
  if (result == null) return;
  var file = jsonDecode(await File(result.files.single.path!).readAsString());
  for (var process in file) {
    final newProcess = Process.fromJson(process);
    ref.read(processListProvider.notifier).appendProcess(newProcess);
  }
}

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MyHomePage()),
    GoRoute(
      path: "/process/create",
      builder: (context, state) => const ProcessCreateView(),
    ),
    GoRoute(
      path: "/process/:processId",
      builder: (context, state) {
        final processId = state.pathParameters['processId']!;
        return ProcessDetailView(processId: processId);
      },
    ),
    GoRoute(
      path: "/process/:processId/edit",
      builder: (context, state) {
        final processId = state.pathParameters['processId']!;
        return ProcessCreateView(processId: processId);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Task manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SearchBar(
            hintText: "Search",
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            ),
            elevation: WidgetStateProperty.all(1),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            onChanged: (value) {
              ref.read(processNameFilterProvider.notifier).state = value;
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              final directory = await getApplicationDocumentsDirectory();
              final file = File('${directory.path}/processes.json');
              final jsonString = jsonEncode(
                ref
                    .read(processListProvider)
                    .map((process) => process.toJson())
                    .toList(),
              );
              await file.writeAsString(jsonString);
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              await loadProcesses(ref);
            },
          ),
          if (ref.watch(selectedProcessesProvider).isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref
                    .read(processListProvider.notifier)
                    .removeProcess(ref.watch(selectedProcessesProvider));
                ref.read(selectedProcessesProvider.notifier).cleanState();
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/process/create");
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Gap(8.0),
                itemCount: ref.watch(sortedProcessProvider).length,
                itemBuilder: (context, index) {
                  final process = ref.watch(sortedProcessProvider)[index];
                  return Padding(
                    padding: EdgeInsets.only(top: index == 0 ? 8.0 : 0),
                    child: ProcessListTile(processId: process.id),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children:
                    ref
                        .watch(processGroupsListProvider)
                        .map(
                          (group) => FilterChip(
                            label: Text(group),
                            onSelected:
                                (value) => ref
                                    .read(selectedGroupsProvider.notifier)
                                    .toggleGroup(group),
                            selected: ref
                                .watch(selectedGroupsProvider)
                                .contains(group),
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),

      // body: CustomScrollView(
      //   slivers: [
      //     SliverList(
      //       delegate: SliverChildBuilderDelegate((context, index) {
      //         final processId = ref.watch(sortedProcessProvider)[index].id;
      //         return ProcessListTile(processId: processId);
      //       }, childCount: ref.watch(sortedProcessProvider).length),
      //     ),
      //
      //     SliverToBoxAdapter(
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Wrap(
      //           spacing: 8.0,
      //           runSpacing: 8.0,
      //           children:
      //               ref
      //                   .watch(processGroupsListProvider)
      //                   .map((group) => Chip(label: Text(group)))
      //                   .toList(),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),

      // body: Stack(
      //   children: [
      //     Positioned.fill(
      //       child: ListView.builder(
      //         itemCount: ref.watch(sortedProcessProvider).length,
      //         itemBuilder: (context, index) {
      //           final processId = ref.watch(sortedProcessProvider)[index].id;
      //           return ProcessListTile(processId: processId);
      //         },
      //       ),
      //     ),
      //     Positioned(
      //       bottom: 0,
      //       left: 0,
      //       right: 0,
      //       top: 0,
      //       child: Container(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Wrap(
      //           spacing: 2.0,
      //           children:
      //               ref
      //                   .watch(processGroupsListProvider)
      //                   .map((group) => Text(group))
      //                   .toList(),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class ProcessListTile extends HookConsumerWidget {
  const ProcessListTile({super.key, required this.processId});
  final String processId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final process = ref
        .watch(processListProvider)
        .firstWhere((process) => process.id == processId);
    final selectedProcesses = ref.watch(selectedProcessesProvider);
    final color = useState(
      process.isMendatary ? Colors.grey[400] : Colors.grey[150],
    );

    if (selectedProcesses.contains(processId)) {
      color.value = Colors.red[400];
    } else if (process.isMendatary) {
      color.value = Colors.grey[400];
    } else {
      color.value = Colors.grey[150];
    }

    return Badge(
      alignment: Alignment.topLeft,
      label:
          process.isMendatary
              ? const Text("Mendatary")
              : const Text("Not mendatary"),

      backgroundColor: process.isMendatary ? Colors.red[400] : Colors.grey[400],
      child: ListTile(
        title: Text(process.name),
        subtitle: Text(process.group),
        trailing: Text(process.difficultLevel.toString()),
        onTap: () {
          context.push("/process/${process.id}");
        },
        tileColor: color.value,

        onLongPress: () {
          ref
              .read(selectedProcessesProvider.notifier)
              .toggleProcess(process.id);
        },
      ),
    );
  }
}

class ProcessDetailView extends HookConsumerWidget {
  const ProcessDetailView({super.key, required this.processId});
  final String processId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final process = ref
        .watch(processListProvider)
        .firstWhere((p) => p.id == processId);
    return Scaffold(
      appBar: AppBar(
        title: Text(process.name),
        actions: [
          Text(process.difficultLevel.toString()),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push("/process/${process.id}/edit");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(process.description, style: TextStyle(fontSize: 18)),
            const Gap(32),
            Expanded(child: StepListView(processId: processId)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(process.group, style: TextStyle(fontSize: 16)),
                Text(
                  'Assigned At: ${formatDate(process.assignedAt, [yy, '-', mm, '-', dd])}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StepListView extends HookConsumerWidget {
  const StepListView({super.key, required this.processId});
  final String processId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps =
        ref
            .watch(processListProvider)
            .firstWhere((process) => process.id == processId)
            .steps;
    return ListView.builder(
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return ListTile(
          title: Text(step.text),
          subtitle: Text(
            'Deadline: ${formatDate(step.deadline, [yy, '-', mm, '-', dd])}',
          ),
          tileColor: step.isMendatary ? Colors.grey[300] : Colors.grey[100],
          trailing: Checkbox(
            value: step.done,
            onChanged: (value) {
              final updatedSteps =
                  steps.map((s) {
                    if (s.id == step.id) {
                      return s.copyWith(done: value!);
                    }
                    return s;
                  }).toList();
              ref
                  .read(processListProvider.notifier)
                  .updateProcessSteps(processId.toString(), updatedSteps);
            },
          ),
        );
      },
    );
  }
}

class ProcessCreateView extends HookConsumerWidget {
  const ProcessCreateView({super.key, this.processId});

  final String? processId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var baseProcess =
        processId == null
            ? Process(
              id: Uuid().v1(),
              name: '',
              description: '',
              isMendatary: false,
              difficultLevel: 1,
              group: '',
              assignedAt: DateTime.now(),
              steps: [],
            )
            : ref
                .watch(processListProvider)
                .firstWhere((process) => process.id == processId);

    final process = useState(baseProcess);

    final textEditingController = useTextEditingController(
      text: processToText(process.value),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Create Process')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Autocomplete(
              optionsBuilder: (textEditingValue) {
                return ref
                    .watch(processGroupsListProvider)
                    .where(
                      (group) => group.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      ),
                    )
                    .toList();
              },
              onSelected: (value) {
                process.value = process.value.copyWith(group: value);
              },
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                textEditingController.text = process.value.group;

                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Group'),
                  onChanged: (value) {
                    process.value = process.value.copyWith(group: value);
                  },
                );
              },
            ),
            // DropdownMenu(
            //   label: const Text('Group'),
            //   onSelected: (value) {
            //     process.value = process.value.copyWith(group: value!);
            //   },
            //   dropdownMenuEntries:
            //       ref
            //           .watch(processGroupsListProvider)
            //           .map(
            //             (group) => DropdownMenuEntry<String>(
            //               value: group,
            //               label: group,
            //             ),
            //           )
            //           .toList(),
            // ),
            TextField(
              decoration: const InputDecoration(labelText: 'Process info'),
              autofocus: true,
              controller: textEditingController,
              onChanged: (value) {
                var lines = value.split("\n");
                var difficultLevel = int.tryParse(
                  lines[0][lines[0].length - 1],
                );
                if (difficultLevel != null) {
                  lines[0] = lines[0].substring(0, lines[0].length - 1);
                }
                process.value = processFromText(
                  value,
                  process.value.group,
                  process.value.isMendatary,
                  process.value.id,
                );
                // process.value = process.value.copyWith(
                //   name: lines[0],
                //   difficultLevel: difficultLevel ?? 3,
                //   description:
                //       lines.length > 1 ? lines.sublist(1).join("\n") : "",
                // );
              },
              minLines: 2,
              maxLines: 15,
            ),
            // TextField(
            //   decoration: const InputDecoration(labelText: "Steps"),
            //   onChanged: (value) {
            //     var lines =
            //         value
            //             .split("\n")
            //             .map(
            //               (line) => Step(
            //                 id: Uuid().v1(),
            //                 text:
            //                     line.startsWith("+") || line.startsWith("-")
            //                         ? line.substring(1).trim()
            //                         : line.trim(),
            //                 done: false,
            //                 deadline: DateTime.now(),
            //                 isMendatary: line.startsWith("+") ? true : false,
            //               ),
            //             )
            //             .toList();
            //     process.value = process.value.copyWith(steps: lines);
            //   },
            //   minLines: 3,
            //   maxLines: 10,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    process.value = process.value.copyWith(isMendatary: false);
                    ref
                        .read(processListProvider.notifier)
                        .appendOrReplaceProcess(process.value);
                    context.pop();
                  },
                  child: const Text('To not mendatary'),
                ),
                const Gap(8.0),
                ElevatedButton(
                  onPressed: () {
                    process.value = process.value.copyWith(isMendatary: true);
                    ref
                        .read(processListProvider.notifier)
                        .appendOrReplaceProcess(process.value);
                    context.pop();
                  },
                  child: const Text('To mendatary'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

@freezed
@JsonSerializable()
class Process with _$Process {
  Process({
    required this.id,
    required this.name,
    required this.description,
    required this.isMendatary,
    required this.difficultLevel,
    required this.group,
    required this.assignedAt,
    required this.steps,
  });
  final String id;
  final String name;
  final String description;
  final bool isMendatary;
  final int difficultLevel;
  final String group;
  final DateTime assignedAt;
  final List<Step> steps;

  factory Process.fromJson(Map<String, dynamic> json) =>
      _$ProcessFromJson(json);
  Map<String, dynamic> toJson() => _$ProcessToJson(this);
}

String processToText(Process process) {
  var text = "${process.name} ${process.difficultLevel}\n";
  if (process.description.isNotEmpty) {
    text += "${process.description}\n";
  }
  for (var step in process.steps) {
    text += "${step.isMendatary ? "+" : "-"} ${step.text}\n";
  }
  return text;
}

Process processFromText(
  String text, [
  String? group,
  bool? isMendatary,
  String? id,
]) {
  var lines = text.split("\n");
  lines = lines.map((line) => line.trim()).toList();
  var name = lines[0];
  var difficultLevel = int.tryParse(name[name.length - 1]);
  if (difficultLevel != null) {
    name = name.substring(0, name.length - 1).trim();
  }

  var description = "";
  var steps = <Step>[];
  if (lines.length > 1) {
    description = lines
        .sublist(1)
        .where((line) => !(line.startsWith("-") || line.startsWith("+")))
        .join("\n");
    steps =
        lines.where((line) => line.startsWith("-") || line.startsWith("+")).map(
          (line) {
            final exp = RegExp(r"\+(\d+)d");
            var deadline = DateTime.now();
            if (exp.hasMatch(line)) {
              final days = int.tryParse(exp.firstMatch(line)!.group(1)!);
              deadline = DateTime.now().add(Duration(days: days ?? 0));
              line = line.replaceAll(exp, "");
            }
            return Step(
              id: Uuid().v1(),
              text: line.substring(1).trim(),
              done: false,
              deadline: deadline,
              isMendatary: line.startsWith("+") ? true : false,
            );
          },
        ).toList();
  }

  return Process(
    id: id ?? Uuid().v1(),
    name: name,
    description: description,
    isMendatary: isMendatary ?? false,
    difficultLevel: difficultLevel ?? 3,
    group: group ?? "",
    assignedAt: DateTime.now(),
    steps: steps,
  );
}

@freezed
@JsonSerializable()
class Step with _$Step {
  Step({
    required this.id,
    required this.text,
    required this.done,
    required this.deadline,
    required this.isMendatary,
  });
  final String id;
  final String text;
  final bool done;
  final DateTime deadline;
  final bool isMendatary;

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);
  Map<String, dynamic> toJson() => _$StepToJson(this);
}
