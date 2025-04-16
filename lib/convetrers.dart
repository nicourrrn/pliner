import "./models.dart";
import "package:uuid/uuid.dart";

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
