import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/catalogs/goal_priorities.dart';
import '../../../core/catalogs/goal_statuses.dart';
import '../../../core/catalogs/goal_types.dart';
import '../domain/models/goal.dart';
import 'providers/goals_providers.dart';

class GoalDetailPage extends ConsumerWidget {
  const GoalDetailPage({
    super.key,
    required this.characterId,
    required this.goalId,
  });

  final String characterId;
  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(goalDetailProvider(goalId));

    return goalAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              const Text('Error al cargar el objetivo'),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => ref.invalidate(goalDetailProvider(goalId)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
      data: (goal) {
        if (goal == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Objetivo no encontrado')),
          );
        }
        return _GoalDetailForm(goal: goal);
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Formulario de edición (stateful, cargado una vez con los datos del objetivo)
// ─────────────────────────────────────────────────────────────────────────────

class _GoalDetailForm extends ConsumerStatefulWidget {
  const _GoalDetailForm({required this.goal});

  final Goal goal;

  @override
  ConsumerState<_GoalDetailForm> createState() => _GoalDetailFormState();
}

class _GoalDetailFormState extends ConsumerState<_GoalDetailForm> {
  final _formKey = GlobalKey<FormState>();

  late String _status;
  late String _priority;
  late TextEditingController _slotController;
  late TextEditingController _sourceTextController;
  late TextEditingController _noteController;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _status = widget.goal.status;
    _priority = widget.goal.priority;
    _slotController = TextEditingController(text: widget.goal.slot ?? '');
    _sourceTextController =
        TextEditingController(text: widget.goal.sourceText ?? '');
    _noteController = TextEditingController(text: widget.goal.note ?? '');
  }

  @override
  void dispose() {
    _slotController.dispose();
    _sourceTextController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;

    return Scaffold(
      appBar: AppBar(
        title: Text(goalTypeLabels[goal.type] ?? goal.type),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Nombre (solo lectura) ─────────────────────────────────────
            Text(
              goal.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),

            // ── Status ────────────────────────────────────────────────────
            DropdownButtonFormField<String>(
              key: ValueKey('status_$_status'),
              decoration: const InputDecoration(labelText: 'Estado *'),
              initialValue: _status,
              items: goalStatuses
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(goalStatusLabels[s]!),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _status = v ?? _status),
              validator: (v) => v == null ? 'Selecciona un estado' : null,
            ),
            const SizedBox(height: 16),

            // ── Prioridad ─────────────────────────────────────────────────
            DropdownButtonFormField<String>(
              key: ValueKey('priority_$_priority'),
              decoration: const InputDecoration(labelText: 'Prioridad *'),
              initialValue: _priority,
              items: goalPriorities
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(goalPriorityLabels[p]!),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _priority = v ?? _priority),
              validator: (v) => v == null ? 'Selecciona una prioridad' : null,
            ),
            const SizedBox(height: 16),

            // ── Slot ──────────────────────────────────────────────────────
            TextFormField(
              controller: _slotController,
              decoration: const InputDecoration(
                labelText: 'Slot',
                hintText: 'Ej. Pecho, Cabeza…',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // ── Fuente externa (solo lectura si existe payload) ───────────
            if (goal.externalPayloadSnapshot != null) ...[
              _ExternalSourceBlock(goal: goal),
              const SizedBox(height: 16),
            ],

            // ── Fuente (texto libre) ──────────────────────────────────────
            TextFormField(
              controller: _sourceTextController,
              decoration: const InputDecoration(
                labelText: 'Fuente',
                hintText: 'Ej. Karazhan - Príncipe Malchezaar',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // ── Nota ──────────────────────────────────────────────────────
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Nota',
                hintText: 'Contexto adicional…',
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // ── Guardar ───────────────────────────────────────────────────
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final updated = widget.goal.copyWith(
      status: _status,
      priority: _priority,
      slot: _slotController.text.trim().isEmpty
          ? null
          : _slotController.text.trim(),
      sourceText: _sourceTextController.text.trim().isEmpty
          ? null
          : _sourceTextController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    try {
      await ref.read(goalsRepositoryProvider).save(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Objetivo actualizado')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bloque de fuente externa (solo lectura)
// ─────────────────────────────────────────────────────────────────────────────

class _ExternalSourceBlock extends StatelessWidget {
  const _ExternalSourceBlock({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final payload = goal.externalPayloadSnapshot;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, size: 16, color: cs.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                'Fuente externa',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          if (payload != null && payload['name'] != null) ...[
            const SizedBox(height: 4),
            Text(
              payload['name'].toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          if (goal.externalSource != null) ...[
            const SizedBox(height: 2),
            Text(
              goal.externalSource!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
