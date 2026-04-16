import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_names.dart';
import '../../../shared/widgets/character_card.dart';
import '../../../shared/widgets/empty_state.dart';
import 'providers/characters_providers.dart';

class CharactersPage extends ConsumerWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis personajes'),
      ),
      body: charactersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
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
                const Text('Error al cargar personajes'),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () => ref.invalidate(charactersStreamProvider),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
        data: (characters) {
          if (characters.isEmpty) {
            return EmptyState(
              icon: Icons.person_add_outlined,
              title: 'Sin personajes',
              message: 'Crea tu primer personaje para empezar a registrar objetivos.',
              actionLabel: 'Crear personaje',
              onAction: () => context.push(RouteNames.characterNew),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return CharacterCard(
                character: character,
                onTap: () => context.push(
                  RouteNames.characterDashboard(character.id),
                ),
                onEdit: () => context.push(
                  RouteNames.characterEdit(character.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.characterNew),
        tooltip: 'Nuevo personaje',
        child: const Icon(Icons.add),
      ),
    );
  }
}
