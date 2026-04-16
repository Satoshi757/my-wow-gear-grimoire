import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/goals_repository.dart';
import '../../domain/models/goal.dart';

part 'goals_providers.g.dart';

@riverpod
GoalsRepository goalsRepository(GoalsRepositoryRef ref) {
  return GoalsRepository();
}

/// Stream de objetivos activos para un personaje concreto.
@riverpod
Stream<List<Goal>> goalsStream(
  GoalsStreamRef ref, {
  required String ownerUid,
  required String characterId,
}) {
  return ref.watch(goalsRepositoryProvider).watchByCharacter(
        ownerUid: ownerUid,
        characterId: characterId,
      );
}

/// Carga puntual de un objetivo por ID. Devuelve null si no existe.
@riverpod
Future<Goal?> goalDetail(GoalDetailRef ref, String goalId) {
  return ref.watch(goalsRepositoryProvider).fetchById(goalId);
}
