import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
import "./controllers.dart";
import "./theme.dart";
import "./events.dart";
import "./collectors.dart";

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
          title: Text(
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

              eventNotifier.addEvent(
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
        selectedProcesses.contains(processId)
            ? Colors.red[400]
            : Colors.grey[100];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.value!,
            Theme.of(context).canvasColor,
            Theme.of(context).canvasColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListTile(
        title: Text(process.name),
        subtitle: Text(process.groupName),
        trailing: process.isMandatory ? Icon(Icons.upgrade) : null,
        onTap: () {
          ref.read(choosedProcessProvider.notifier).state = process.id;
          if (!isDesktop(context)) context.push("/process/${process.id}");
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

class GroupChips extends HookConsumerWidget {
  const GroupChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGroups = ref.watch(selectedGroupsProvider);
    final selectedGroupsNotifier = ref.read(selectedGroupsProvider.notifier);
    final processGroups = ref.watch(processGroupsListProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
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
      ),
    );
  }
}
