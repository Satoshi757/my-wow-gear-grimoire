import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/catalogs/professions.dart';
import '../../../core/catalogs/race_to_faction.dart';
import '../../../core/catalogs/wow_classes.dart';
import '../../../core/catalogs/wow_races.dart';
import '../../../core/constants/route_names.dart';
import '../../../core/utils/logger.dart';
import '../domain/models/character.dart';
import 'providers/characters_providers.dart';

class CharacterFormPage extends ConsumerStatefulWidget {
  const CharacterFormPage({super.key, this.characterId});

  /// null = modo crear / non-null = modo editar
  final String? characterId;

  @override
  ConsumerState<CharacterFormPage> createState() => _CharacterFormPageState();
}

class _CharacterFormPageState extends ConsumerState<CharacterFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.characterId != null;

  final _nameController = TextEditingController();
  final _mainSpecController = TextEditingController();
  final _secondarySpecController = TextEditingController();
  final _levelController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedClass;
  String? _selectedRace;
  String? _factionKey;
  String? _profession1;
  String? _profession2;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mainSpecController.dispose();
    _secondarySpecController.dispose();
    _levelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadCharacter() async {
    if (!_isEditing) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final character = await ref
          .read(charactersRepositoryProvider)
          .fetchById(widget.characterId!);

      if (!mounted) return;

      if (character != null) {
        _nameController.text = character.name;
        _mainSpecController.text = character.mainSpec;
        _secondarySpecController.text = character.secondarySpec ?? '';
        _levelController.text = character.level?.toString() ?? '';
        _notesController.text = character.notes ?? '';
        _selectedClass = character.classKey;
        _selectedRace = character.raceKey;
        _factionKey = character.factionKey;
        _profession1 = character.profession1;
        _profession2 = character.profession2;
        _createdAt = character.createdAt;
      }
    } catch (e, stack) {
      log(
        'Error al cargar personaje',
        error: e,
        stackTrace: stack,
        name: 'CharacterFormPage',
      );
      if (mounted) setState(() => _loadError = 'Error al cargar el personaje.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onRaceChanged(String? raceKey) {
    if (raceKey == null) return;
    setState(() {
      _selectedRace = raceKey;
      _factionKey = factionKeyFor(raceKey);
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final levelText = _levelController.text.trim();

      final character = Character(
        id: widget.characterId ?? '',
        ownerUid: uid,
        name: _nameController.text.trim(),
        classKey: _selectedClass!,
        raceKey: _selectedRace!,
        factionKey: _factionKey!,
        mainSpec: _mainSpecController.text.trim(),
        secondarySpec: _secondarySpecController.text.trim().isEmpty
            ? null
            : _secondarySpecController.text.trim(),
        level: levelText.isEmpty ? null : int.tryParse(levelText),
        profession1: _profession1,
        profession2: _profession2,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        isArchived: false,
        createdAt: _createdAt ?? now,
        updatedAt: now,
      );

      await ref.read(charactersRepositoryProvider).save(character);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Personaje actualizado' : 'Personaje creado'),
        ),
      );
      context.go(RouteNames.characters);
    } catch (e, stack) {
      log(
        'Error al guardar personaje',
        error: e,
        stackTrace: stack,
        name: 'CharacterFormPage',
      );
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar. Intenta de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(_isEditing ? 'Editar personaje' : 'Nuevo personaje')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: Text(_isEditing ? 'Editar personaje' : 'Nuevo personaje')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_loadError!),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _loadError = null;
                    _isLoading = true;
                  });
                  _loadCharacter();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar personaje' : 'Nuevo personaje'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Campos obligatorios ──────────────────────────────────────
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                // ValueKey fuerza recreación cuando el valor cambia (initialValue solo aplica en initState).
                key: ValueKey('class_$_selectedClass'),
                initialValue: _selectedClass,
                decoration: const InputDecoration(
                  labelText: 'Clase *',
                  border: OutlineInputBorder(),
                ),
                items: wowClasses
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(wowClassLabels[c] ?? c),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedClass = v),
                validator: (v) => v == null ? 'Selecciona una clase' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey('race_$_selectedRace'),
                initialValue: _selectedRace,
                decoration: const InputDecoration(
                  labelText: 'Raza *',
                  border: OutlineInputBorder(),
                ),
                items: wowRaces
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Text(wowRaceLabels[r] ?? r),
                      ),
                    )
                    .toList(),
                onChanged: _onRaceChanged,
                validator: (v) => v == null ? 'Selecciona una raza' : null,
              ),
              if (_factionKey != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Facción: ${_factionKey == 'alliance' ? 'Alliance' : 'Horde'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: _mainSpecController,
                decoration: const InputDecoration(
                  labelText: 'Especialización principal *',
                  hintText: 'ej. Discipline, Fire, Arms…',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'La especialización es obligatoria'
                    : null,
              ),

              // ── Campos opcionales ────────────────────────────────────────
              const SizedBox(height: 24),
              Text(
                'Datos opcionales',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _secondarySpecController,
                decoration: const InputDecoration(
                  labelText: 'Especialización secundaria',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _levelController,
                decoration: const InputDecoration(
                  labelText: 'Nivel',
                  hintText: '1 – 70',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final n = int.tryParse(v);
                  if (n == null || n < 1 || n > 70) return 'Nivel entre 1 y 70';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey('prof1_$_profession1'),
                initialValue: _profession1,
                decoration: const InputDecoration(
                  labelText: 'Profesión 1',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('— Ninguna —')),
                  ...professions.map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(professionLabels[p] ?? p),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _profession1 = v),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey('prof2_$_profession2'),
                initialValue: _profession2,
                decoration: const InputDecoration(
                  labelText: 'Profesión 2',
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('— Ninguna —')),
                  ...professions.map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(professionLabels[p] ?? p),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _profession2 = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              // ── Botón guardar ─────────────────────────────────────────────
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
