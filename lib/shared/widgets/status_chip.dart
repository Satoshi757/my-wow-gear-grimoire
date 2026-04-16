import 'package:flutter/material.dart';

import '../../core/catalogs/goal_statuses.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.onTap});

  final String status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _statusStyle(context, status);
    final chip = Chip(
      label: Text(label, style: TextStyle(color: color.onColor)),
      backgroundColor: color.container,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
    if (onTap == null) return chip;
    return GestureDetector(onTap: onTap, child: chip);
  }

  (String, _ChipColor) _statusStyle(BuildContext context, String s) {
    final cs = Theme.of(context).colorScheme;
    return switch (s) {
      'pending' => (goalStatusLabels[s]!, _ChipColor(cs.surfaceContainerHighest, cs.onSurfaceVariant)),
      'in_progress' => (goalStatusLabels[s]!, _ChipColor(cs.primaryContainer, cs.onPrimaryContainer)),
      'obtained' => (goalStatusLabels[s]!, _ChipColor(cs.secondaryContainer, cs.onSecondaryContainer)),
      _ => (s, _ChipColor(cs.surfaceContainerHighest, cs.onSurface)),
    };
  }
}

class _ChipColor {
  const _ChipColor(this.container, this.onColor);
  final Color container;
  final Color onColor;
}
