import "./models.dart";
import "package:uuid/uuid.dart";

String processToText(Process process) {
  var text =
      "${process.name} +${process.deadline.difference(DateTime.now()).inDays}d +${process.timeNeeded.inHours}h${process.processType == ProcessType.focus ? "f" : "p"}\n";
  if (process.description.isNotEmpty) {
    text += "${process.description}\n";
  }
  text += process.steps
      .map((step) => "${step.isMandatory ? "-" : "+"} ${step.text}")
      .join("\n");
  return text;
}

Process processFromText(
  String text, [
  String? group,
  bool? isMandatory,
  String? id,
  List<Step> steps = const [],
]) {
  var lines = text.split("\n");
  lines = lines.map((line) => line.trim()).where((s) => s.isNotEmpty).toList();
  var name = lines[0];
  var description = "";

  final deadLineExp = RegExp(r"\+(\d+)d");

  var deadline = DateTime.now().add(
    Duration(days: int.parse(deadLineExp.firstMatch(name)?.group(1) ?? "7")),
  );

  if (deadLineExp.hasMatch(name)) {
    name = name.replaceAll(deadLineExp, "");
  }

  final timeNeededExp = RegExp(r"\+(\d+)h(p|f)");
  var processType = ProcessType.focus;
  var timeNeeded = const Duration(hours: 3);
  if (timeNeededExp.hasMatch(name)) {
    timeNeeded = Duration(
      hours: int.parse(timeNeededExp.firstMatch(name)?.group(1) ?? "3"),
    );
    processType =
        timeNeededExp.firstMatch(name)?.group(2) == "p"
            ? ProcessType.parallel
            : ProcessType.focus;
    name = name.replaceAll(timeNeededExp, "");
  }

  var newSteps = <Step>[];
  if (lines.length > 1) {
    description = lines
        .sublist(1)
        .where(
          (line) =>
              !(line.startsWith("-") || line.startsWith("+") || line.isEmpty),
        )
        .join("\n");
    newSteps =
        lines.where((line) => line.startsWith("-") || line.startsWith("+")).map(
          (line) {
            var step = steps.firstWhere(
              (s) => s.text == line.substring(1).trim(),
              orElse:
                  () => Step(
                    id: Uuid().v1(),
                    text: line.substring(1).trim(),
                    done: false,
                    isMandatory: line.startsWith("-") ? true : false,
                  ),
            );
            return step.copyWith(
              isMandatory: line.startsWith("-") ? true : false,
            );
          },
        ).toList();
  }

  return Process(
    id: id ?? Uuid().v1(),
    name: name.trim(),
    description: description.trim(),
    isMandatory: isMandatory ?? false,
    processType: processType,
    deadline: deadline,
    timeNeeded: timeNeeded,
    groupName: group ?? "",
    assignedAt: DateTime.now(),
    editAt: DateTime.now(),
    steps: newSteps,
  );
}
