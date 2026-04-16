import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/route_names.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/characters/presentation/character_dashboard_page.dart';
import '../features/characters/presentation/character_form_page.dart';
import '../features/characters/presentation/characters_page.dart';
import '../features/goals/presentation/goal_detail_page.dart';
import '../features/goals/presentation/goal_form_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthChangeNotifier(
    FirebaseAuth.instance.authStateChanges(),
  );
  ref.onDispose(notifier.dispose);

  return GoRouter(
    initialLocation: RouteNames.login,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      final isOnLogin = state.matchedLocation == RouteNames.login;

      if (!isLoggedIn && !isOnLogin) return RouteNames.login;
      if (isLoggedIn && isOnLogin) return RouteNames.characters;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.characters,
        name: RouteNames.characters,
        builder: (context, state) => const CharactersPage(),
      ),
      GoRoute(
        path: RouteNames.characterNew,
        builder: (context, state) => const CharacterFormPage(),
      ),
      GoRoute(
        path: '/characters/:id/edit',
        builder: (context, state) => CharacterFormPage(
          characterId: state.pathParameters['id'],
        ),
      ),
      GoRoute(
        path: '/characters/:id/goals/new',
        builder: (context, state) => GoalFormPage(
          characterId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/characters/:id/goals/:goalId',
        builder: (context, state) => GoalDetailPage(
          characterId: state.pathParameters['id']!,
          goalId: state.pathParameters['goalId']!,
        ),
      ),
      GoRoute(
        path: '/characters/:id',
        builder: (context, state) => CharacterDashboardPage(
          characterId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});

/// Puente entre el stream de auth de Firebase y el refreshListenable de go_router.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Stream<User?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
