/// Estados de objetivo. Keys en snake_case inglés (igual que Firestore).
/// Fuente: docs/04-modelo-datos.md §3.
const List<String> goalStatuses = [
  'pending',
  'in_progress',
  'obtained',
];

const Map<String, String> goalStatusLabels = {
  'pending': 'Pendiente',
  'in_progress': 'En progreso',
  'obtained': 'Obtenido',
};
