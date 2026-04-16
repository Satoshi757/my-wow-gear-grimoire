/// Tabla canónica raceKey → factionKey. Fuente: docs/04-modelo-datos.md §4.
/// Nunca capturar factionKey en UI — siempre derivar con esta función.
const Map<String, String> _raceToFaction = {
  'human': 'alliance',
  'dwarf': 'alliance',
  'night_elf': 'alliance',
  'gnome': 'alliance',
  'draenei': 'alliance',
  'orc': 'horde',
  'undead': 'horde',
  'tauren': 'horde',
  'troll': 'horde',
  'blood_elf': 'horde',
};

/// Devuelve el [factionKey] correspondiente a [raceKey].
/// Lanza [ArgumentError] si la raza no existe en el catálogo.
String factionKeyFor(String raceKey) {
  final faction = _raceToFaction[raceKey];
  if (faction == null) throw ArgumentError('raceKey desconocido: $raceKey');
  return faction;
}
