import 'package:flutter/material.dart';

import '../../features/characters/domain/models/character.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
    required this.onEdit,
  });

  final Character character;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _factionColor(character.factionKey, colorScheme),
          child: Text(
            character.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        title: Text(character.name),
        subtitle: Text(_subtitle(character)),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Editar',
          onPressed: onEdit,
        ),
      ),
    );
  }

  String _subtitle(Character c) {
    final parts = <String>[
      _capitalize(c.classKey),
      c.mainSpec,
    ];
    if (c.level != null) parts.add('Nv. ${c.level}');
    return parts.join(' · ');
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Color _factionColor(String factionKey, ColorScheme scheme) {
    return factionKey == 'alliance' ? Colors.blue.shade700 : Colors.red.shade700;
  }
}
