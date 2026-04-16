import 'package:flutter/material.dart';

import '../../core/catalogs/goal_priorities.dart';

class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority, this.onTap});

  final String priority;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _priorityStyle(context, priority);
    final chip = Chip(
      label: Text(label, style: TextStyle(color: color.onColor)),
      backgroundColor: color.container,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }

  (String, _ChipColor) _priorityStyle(BuildContext context, String p) {
    final cs = Theme.of(context).colorScheme;
    return switch (p) {
      'high' => (goalPriorityLabels[p]!, _ChipColor(cs.errorContainer, cs.onErrorContainer)),
      'medium' => (goalPriorityLabels[p]!, _ChipColor(cs.tertiaryContainer, cs.onTertiaryContainer)),
      'low' => (goalPriorityLabels[p]!, _ChipColor(cs.surfaceContainerHighest, cs.onSurfaceVariant)),
      'nice_to_have' => (goalPriorityLabels[p]!, _ChipColor(cs.surfaceContainerHighest, cs.onSurfaceVariant)),
      _ => (p, _ChipColor(cs.surfaceContainerHighest, cs.onSurface)),
    };
  }
}

class _ChipColor {
  const _ChipColor(this.container, this.onColor);
  final Color container;
  final Color onColor;
}
