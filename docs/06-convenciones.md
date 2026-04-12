# 06-convenciones.md

**Metadata**

- Doc: convenciones de stack, estructura, código y operación
- Estado: cerrado para MVP
- Dependencias documentales: 01-producto.md, 02-requerimientos.md, 03-pantallas.md, 04-modelo-datos.md
- Dependientes: 05-roadmap.md

## Objetivo

Definir cómo se construye el MVP: stack, estructura, patrones, naming. Las decisiones de **producto** viven en 01-04. Aquí solo viven las decisiones de **implementación**.

## 1. Principios

- mantener el MVP pequeño
- claridad sobre sofisticación
- captura manual primero, integración después
- cada cambio respeta el paquete documental

## 2. Stack

| Capa                  | Tecnología                                          |
|-----------------------|-----------------------------------------------------|
| Lenguaje              | Dart 3.x                                            |
| Framework             | Flutter (canal stable)                              |
| Plataforma objetivo   | Android (iOS y web fuera de MVP)                    |
| State management      | `flutter_riverpod` + `riverpod_annotation`          |
| Router                | `go_router` (+ `go_router_builder` opcional)        |
| Modelos               | `freezed` + `json_serializable`                     |
| Auth                  | Firebase Auth + Google Sign-In                      |
| Persistencia          | Cloud Firestore                                     |
| Backend para API ext. | Cloud Functions (Node.js 20)                        |
| Crash reporting       | Firebase Crashlytics                                |
| Linter                | `flutter_lints` + reglas extra (ver §13)            |
| HTTP (si necesario)   | `http` (preferir sobre `dio` por simplicidad)       |

**Sin Analytics en MVP.**
**Sin DI externa** (`get_it` no se usa; Riverpod cubre DI).
**Sin librerías de UI extra** (sin `flutter_hooks`, sin design systems externos).

Agregar cualquier dependencia no listada requiere aprobación previa.

## 3. Estructura del proyecto

```
lib/
  app/
    app.dart
    router.dart
    theme.dart
  core/
    constants/
    errors/
    utils/
    catalogs/        # tipos, estados, prioridades, razas, clases, profesiones, slots
  features/
    auth/
      data/
      domain/
      presentation/
    characters/
      data/
      domain/
      presentation/
    goals/
      data/
      domain/
      presentation/
    search/
      data/
      domain/
      presentation/
  shared/
    widgets/
```

Cada feature contiene:

- `data/`: DTOs, mappers, repositorios, fuentes de datos
- `domain/`: modelos de dominio, contratos, lógica pura
- `presentation/`: pantallas, providers Riverpod, widgets específicos del feature

## 4. Naming

- Clases: `PascalCase`
- Variables y métodos: `camelCase`
- Archivos: `snake_case.dart`
- Keys de catálogos: `snake_case` en inglés (`free_note`, `nice_to_have`, `night_elf`)
- Colecciones Firestore: plural minúsculas (`characters`, `goals`)
- Pantallas: sufijo `Page` (`CharactersPage`)
- Widgets reutilizables: sin sufijo (`CharacterCard`, no `CharacterCardWidget`)
- Providers Riverpod generados: el sufijo lo agrega el generator
- Constantes top-level: `lowerCamelCase`. Prefijo `k` solo cuando hay conflicto

## 5. Modelos

- Modelos de dominio en `domain/models/`, con `freezed`.
- DTOs Firestore en `data/dtos/`, separados del dominio, con `fromJson` / `toJson`.
- Mappers explícitos en `data/mappers/`. Una función `toDomain()` y otra `toDto()` por entidad.
- **No mezclar** respuesta cruda de Firestore o de Blizzard con modelos de UI sin pasar por mapper.

## 6. Arquitectura mínima

- UI nunca toca `FirebaseFirestore.instance` directo. Va a través de un repositorio.
- Repositorios se exponen como providers Riverpod.
- Validaciones de formulario en `presentation/`. Validaciones de invariantes en `data/` antes de escribir.
- `Stream<AsyncValue<T>>` para listas en tiempo real cuando aplique. `Future` para acciones puntuales.

## 7. Manejo de errores

- Nunca silenciar excepciones. `catch (_) {}` está prohibido.
- Errores tipados en `core/errors/`:
  - `AuthError`
  - `FirestoreError`
  - `SearchError` (Cloud Function / Blizzard)
  - `ValidationError`
