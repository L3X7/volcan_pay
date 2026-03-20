import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:volcan_pay/core/constants/app_routes.dart';
import 'package:volcan_pay/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:volcan_pay/features/auth/presentation/pages/register_page.dart';
import 'package:volcan_pay/features/auth/presentation/pages/splash_page.dart';
import 'package:volcan_pay/features/home/presentation/pages/home_page.dart';
import 'package:volcan_pay/features/auth/presentation/pages/login_page.dart';
import 'package:volcan_pay/features/auth/presentation/providers/auth_provider.dart';

part 'router_provider.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  // Use a value notifier to trigger redirect without rebuilding the GoRouter object
  final notifier = ValueNotifier<int>(0);

  //Listen to the auth state.
  ref.listen(authControllerProvider, (prev, next) {
    notifier.value++;
  });

  // Clean up when the provider is disposed
  ref.onDispose(() => notifier.dispose());

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final user = authState.value;

      final bool isLoading = authState.isLoading;
      final bool hasError = authState.hasError;

      // Match locations
      final isSplashPage = state.matchedLocation == AppRoutes.splash;
      final bool isLoginPage = state.matchedLocation == AppRoutes.login;
      final bool isRegisterPage = state.matchedLocation == AppRoutes.register;
      final bool isOTPVerificationPage =
          state.matchedLocation == AppRoutes.otpVerification;

      if (isLoading) return null;

      // GUARD: If an error occurs don't redirect.
      if (hasError) return null;

      final bool isLoggedIn = user != null;
      final bool isVerified = user?.emailConfirmedAt != null;

      // --- AUTHENTICATION LOGIC ---

      // Case: Not logged in
      if (!isLoggedIn) {
        return (isLoginPage || isRegisterPage) ? null : AppRoutes.login;
      }

      // Case: Logged in but needs OTP (8 digits)
      if (isLoggedIn && !isVerified) {
        return (isOTPVerificationPage) ? null : AppRoutes.otpVerification;
      }
      // Case: Fully verified
      if (isLoggedIn && isVerified) {
        if (isLoginPage ||
            isRegisterPage ||
            isOTPVerificationPage ||
            isSplashPage) {
          return AppRoutes.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final email = ref.read(authControllerProvider).value?.email ?? '';
          return OtpVerificationPage(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
