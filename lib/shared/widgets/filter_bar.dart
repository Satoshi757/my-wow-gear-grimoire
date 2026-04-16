import 'package:flutter/material.dart';

import '../../core/catalogs/goal_priorities.dart';
import '../../core/catalogs/goal_types.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({
    super.key,
    required this.selectedType,
    required this.selectedPriority,
    required this.onTypeChanged,
    required this.onPriorityChanged,
  });

  final String? selectedType;
  final String? selectedPriority;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: 'Tipo',
            value: selectedType,
            options: {for (final t in goalTypes) t: goalTypeLabels[t]!},
            onChanged: onTypeChanged,
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Prioridad',
            value: selectedPriority,
            options: {for (final p in goalPriorities) p: goalPriorityLabels[p]!},
            onChanged: onPriorityChanged,
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isActive = value != null;
    return FilterChip(
      label: Text(isActive ? options[value]! : label),
      selected: isActive,
      onSelected: (_) => _showPicker(context),
      showCheckmark: false,
      deleteIcon: isActive ? const Icon(Icons.close, size: 16) : null,
      onDeleted: isActive ? () => onChanged(null) : null,
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                label,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
            ),
            ...options.entries.map(
              (e) => ListTile(
                title: Text(e.value),
                trailing: value == e.key ? const Icon(Icons.check) : null,
                onTap: () {
                  onChanged(e.key);
                  Navigator.of(ctx).pop();
                },
              ),
            ),
            ListTile(
              title: const Text('Todos'),
              trailing: value == null ? const Icon(Icons.check) : null,
              onTap: () {
                onChanged(null);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
