import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
import "package:self_process_manager/sources.dart";
import "package:url_launcher/url_launcher.dart";
import "./controllers.dart";
import "./theme.dart";
import "./collectors.dart";
import "./models.dart";

class RedDot extends StatelessWidget {
  const RedDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
    );
  }
}

class StepListView extends HookConsumerWidget {
  const StepListView({super.key, required this.processId});
  final String processId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventNotifier = ref.read(eventControllerProvider.notifier);

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
          title: SelectableText(
            step.text,
            style: TextStyle(
              decoration: step.done ? TextDecoration.lineThrough : null,
              color: step.isMandatory ? Colors.black : Colors.grey[600],
            ),
          ),
          trailing: Checkbox(
            value: step.done,
            onChanged: (value) {
              final updatedSteps =
                  steps.map((s) {
                    if (s.id == step.id) return s.copyWith(done: value!);
                    return s;
                  }).toList();

              eventNotifier.add(
                Event.updateProcessSteps(processId, updatedSteps),
              );
            },
          ),
        );
      },
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
    final color = useState(Colors.grey[100]);

    color.value =
        selectedProcesses.contains(processId) ? Colors.red[400] : null;

    final processDone = process.steps.every((step) => step.done);
    final icon =
        processDone
            ? const Icon(Icons.check_circle, color: Colors.green)
            : process.isMandatory
            ? const Icon(Icons.priority_high, color: Colors.red)
            : const Icon(Icons.priority_high, color: Colors.grey);

    return ListTile(
      title: Text(
        process.name,
        style: Theme.of(context).textTheme.titleSmall?.apply(
          decoration: processDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(process.groupName),
      leading: icon,
      trailing:
          process.deadline.isAfter(DateTime.now())
              ? Text(
                process.deadline.difference(DateTime.now()).inDays.toString(),
              )
              : const RedDot(),
      onTap: () {
        if (selectedProcesses.isNotEmpty) {
          ref
              .read(selectedProcessesProvider.notifier)
              .toggleProcess(process.id);
        } else {
          ref.read(choosedProcessProvider.notifier).state = process.id;
          if (isLowWidthSize(context)) context.push("/process/${process.id}");
        }
      },
      tileColor: color.value,
      onLongPress: () {
        ref.read(selectedProcessesProvider.notifier).toggleProcess(process.id);
      },
    );
  }
}

class GroupChips extends HookConsumerWidget {
  const GroupChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroups = ref.watch(selectedGroupsProvider);
    final selectedGroupsNotifier = ref.read(selectedGroupsProvider.notifier);
    final processGroups = ref.watch(processGroupsListProvider);

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children:
          processGroups
              .map(
                (group) => FilterChip(
                  label: Text(group),
                  selected: selectedGroups.contains(group),
                  onSelected:
                      (value) => selectedGroupsNotifier.toggleGroup(group),
                ),
              )
              .toList(),
    );
  }
}

class UpdateAppButton extends HookConsumerWidget {
  const UpdateAppButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseUrl = ref.watch(baseUrlProvider);

    return IconButton(
      onPressed: () async {
        final url = Uri.parse("${baseUrl}application/android/app");
        await launchUrl(url);
      },
      tooltip: "Update App",
      icon: const Icon(Icons.update),
    );
  }
}

// Use navigationrail
// class GroupList extends HookConsumerWidget {
//   const GroupList({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedGroup = ref.watch(selectedGroupProvider);
//     final processGroups = ref.watch(processGroupsListProvider);
//
//     return ListView.builder(
//       itemCount: processGroups.length,
//       itemBuilder: (context, index) {
//         final group = processGroups[index];
//         return TextButton(
//           style: ButtonStyle(
//             backgroundColor: WidgetStateProperty.all(
//               selectedGroup == group ? Colors.red[400] : null,
//             ),
//           ),
//           child: Column(
//             children: [
//               const Icon(Icons.group),
//               Text(group, style: Theme.of(context).textTheme.labelMedium),
//             ],
//           ),
//           onPressed: () {
//             ref.read(selectedGroupProvider.notifier).state =
//                 selectedGroup == group ? null : group;
//           },
//         );
//       },
//     );
//   }
// }

class GroupList extends HookConsumerWidget {
  const GroupList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroup = ref.watch(selectedGroupProvider);
    final processGroups = ["All"] + ref.watch(processGroupsListProvider);

    return NavigationRail(
      groupAlignment: -1.0,
      labelType: NavigationRailLabelType.all,
      destinations:
          processGroups
              .map(
                (group) => NavigationRailDestination(
                  icon: const Icon(Icons.group),
                  label: Text(
                    group,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              )
              .toList(),
      selectedIndex: processGroups.indexOf(selectedGroup ?? "All"),
      onDestinationSelected: (index) {
        ref.read(selectedGroupProvider.notifier).state =
            index == 0 ? null : processGroups[index];
      },
    );
  }
}

class SortByChip extends HookConsumerWidget {
  const SortByChip({required this.sortBy, super.key});

  final SortBy sortBy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilterChip(
      label: Text(sortBy.textRepresentation),
      onSelected: (value) {
        ref.read(sortByProvider.notifier).state = sortBy;
      },
    );
  }
}

class SearchOptionWidget extends HookConsumerWidget {
  const SearchOptionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
              SortByChip(sortBy: SortBy.deadline),
              SortByChip(sortBy: SortBy.editAt),
              SortByChip(sortBy: SortBy.name),
            ],
          ),
        ],
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
          Positioned.fill(
            child: ListView.builder(
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

class GroupAutocomplete extends HookConsumerWidget {
  const GroupAutocomplete({
    required this.setValue,
    required this.likeFunction,
    this.initialValue,
    super.key,
  });

  final Function(String) setValue;
  final bool Function(String, String) likeFunction;
  final String? initialValue;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Autocomplete(
      optionsBuilder: (textEditingValue) {
        return ref
            .watch(processGroupsListProvider)
            .where((v) => likeFunction(v, textEditingValue.text));
      },
      onSelected: setValue,
      initialValue: TextEditingValue(text: initialValue ?? ""),
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
          onChanged: setValue,
        );
      },
    );
  }
}

class SearchAppBar extends HookConsumerWidget {
  const SearchAppBar({required this.showDetailSearching, super.key});

  final ValueNotifier<bool> showDetailSearching;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchFocusNode = useFocusNode();
    useEffect(() {
      listener() {
        showDetailSearching.value =
            searchFocusNode.hasFocus ? true : showDetailSearching.value;
      }

      FocusManager.instance.addListener(listener);
      return () => FocusManager.instance.removeListener(listener);
    }, [searchFocusNode]);
    return AppBar(
      leading:
          showDetailSearching.value
              ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (showDetailSearching.value) {
                    showDetailSearching.value = false;
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
    );
  }
}
