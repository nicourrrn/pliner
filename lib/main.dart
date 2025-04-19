import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:go_router/go_router.dart";
import "./theme.dart";
import "./screens.dart";

void main() {
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
    ],
  ),
);

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Task manager',
      theme: isDesktop(context) ? desctopTheme : mobileTheme,
      routerConfig: ref.watch(_routerProvider),
    );
  }
}
