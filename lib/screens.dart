import "package:gap/gap.dart";
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
import 'package:date_format/date_format.dart';
import "package:self_process_manager/sources.dart";
import "./models.dart";
import "./theme.dart";
import "./convetrers.dart";
import "./controllers.dart";
import "./widgets.dart";
import "./watchers.dart";
import "./events.dart";
import "./collectors.dart";

class MyDesktopHomePage extends HookConsumerWidget {
  const MyDesktopHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(syncEventsWithDatabaseProvider);
    final choosedProcess = ref.watch(choosedProcessProvider);
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 2, child: const MyHomePage()),
          VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child:
                choosedProcess.isEmpty
                    ? const Center(child: Text("Select process"))
                    : ProcessDetailView(processId: choosedProcess),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heightIndicator = useState(0.0);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(processNameFilterProvider.notifier).state = value;
          },
        ),
        actions: [
          if (ref.watch(selectedProcessesProvider).isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                final toDelete = ref.read(selectedProcessesProvider);
                for (final process in toDelete) {
                  ref
                      .read(eventControllerProvider.notifier)
                      .addEvent(Event.deleteProcess(process));
                }
                ref.read(selectedProcessesProvider.notifier).cleanState();
              },
            ),

          if (ref.watch(userControllerProvider).isLoggedIn) ...[
            IconButton(
              icon: Badge(
                label: Text(ref.watch(processesToUploadProvider).toString()),
                alignment: Alignment.bottomRight,
                child: const Icon(Icons.refresh),
              ),
              onPressed: () async {
                try {
                  final dio = ref.read(dioProvider);
                  final events = ref.read(eventControllerProvider);

                  for (final event in events) {
                    if (event.executedOn.contains(ExecutedOn.server)) {
                      continue;
                    }

                    switch (event) {
                      case CreateProcessEvent(:final process):
                        final owner = ref.read(userControllerProvider).username;
                        createProcessFromServer(dio, process, owner);
                        break;
                      case DeleteProcessEvent(:final processId):
                        deleteProcessFromServer(dio, processId);
                        break;
                      case UpdateProcessEvent(:final process):
                        updateProcessFromServer(dio, process);
                        break;
                      case UpdateProcessStepsEvent(
                        :final processId,
                        :final steps,
                      ):
                        updateProcessStepsFromServer(dio, processId, steps);
                        break;
                    }
                  }

                  final serverProcesses = await loadProcessFromServer(
                    ref.read(userControllerProvider).username,
                  );

                  final eventNotifier = ref.read(
                    eventControllerProvider.notifier,
                  );

                  for (final serverProcess in serverProcesses) {
                    final toDelete = events
                        .whereType<DeleteProcessEvent>()
                        .map((de) => de.processId)
                        .contains(serverProcess.id);
                    if (toDelete) continue;
                    try {
                      final localProcess = ref
                          .read(processListProvider)
                          .firstWhere((l) => serverProcess == l);
                      if (localProcess.editAt.isBefore(serverProcess.editAt)) {
                        eventNotifier.addEvent(
                          UpdateProcessEvent(serverProcess),
                        );
                      }
                    } catch (e) {
                      eventNotifier.addEvent(CreateProcessEvent(serverProcess));
                      debugPrint(
                        "Process ${serverProcess.id} not found in local storage",
                      );
                    }
                  }
                } catch (e) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("Error"),
                            content: Text(
                              "Failed to load processes with error $e",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context.pop(),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                    );
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed:
                  () => ref.read(userControllerProvider.notifier).cleanUser(),
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () => context.push("/user/login"),
            ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            if (isDesktop(context)) ...[
              const Gap(8.0),
              OutlinedButton(
                onPressed: () => context.push("/process/create"),
                child: const Text("New process"),
              ),
            ],
            const Gap(8.0),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is OverscrollNotification) {
                    heightIndicator.value -= notification.overscroll * 0.90;
                    if (heightIndicator.value < 0) {
                      heightIndicator.value = 0;
                    } else if (heightIndicator.value > 100) {
                      heightIndicator.value = 100;
                    }
                  }

                  if (notification is ScrollEndNotification) {
                    if (heightIndicator.value == 100) {
                      context.push("/process/create");
                    }
                    heightIndicator.value = 0;
                  }

                  return false;
                },

                child: ListView.builder(
                  itemCount: ref.watch(sortedProcessProvider).length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 70),

                        curve: Curves.easeInOut,
                        height: heightIndicator.value,
                        width: double.infinity,
                        alignment: Alignment.topCenter,
                        child: Text(
                          "✍️New",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                    final process = ref.watch(sortedProcessProvider)[index - 1];
                    return ProcessListTile(processId: process.id);
                  },
                ),
              ),
            ),
            GroupChips(),
          ],
        ),
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

    var titleText = "";
    if (process.timeNeeded.inHours > 0) {
      titleText =
          "${process.processType.name} for ${process.timeNeeded.inHours.toString()}h, ";
    }
    titleText += "${process.deadline.difference(DateTime.now()).inDays}d left";

    final heightIndicator = useState(0.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText, style: Theme.of(context).textTheme.titleSmall),
        actions: [
          if (isDesktop(context))
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push("/process/${process.id}/edit"),
            ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          heightIndicator.value += details.delta.dy * 0.90;
          if (heightIndicator.value > 100) {
            heightIndicator.value = 100;
          } else if (heightIndicator.value < 0) {
            heightIndicator.value = 0;
          }
        },
        onVerticalDragEnd: (_) {
          if (heightIndicator.value == 100) {
            context.push("/process/${process.id}/edit");
          }
          heightIndicator.value = 0;
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 70),
                curve: Curves.easeInOut,
                height: heightIndicator.value,
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: Text(
                  "✍️Edit",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: SelectableText(
                  process.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: SelectableText(
                  process.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Gap(16),
              Expanded(child: StepListView(processId: processId)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(process.group),
                  Text(
                    'Assigned At: ${formatDate(process.assignedAt, [yy, '-', mm, '-', dd])}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProcessCreateView extends HookConsumerWidget {
  const ProcessCreateView({super.key, this.processId});

  final String? processId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseProcess =
        processId == null
            ? Process.zero()
            : ref
                .watch(processListProvider)
                .firstWhere((process) => process.id == processId);
    debugPrint("Base process: $baseProcess");

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
                process.value = processFromText(
                  value,
                  process.value.group,
                  process.value.isMandatory,
                  process.value.id,
                  process.value.steps,
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
                    process.value = process.value.copyWith(
                      isMandatory: false,
                      editAt: DateTime.now(),
                    );
                    final event =
                        (processId != null)
                            ? Event.updateProcess(process.value)
                            : Event.createProcess(process.value);
                    ref.read(eventControllerProvider.notifier).addEvent(event);

                    context.pop();
                  },
                  child: const Text('To not mendatory'),
                ),
                const Gap(8.0),
                ElevatedButton(
                  onPressed: () {
                    process.value = process.value.copyWith(
                      isMandatory: true,
                      editAt: DateTime.now(),
                    );
                    final event =
                        (processId != null)
                            ? Event.updateProcess(process.value)
                            : Event.createProcess(process.value);
                    ref.read(eventControllerProvider.notifier).addEvent(event);

                    context.pop();
                  },
                  child: const Text('To mendatory'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = useState(User(username: '', password: ''));

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) {
                userInfo.value = userInfo.value.copyWith(username: value);
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onChanged: (value) {
                userInfo.value = userInfo.value.copyWith(password: value);
              },
            ),
            const Gap(16.0),
            ElevatedButton(
              onPressed: () {
                userInfo.value = userInfo.value.copyWith(
                  token: "token",
                  isLoggedIn: true,
                );
                ref
                    .read(userControllerProvider.notifier)
                    .updateUser(userInfo.value);
                context.pop();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
