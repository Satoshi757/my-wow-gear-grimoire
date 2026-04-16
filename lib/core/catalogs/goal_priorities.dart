/// Prioridades de objetivo. Keys en snake_case inglés (igual que Firestore).
/// Fuente: docs/04-modelo-datos.md §3.
const List<String> goalPriorities = [
  'high',
  'medium',
  'low',
  'nice_to_have',
];

const Map<String, String> goalPriorityLabels = {
  'high': 'Alta',
  'medium': 'Media',
  'low': 'Baja',
  'nice_to_have': 'Nice to have',
};

/// Orden numérico para sorting (menor = más urgente).
const Map<String, int> goalPriorityOrder = {
  'high': 0,
  'medium': 1,
  'low': 2,
  'nice_to_have': 3,
};
