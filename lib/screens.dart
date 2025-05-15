import "package:flutter/services.dart";
import "package:gap/gap.dart";
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
import 'package:date_format/date_format.dart';
import "package:self_process_manager/sources.dart";

import "./models.dart";
import "./theme.dart";
import "./controllers.dart";
import "./widgets.dart";
import "./collectors.dart";

// Desktop

// Mobile

// Semi
class SplitedScreen extends HookConsumerWidget {
  const SplitedScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choosedProcess = ref.watch(choosedProcessProvider);
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 2, child: const ProcessListScreen()),
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

class ProcessListScreen extends HookConsumerWidget {
  const ProcessListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchFocusNode = useFocusNode();
    final searchActive = useState(false);

    useEffect(() {
      listener() {
        searchActive.value =
            searchFocusNode.hasFocus ? true : searchActive.value;
      }

      FocusManager.instance.addListener(listener);
      return () => FocusManager.instance.removeListener(listener);
    }, [searchFocusNode]);

    return Scaffold(
      appBar: AppBar(
        leading:
            searchActive.value
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (searchActive.value) {
                      searchActive.value = false;
                      searchFocusNode.unfocus();
                    }
                  },
                )
                : null,
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
          ),
          focusNode: searchFocusNode,
          onChanged: (value) {
            ref.read(processNameFilterProvider.notifier).state = value;
          },
        ),
        actions: [
          if (ref.watch(selectedProcessesProvider).isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref
                    .read(selectedProcessesProvider)
                    .forEach(
                      (p) => ref
                          .read(eventControllerProvider.notifier)
                          .add(Event.deleteProcess(p)),
                    );
                ref.read(selectedProcessesProvider.notifier).clear();
              },
            ),

          if (ref.watch(userControllerProvider).isLoggedIn) ...[
            IconButton(
              tooltip: "Sync",
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                try {
                  final dio = ref.read(dioProvider);
                  final serverStatus = await pingServer(dio);
                  CommunicationService.showSnackbarAfterLastFrame(
                    ref,
                    serverStatus ? "Sync completed" : "Server is down",
                  );

                  if (!serverStatus) return;

                  await for (final event in syncWithServer(
                    dio,
                    await ref.read(databaseProvider.future),
                    ref.read(userControllerProvider).username,
                    ref.read(processListProvider),
                  )) {
                    ref.read(eventControllerProvider.notifier).add(event);
                  }
                } catch (e) {
                  CommunicationService.showDialogAfterLastFrame(
                    e.toString(),
                    "Sync failed",
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push("/user"),
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () => context.push("/user/login"),
            ),
        ],
      ),

      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop()) const GroupList(),

            Expanded(
              flex: 6,
              child: Column(
                children: [
                  if (searchActive.value)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sort by"),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              FilterChip(
                                label: const Text("Name"),
                                onSelected: (value) {
                                  ref.read(sortByProvider.notifier).state =
                                      SortBy.name;
                                },
                              ),
                              FilterChip(
                                label: const Text("Deadline"),
                                onSelected: (value) {
                                  ref.read(sortByProvider.notifier).state =
                                      SortBy.deadline;
                                },
                              ),
                              FilterChip(
                                label: const Text("Last Edit"),
                                onSelected: (value) {
                                  ref.read(sortByProvider.notifier).state =
                                      SortBy.editAt;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Expanded(child: ListWithAnimatedHeader()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListWithAnimatedHeader extends HookConsumerWidget {
  const ListWithAnimatedHeader({super.key});
  static const maxHeaderHeight = 100.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final overscrollExtent = useState(0.0);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        return false;
      },

      child: Stack(
        children: [
          ListView.builder(
            controller: scrollController,
            itemCount: ref.watch(sortedProcessProvider).length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return true // isDesktop()
                    ? Align(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: () => context.push("/process/create"),
                        icon: const Icon(Icons.add),
                        label: const Text("New process"),
                      ),
                    )
                    : const SizedBox.shrink();
              }
              final process = ref.watch(sortedProcessProvider)[index - 1];
              return ProcessListTile(processId: process.id);
            },
          ),

          if (overscrollExtent.value > 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: maxHeaderHeight - overscrollExtent.value,
                color: Theme.of(context).colorScheme.primary,
                child: const Center(
                  child: Text("✍️ New", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
        ],
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
          if (isDesktop())
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push("/process/${process.id}/edit"),
            ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed:
                () async => await Clipboard.setData(
                  ClipboardData(
                    text:
                        "${processToText(process)}\nDeadline: ${formatDate(process.deadline, [yyyy, '-', mm, '-', dd])}",
                  ),
                ),
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
                  "${process.description}\nDeadline: ${formatDate(process.deadline, [yyyy, '-', mm, '-', dd])}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const Gap(16),
              Expanded(child: StepListView(processId: processId)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(process.groupName),
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
    final process = useState(baseProcess);

    final textEditingController = useTextEditingController(
      text: processToText(process.value),
    );
    final lastLinesCount = useState(0);
    useEffect(() {
      textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: baseProcess.name.indexOf("]")),
      );
      lastLinesCount.value = textEditingController.text.split("\n").length;
      return null;
    }, []);

    useEffect(() {
      listener() {
        final lines = textEditingController.text.split("\n");
        final text = textEditingController.text;
        final isNewLine = text.endsWith("\n");
        final previousTextIsStep = lines[lines.length - 2].trim().startsWith(
          "-",
        );
        if (lines.length == lastLinesCount.value + 1 &&
            isNewLine &&
            previousTextIsStep) {
          final newText = "$text- ";
          textEditingController.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }

        lastLinesCount.value = lines.length;
      }

      textEditingController.addListener(listener);

      return () => textEditingController.removeListener(listener);
    }, [textEditingController]);
    final username = ref.read(userControllerProvider).username;

    createProcess(bool isMandatory) {
      process.value = process.value.copyWith(
        isMandatory: isMandatory,
        editAt: DateTime.now(),
      );
      final event =
          (processId != null)
              ? Event.updateProcess(process.value)
              : Event.createProcess(process.value, username);
      ref.read(eventControllerProvider.notifier).add(event);

      context.pop();
    }

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
                process.value = process.value.copyWith(groupName: value);
              },
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(labelText: 'Group'),
                  onChanged: (value) {
                    process.value = process.value.copyWith(groupName: value);
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
                  process.value.groupName,
                  process.value.isMandatory,
                  process.value.id,
                  process.value.steps,
                );
              },
              minLines: 2,
              maxLines: 15,
            ),
            const Gap(16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => createProcess(false),
                  child: const Text('To not mendatory'),
                ),
                const Gap(8.0),
                ElevatedButton(
                  onPressed: () => createProcess(true),
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    userInfo.value = userInfo.value.copyWith(
                      token: "token",
                      isLoggedIn: true,
                    );
                    ref
                        .read(userControllerProvider.notifier)
                        .update(userInfo.value);
                    context.pop();
                  },
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final dio = ref.read(dioProvider);
                    signupFromServer(
                      dio,
                      userInfo.value.username,
                      userInfo.value.password,
                    );

                    userInfo.value = userInfo.value.copyWith(
                      token: "token",
                      isLoggedIn: true,
                    );
                    ref
                        .read(userControllerProvider.notifier)
                        .update(userInfo.value);
                    context.pop();
                  },
                  child: const Text("Sign up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingScreen extends HookConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseUrlNotify = ref.read(baseUrlProvider.notifier);
    final textEditingController = useTextEditingController(
      text: ref.read(baseUrlProvider),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        actions: [
          IconButton(
            onPressed: () => ref.read(userControllerProvider.notifier).clear(),
            icon: const Icon(Icons.logout),
          ),
          UpdateAppButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ref.watch(userControllerProvider).username,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(16.0),
            TextField(
              controller: textEditingController,
              decoration: const InputDecoration(labelText: 'Base URL'),
              onChanged: (value) {
                baseUrlNotify.state = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
