import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
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
        style: TextStyle(
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
