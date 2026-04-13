import 'package:flutter_test/flutter_test.dart';
import 'package:my_wow_gear_grimoire/core/catalogs/race_to_faction.dart';

void main() {
  group('factionKeyFor', () {
    test('razas de Alliance devuelven alliance', () {
      for (final race in ['human', 'dwarf', 'night_elf', 'gnome', 'draenei']) {
        expect(
          factionKeyFor(race),
          'alliance',
          reason: 'raza: $race',
        );
      }
    });

    test('razas de Horde devuelven horde', () {
      for (final race in ['orc', 'undead', 'tauren', 'troll', 'blood_elf']) {
        expect(
          factionKeyFor(race),
          'horde',
          reason: 'raza: $race',
        );
      }
    });

    test('cubre las 10 razas de TBC', () {
      const tbcRaces = [
        'human',
        'dwarf',
        'night_elf',
        'gnome',
        'draenei',
        'orc',
        'undead',
        'tauren',
        'troll',
        'blood_elf',
      ];
      for (final race in tbcRaces) {
        expect(
          () => factionKeyFor(race),
          returnsNormally,
          reason: 'raza: $race',
        );
      }
    });

    test('raza desconocida lanza ArgumentError', () {
      expect(() => factionKeyFor('goblin'), throwsArgumentError);
      expect(() => factionKeyFor(''), throwsArgumentError);
    });
  });
}
