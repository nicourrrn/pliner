import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
import "./controllers.dart";
import "./theme.dart";

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
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
            ),
            gradient: LinearGradient(
              colors: [
                step.isMendatary ? Colors.purple[100]! : Colors.grey[50]!,
                Theme.of(context).canvasColor,
                Theme.of(context).canvasColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),

          child: ListTile(
            title: Text(
              step.text,
              style: TextStyle(
                decoration: step.done ? TextDecoration.lineThrough : null,
              ),
            ),
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
    final color = useState(
      process.isMendatary ? Colors.grey[400] : Colors.grey[150],
    );

    if (selectedProcesses.contains(processId)) {
      color.value = Colors.red[400];
    } else if (process.isMendatary) {
      color.value = Colors.purple[100];
    } else {
      color.value = Colors.grey[150];
    }

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
        subtitle: Text(process.group),
        trailing: Text(process.timeNeeded.inHours.toString()),
        onTap: () {
          isDesktop(context)
              ? ref.read(choosedProcessProvider.notifier).state = process.id
              : context.push("/process/${process.id}");
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