- Convertir errores técnicos a mensajes simples en la capa de presentación.
- Errores no manejados → Crashlytics automáticamente.
- Logs explícitos en flujos críticos vía un logger del proyecto. No `print`.

## 8. Catálogos

Definidos como constantes o enums en `core/catalogs/`. Fuente: `04-modelo-datos.md` §3.

- `goal_types.dart`
- `goal_statuses.dart`
- `goal_priorities.dart`
- `factions.dart`
- `slots.dart`
- `wow_classes.dart` (constante TBC)
- `wow_races.dart` (constante TBC)
- `professions.dart` (constante TBC)
- `race_to_faction.dart` (función pura `factionKeyFor`)

Strings sueltos repetidos en widgets son bug.

## 9. Formularios

- Validar campos obligatorios antes de guardar.
- Derivar `factionKey` desde `raceKey` automáticamente al cambiar el selector.
- No permitir guardar `Character` sin `name`, `classKey`, `raceKey`, `mainSpec`.
- No permitir guardar `Goal` sin `name`, `type`, `status`, `priority`, `characterId`, `ownerUid`.
- Mostrar errores de validación inline junto al campo, no en `SnackBar`.

## 10. Firestore

- Toda escritura incluye `ownerUid`, `createdAt` (en create), `updatedAt`.
- Toda escritura pasa por mapper.
- Queries siempre filtran por `ownerUid` aunque las reglas ya lo validen (defensa en profundidad).
- Usar `withConverter` para tipar las colecciones.
- Crear índices compuestos antes de hacer la primera query que los necesite (ver `04-modelo-datos.md` §9).

## 11. Cloud Functions

- Una sola función para el MVP: `searchItems`.
- Runtime: Node.js 20.
- OAuth Client Credentials a Blizzard, token cacheado en memoria de la función mientras esté caliente.
- Caché de resultados en `itemSearchCache` con TTL.
- Secretos en Secret Manager (`BLIZZARD_CLIENT_ID`, `BLIZZARD_CLIENT_SECRET`).
- El cliente nunca llama directo a Blizzard.
- La función tipa request y response.

## 12. Riverpod patterns

- `@riverpod` (code generation) salvo casos triviales.
- Un provider por responsabilidad.
- Repositorios como providers. No singletons globales.
- `AsyncValue<T>` para datos de Firestore. No envolver en clases custom.
- `ref.watch` en widgets, `ref.read` en callbacks.
- Sin `ChangeNotifier`.

## 13. Lints

`analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    require_trailing_commas: true
    avoid_print: true
    sort_child_properties_last: true
    use_key_in_widget_constructors: true
```

CI corre `flutter analyze` y falla en warnings.

## 14. Testing

Cobertura mínima por feature:

- mappers (DTO ↔ domain)
- derivación de facción (`factionKeyFor`)
- validaciones de formulario críticas
- repositorios en sus paths de happy + error

Stack de tests:

- `flutter_test`
- `mocktail` para mocks
- `fake_cloud_firestore` para repositorios

## 15. Commits

- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`
- Scope opcional: `feat(characters): ...`
- Mensaje en inglés, cuerpo en español si ayuda
- Un commit = un slice

## 16. Convenciones para IA

(Reforzadas en `CLAUDE.md`.)

- No generar features fuera del MVP.
- No introducir entidades, campos, colecciones o pantallas no documentadas.
- Respetar nombres de campos y catálogos de `04-modelo-datos.md`.
- Slices pequeños y verificables.
- Preguntar ante cualquier decisión no documentada.

## 17. Regla de cambio documental

Si cambia una decisión de datos, pantallas, flujo o stack:

1. Actualizar el doc correspondiente
2. Después implementar

Nunca al revés.

## Open questions (no bloqueantes)

- Estrategia de offline más allá del default de Firestore offline persistence.
- Si conviene `dio` en lugar de `http` cuando se sume el cliente HTTP.
- Generación de modelos via `build_runner` en CI.

## Notas para implementación asistida por IA

- Este doc es prescriptivo. Si una práctica no aparece aquí, usar la convención de Flutter idiomático y **señalarlo** al usuario para decidir si se documenta.
- Las dependencias listadas en §2 son las únicas aprobadas. Cualquier otra requiere preguntar.
- La estructura de carpetas en §3 es canónica. Mover archivos requiere actualizar este doc primero.
