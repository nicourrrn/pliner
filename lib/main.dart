import 'dart:io';

import "package:gap/gap.dart";
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
import 'package:date_format/date_format.dart';
import "dart:convert";
import "package:path_provider/path_provider.dart";
import "./models.dart";
import "./convetrers.dart";
import "./controllers.dart";

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
        trailing: Text(process.timeNeeded.inHours.toString()),
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
          Text(process.timeNeeded.inHours.toString()),
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
            const Gap(18),
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
            ? Process.zero()
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
              },
              minLines: 2,
              maxLines: 15,
            ),
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
