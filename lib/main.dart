import 'package:flutter/material.dart';
import "package:flutter_hooks/flutter_hooks.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
import "package:self_process_manager/watchers.dart";
import "./theme.dart";
import "./screens.dart";
import "./collectors.dart";
import "./controllers.dart";
import "./models.dart";

main() async {
  runApp(const ProviderScope(child: MyApp()));
}

final _routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: "/",

    routes: [
      GoRoute(
        path: '/',
        builder:
            (context, state) =>
                isDesktop(context) ? MyDesktopHomePage() : const MyHomePage(),
      ),
      GoRoute(
        path: "/process/create",
        builder: (context, state) => const ProcessCreateView(),
      ),
      GoRoute(
        path: "/process/:processId",
        builder: (context, state) {
          final processId = state.pathParameters['processId']!;
          return isDesktop(context)
              ? const MyDesktopHomePage()
              : ProcessDetailView(processId: processId);
        },
      ),
      GoRoute(
        path: "/process/:processId/edit",
        builder: (context, state) {
          final processId = state.pathParameters['processId']!;
          return ProcessCreateView(processId: processId);
        },
      ),
      GoRoute(
        path: "/user/login",
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: "/user",
        builder: (context, state) => const SettingScreen(),
      ),
    ],
  ),
);

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final processAsync = ref.watch(databaseProcessListProvider);
    final databaseSynchronizer = ref.watch(syncEventsWithDatabaseProvider);

    useEffect(() {
      final sub = ref.listenManual<AsyncValue<List<Process>>>(
        databaseProcessListProvider,
        (previous, next) {
          next.whenData(
            (processes) =>
                ref.read(processListProvider.notifier).setProcesses(processes),
          );
        },
      );
      return sub.close;
    }, []);

    return MaterialApp.router(
      title: 'Task manager',
      theme: isDesktop(context) ? desctopTheme : mobileTheme,
      routerConfig: ref.watch(_routerProvider),
    );
  }
}
