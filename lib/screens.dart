import "package:flutter/services.dart";
import "package:gap/gap.dart";
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
import 'package:date_format/date_format.dart';
import "package:self_process_manager/sources.dart";
import "package:self_process_manager/theme.dart";

import "./models.dart";
import "./controllers.dart";
import "./widgets.dart";

// SplitedScreen
class ProcessSelectSplitedScreen extends HookConsumerWidget {
  const ProcessSelectSplitedScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choosedProcess = ref.watch(choosedProcessProvider);

    return Scaffold(
      body: Row(
        children: [
          const GroupList(),
          Expanded(flex: 2, child: ProcessListScreen()),
          Expanded(
            flex: 3,
            child:
                choosedProcess.isEmpty
                    ? const Center(child: Text("Select process"))
                    : ProcessDetailViewScreen(processId: choosedProcess),
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
    final showDetailSearching = useState(false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SearchAppBar(showDetailSearching: showDetailSearching),
      ),
      body: ProcessListWithDetailsWidget(
        showDetailSearching: showDetailSearching,
      ),
    );
  }
}

class ProcessDetailViewScreen extends HookConsumerWidget {
  const ProcessDetailViewScreen({super.key, required this.processId});
  final String processId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final process = ref
        .watch(processListProvider)
        .firstWhere((p) => p.id == processId);

    final daysLeft = process.deadline.difference(DateTime.now()).inDays;
    final titleText = daysLeft > 0 ? "$daysLeft d left" : "Expired";

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
                  ClipboardData(text: processToText(process)),
                ),
          ),
        ],
      ),
      body: ProcessDetailView(processId: processId),
    );
  }
}

// Simple Screen

class ProcessListWithDetailsWidget extends HookConsumerWidget {
  const ProcessListWithDetailsWidget({
    required this.showDetailSearching,
    super.key,
  });

  final ValueNotifier<bool> showDetailSearching;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          if (showDetailSearching.value) SearchOptionWidget(),
          Expanded(child: ListWithAnimatedHeader()),
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

    final heightIndicator = useState(0.0);

    return GestureDetector(
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
    final lastLinesCount = useState(0);
    final username = ref.read(userControllerProvider).username;
    final textEditingController = useTextEditingController(
      text: processToText(process.value),
    );

    useEffect(() {
      textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: baseProcess.name.indexOf("]")),
      );
      lastLinesCount.value = textEditingController.text.split("\n").length;
      return null;
    }, []);

    useEffect(() {
      listener() {
        final text = textEditingController.text;
        final lines = text.split("\n");
        final previousTextIsStep = lines[lines.length - 2].startsWith("-");
        if (lines.length == lastLinesCount.value + 1 &&
            text.endsWith("\n") &&
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

    createProcess() {
      process.value = process.value.copyWith(
        isMandatory: true,
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
            GroupAutocomplete(
              setValue:
                  (v) => process.value = process.value.copyWith(groupName: v),
              likeFunction: simpleLikeFunction,
              initialValue: process.value.groupName,
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
            ElevatedButton(
              onPressed: createProcess,
              child: const Text('To mandatory'),
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

class ChatScreen extends HookConsumerWidget {
  const ChatScreen({
    required this.children,
    required this.onSendMessage,
    super.key,
  });

  final List<Widget> children;
  final Function(String) onSendMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = useTextEditingController();
    final chatMessages = useState<List<String>>([]);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          ListView.builder(
            itemCount: chatMessages.value.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(chatMessages.value[index]));
            },
          ),
          TextField(
            controller: chatController,
            decoration: const InputDecoration(labelText: 'Message'),
            onSubmitted: (value) {
              chatMessages.value = [...chatMessages.value, value];
              onSendMessage(value);
              chatController.clear();
            },
          ),
        ],
      ),
    );
  }
}
