/// Tipos de objetivo. Keys en snake_case inglés (igual que Firestore).
/// Fuente: docs/04-modelo-datos.md §3.
const List<String> goalTypes = [
  'gear',
  'enchant',
  'gem',
  'material',
  'special_item',
  'free_note',
];

const Map<String, String> goalTypeLabels = {
  'gear': 'Gear',
  'enchant': 'Enchant',
  'gem': 'Gem',
  'material': 'Material',
  'special_item': 'Ítem especial',
  'free_note': 'Nota libre',
};

/// Tipos que habilitan la búsqueda externa (Fase 4).
const Set<String> goalTypesWithExternalSearch = {
  'gear',
  'enchant',
  'gem',
  'special_item',
};
