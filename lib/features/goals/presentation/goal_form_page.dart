import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/catalogs/goal_priorities.dart';
import '../../../core/catalogs/goal_statuses.dart';
import '../../../core/catalogs/goal_types.dart';
import '../domain/models/goal.dart';
import 'providers/goals_providers.dart';

class GoalFormPage extends ConsumerStatefulWidget {
  const GoalFormPage({super.key, required this.characterId});

  final String characterId;

  @override
  ConsumerState<GoalFormPage> createState() => _GoalFormPageState();
}

class _GoalFormPageState extends ConsumerState<GoalFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? _type;
  String _priority = 'medium';
  final _nameController = TextEditingController();
  final _slotController = TextEditingController();
  final _sourceTextController = TextEditingController();
  final _noteController = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _slotController.dispose();
    _sourceTextController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo objetivo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Tipo ──────────────────────────────────────────────────────
            DropdownButtonFormField<String>(
              key: ValueKey('type_$_type'),
              decoration: const InputDecoration(labelText: 'Tipo *'),
              initialValue: _type,
              items: goalTypes
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(goalTypeLabels[t]!),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _type = v),
              validator: (v) => v == null ? 'Selecciona un tipo' : null,
            ),
            const SizedBox(height: 16),

            // ── Nombre ────────────────────────────────────────────────────
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre *',
                hintText: 'Ej. Hauberk of the War Bringer',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
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
              onChanged: (v) => setState(() => _priority = v ?? 'medium'),
              validator: (v) => v == null ? 'Selecciona una prioridad' : null,
            ),
            const SizedBox(height: 16),

            // ── Slot (opcional) ───────────────────────────────────────────
            TextFormField(
              controller: _slotController,
              decoration: const InputDecoration(
                labelText: 'Slot',
                hintText: 'Ej. Pecho, Cabeza…',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // ── Fuente (opcional) ─────────────────────────────────────────
            TextFormField(
              controller: _sourceTextController,
              decoration: const InputDecoration(
                labelText: 'Fuente',
                hintText: 'Ej. Karazhan - Príncipe Malchezaar',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // ── Nota (opcional) ───────────────────────────────────────────
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
                  : const Text('Guardar objetivo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _saving = true);

    final now = DateTime.now();
    final goal = Goal(
      id: '',
      ownerUid: uid,
      characterId: widget.characterId,
      type: _type!,
      name: _nameController.text.trim(),
      status: goalStatuses.first, // 'pending'
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
      createdAt: now,
      updatedAt: now,
    );

    try {
      await ref.read(goalsRepositoryProvider).save(goal);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Objetivo guardado')),
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
