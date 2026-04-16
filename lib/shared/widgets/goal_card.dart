import 'package:flutter/material.dart';

import '../../core/catalogs/goal_types.dart';
import '../../features/goals/domain/models/goal.dart';
import 'priority_chip.dart';
import 'status_chip.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  final Goal goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _typeIcon(goal.type),
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    goalTypeLabels[goal.type] ?? goal.type,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  if (goal.slot != null) ...[
                    Text(
                      ' · ${goal.slot}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                goal.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  StatusChip(status: goal.status),
                  const SizedBox(width: 6),
                  PriorityChip(priority: goal.priority),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(String type) => switch (type) {
        'gear' => Icons.shield_outlined,
        'enchant' => Icons.auto_fix_high_outlined,
        'gem' => Icons.diamond_outlined,
        'material' => Icons.inventory_2_outlined,
        'special_item' => Icons.stars_outlined,
        'free_note' => Icons.note_outlined,
        _ => Icons.help_outline,
      };
}
