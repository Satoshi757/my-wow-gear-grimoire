import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/catalogs/factions.dart';
import '../../../core/catalogs/goal_statuses.dart';
import '../../../core/constants/route_names.dart';
import '../../../features/goals/domain/models/goal.dart';
import '../../../features/goals/presentation/providers/goals_providers.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/filter_bar.dart';
import '../../../shared/widgets/goal_card.dart';
import 'providers/characters_providers.dart';

class CharacterDashboardPage extends ConsumerStatefulWidget {
  const CharacterDashboardPage({super.key, required this.characterId});

  final String characterId;

  @override
  ConsumerState<CharacterDashboardPage> createState() =>
      _CharacterDashboardPageState();
}

class _CharacterDashboardPageState
    extends ConsumerState<CharacterDashboardPage> {
  String? _filterType;
  String? _filterPriority;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final characterAsync = ref.watch(characterDetailProvider(widget.characterId));
    final goalsAsync = ref.watch(
      goalsStreamProvider(ownerUid: uid, characterId: widget.characterId),
    );

    return Scaffold(
      appBar: AppBar(
        title: characterAsync.when(
          loading: () => const Text('Personaje'),
          error: (_, _) => const Text('Personaje'),
          data: (c) => Text(c?.name ?? 'Personaje'),
        ),
        actions: [
          characterAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (c) => c == null
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Editar personaje',
                    onPressed: () =>
                        context.push(RouteNames.characterEdit(widget.characterId)),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Cabecera del personaje ─────────────────────────────────────
          characterAsync.when(
            loading: () => const SizedBox(
              height: 72,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => const SizedBox.shrink(),
            data: (character) {
              if (character == null) return const SizedBox.shrink();
              return _CharacterHeader(
                classKey: character.classKey,
                mainSpec: character.mainSpec,
                factionKey: character.factionKey,
                level: character.level,
              );
            },
          ),

          // ── Contadores por status ──────────────────────────────────────
          goalsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (goals) => _StatusCounters(goals: goals),
          ),

          // ── FilterBar ─────────────────────────────────────────────────
          FilterBar(
            selectedType: _filterType,
            selectedPriority: _filterPriority,
            onTypeChanged: (v) => setState(() => _filterType = v),
            onPriorityChanged: (v) => setState(() => _filterPriority = v),
          ),

          // ── Lista de objetivos ─────────────────────────────────────────
          Expanded(
            child: goalsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      const Text('Error al cargar objetivos'),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => ref.invalidate(
                          goalsStreamProvider(
                            ownerUid: uid,
                            characterId: widget.characterId,
                          ),
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (goals) {
                final filtered = _applyFilters(goals);

                if (goals.isEmpty) {
                  return EmptyState(
                    icon: Icons.add_task,
                    title: 'Sin objetivos',
                    message: 'Agrega el primer objetivo para este personaje.',
                    actionLabel: 'Agregar objetivo',
                    onAction: () => context.push(
                      RouteNames.goalNew(widget.characterId),
                    ),
                  );
                }

                if (filtered.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No hay objetivos con estos filtros.'),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final goal = filtered[i];
                    return GoalCard(
                      goal: goal,
                      onTap: () => context.push(
                        RouteNames.goalDetail(widget.characterId, goal.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.push(RouteNames.goalNew(widget.characterId)),
        icon: const Icon(Icons.add),
        label: const Text('Agregar objetivo'),
      ),
    );
  }

  List<Goal> _applyFilters(List<Goal> goals) {
    return goals.where((g) {
      if (_filterType != null && g.type != _filterType) return false;
      if (_filterPriority != null && g.priority != _filterPriority) return false;
      return true;
    }).toList();
  }
}

class _CharacterHeader extends StatelessWidget {
  const _CharacterHeader({
    required this.classKey,
    required this.mainSpec,
    required this.factionKey,
    this.level,
  });

  final String classKey;
  final String mainSpec;
  final String factionKey;
  final int? level;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              [
                _capitalize(classKey),
                mainSpec,
                if (level != null) 'Nv. $level',
              ].join(' · '),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Text(
            factionLabels[factionKey] ?? factionKey,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: factionKey == 'alliance'
                      ? Colors.blue.shade700
                      : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _StatusCounters extends StatelessWidget {
  const _StatusCounters({required this.goals});

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{
      for (final s in goalStatuses)
        s: goals.where((g) => g.status == s).length,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: goalStatuses.map((s) {
          return Expanded(
            child: _CounterTile(
              label: goalStatusLabels[s]!,
              count: counts[s] ?? 0,
              status: s,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CounterTile extends StatelessWidget {
  const _CounterTile({
    required this.label,
    required this.count,
    required this.status,
  });

  final String label;
  final int count;
  final String status;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (bg, fg) = switch (status) {
      'pending' => (cs.surfaceContainerHighest, cs.onSurfaceVariant),
      'in_progress' => (cs.primaryContainer, cs.onPrimaryContainer),
      'obtained' => (cs.secondaryContainer, cs.onSecondaryContainer),
      _ => (cs.surface, cs.onSurface),
    };

    return Card(
      color: bg,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              '$count',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: fg, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: fg),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
