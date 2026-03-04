import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:volcan_pay/features/auth/presentation/pages/login_page.dart';
import 'package:volcan_pay/features/auth/presentation/providers/auth_provider.dart';

part 'router_provider.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authControllerProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    redirect: (context, state) {
      final user = authState.value;
      final bool loggedIn = user != null;
      final bool isLoading = authState.isLoading;
      final bool isLoggingIn = state.matchedLocation == '/login';

      if (isLoading) return null;

      if (!loggedIn) {
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}
