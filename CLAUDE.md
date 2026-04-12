# CLAUDE.md

Documentación operativa para Claude Code en el proyecto **My WoW Gear Grimoire**.

## Filosofía

App pequeña, alcance cerrado, valor inmediato. El MVP sirve a un grupo real (yo y mis amigos jugando TBC Classic Anniversary). No es un producto comercial, no es una plataforma, no es un framework. Es una herramienta personal que tiene que funcionar bien en lo que promete y nada más.

Tres principios que mandan sobre cualquier otro:

1. **Captura manual primero.** Todo flujo tiene que funcionar sin integraciones externas. La búsqueda externa es un acelerador, no una dependencia.
2. **Slices pequeños y verificables.** Cada cambio debe poder probarse aislado y dejar la app en estado usable.
3. **Documentación como fuente de verdad.** Si el código y los docs discrepan, los docs ganan, y el código se ajusta o el doc se actualiza primero. No hay tercera opción.

## Anti-abstracción

Esta sección tiene prioridad sobre instinto, hábito y cualquier "best practice" genérica.

**No crear abstracciones especulativas.** Una interfaz, una clase base, un wrapper, un helper genérico solo existen cuando hay **dos o más** call-sites concretos que los necesitan hoy. No "por si más adelante". No "para ser flexibles". No "para facilitar testing" si nadie está testeando eso todavía.

**No sobre-modelar.** Si un campo es un string, es un string. No se vuelve un value object hasta que haya lógica real que justifique el value object. Un `enum` o `freezed union` es válido cuando hay comportamiento polimórfico, no cuando es una lista de strings.

**No introducir patrones sin caso de uso presente.** Repository, DTO y mapper existen donde el doc 06 los pide. No se agregan capas adicionales (Service, Manager, Coordinator, UseCase, Provider de Provider) sin discutirlo primero.

**Preferir duplicación temprana sobre abstracción equivocada.** Si dos features se parecen en 70%, viven separadas hasta que el patrón sea obvio.

**Pregunta antes de asumir.** Si una decisión no está en los docs, **detente y pregunta**. No infieras "lo más razonable". No elijas "lo estándar de la industria". Las decisiones no documentadas son decisiones no tomadas, y tomarlas sin consultar genera deuda silenciosa. Esto incluye:

- nombres de archivos, clases o métodos no especificados
- estructura interna de un feature no descrita
- librerías no listadas en `docs/06-convenciones.md`
- cambios al modelo de datos
- nuevas pantallas, nuevos campos, nuevos catálogos

## Fuente de verdad documental

Toda decisión de producto, datos o flujo vive en los docs. Antes de implementar cualquier cosa, leer el doc relevante:

- `docs/01-producto.md` — qué es la app, qué problema resuelve, qué está dentro y qué fuera del MVP.
- `docs/02-requerimientos.md` — requerimientos funcionales, no funcionales y reglas de negocio.
- `docs/03-pantallas.md` — inventario de pantallas, flujos y componentes.
- `docs/04-modelo-datos.md` — modelo Firestore, catálogos, reglas de seguridad.
- `docs/05-roadmap.md` — orden de implementación por fases.
- `docs/06-convenciones.md` — stack, estructura, naming, patrones de código.
- `docs/07-prompts-archivo.md` — nota de archivado del prompts pack original.

Si un doc no responde una pregunta, **pregunta al humano antes de codear**.

## Stack

Detalle completo en `docs/06-convenciones.md` §2. Resumen ejecutivo:

- Flutter (canal stable), Android primero
- Dart 3.x
- Riverpod (`flutter_riverpod` + `riverpod_annotation`)
- `go_router`
- `freezed` + `json_serializable`
- Firebase Auth (Google Sign-In)
- Cloud Firestore
- Cloud Functions (Node.js, proxy a Blizzard Game Data API)
- Firebase Crashlytics
- `flutter_lints` + reglas extra

Sin Analytics, sin `get_it`, sin librerías de UI extra. Agregar dependencias requiere aprobación.

## Estructura

Definida en `docs/06-convenciones.md` §3. Resumen:

```
lib/
  app/        # bootstrap, router, theme
  core/       # constantes, errores, catálogos, utilidades
  features/
    auth/
    characters/
    goals/
    search/
  shared/     # widgets reutilizables
```

Cada feature: `data/`, `domain/`, `presentation/`.

## Reglas de negocio críticas

Fuente completa: `docs/02-requerimientos.md` §3 y `docs/04-modelo-datos.md`. Las que más se rompen accidentalmente:

- `ownerUid` es obligatorio en todo documento de `characters` y `goals`. Sin excepciones.
- Un `goal.characterId` debe apuntar a un personaje del **mismo** `ownerUid`. La regla de seguridad lo valida, pero el cliente también valida antes de escribir.
- `factionKey` se **deriva** de `raceKey` con la tabla en `docs/04-modelo-datos.md` §4. Nunca se captura en UI.
- `type`, `status`, `priority`, `factionKey` son catálogos cerrados. Strings sueltos en código son bug.
- Borrado: `isArchived = true`. No hay borrado duro ni UI de archivado en MVP.
- Un `goal` puede tener fuente externa **o** ser totalmente manual. `name` siempre obligatorio.
- El cliente Flutter no llama directo a Blizzard. Toda búsqueda externa pasa por la Cloud Function.

## Reglas específicas del stack

### Riverpod

- Usar `@riverpod` (code generation) salvo casos triviales.
- Un provider por responsabilidad. No mega-providers.
- `AsyncValue<T>` para datos que vienen de Firestore. No envolver en clases custom.
- Repositorios se exponen como providers, no como singletons globales.
- `ref.watch` en widgets, `ref.read` en callbacks.

### go_router

- Una sola instancia de router en `lib/app/router.dart`.
- Nombres de rutas como constantes en `core/constants/`.
- Rutas tipadas con `go_router_builder` cuando aplique.

### freezed

- Modelos de dominio: `freezed` con `copyWith` e inmutabilidad.
- DTOs Firestore: separados del modelo de dominio, con `fromJson` / `toJson`.
- Mapper explícito entre DTO y dominio en `data/mappers/`. No mezclar.

### Firestore

- Toda escritura pasa por un repositorio. Nada de `FirebaseFirestore.instance` en widgets.
- Toda escritura incluye `ownerUid`, `createdAt` (en create), `updatedAt`.
- Las queries siempre filtran por `ownerUid` aunque las reglas ya lo validen (defensa en profundidad).
- Usar `withConverter` para tipar las colecciones.

### Cloud Functions

- Una sola función para el MVP: `searchItems`. Proxy a Blizzard Game Data API.
- Token OAuth Client Credentials se obtiene en la función y se cachea en memoria.
- Resultados se cachean en `itemSearchCache` (Firestore) con TTL.
- Secretos en Secret Manager (`BLIZZARD_CLIENT_ID`, `BLIZZARD_CLIENT_SECRET`).
- El cliente Flutter **nunca** habla directo con Blizzard.

## Errores

- Nunca silenciar excepciones. `catch (_) {}` está prohibido.
- Convertir errores técnicos a mensajes simples para el usuario en la capa de presentación, no en datos.
- Errores tipados en `core/errors/`: `AuthError`, `FirestoreError`, `SearchError`, `ValidationError`.
- Errores no manejados → Crashlytics automáticamente.
- Logs explícitos en flujos críticos vía logger del proyecto. Nunca `print`.

## UI

- Material 3, tema claro y oscuro desde Fase 0.
- Estados visuales obligatorios en pantallas con datos: `loading`, `empty`, `error`, `success`.
- Errores de acción se muestran como `SnackBar`. Errores de carga de datos se muestran como bloque inline con reintentar.
- Errores de validación de formulario inline junto al campo, no en `SnackBar`.
- Componentes reutilizables en `lib/shared/widgets/`. Lista canónica en `docs/03-pantallas.md` §5.
- No introducir un componente nuevo si uno existente cubre el caso con mínima variación.

## Naming

- Clases: `PascalCase`
- Variables y métodos: `camelCase`
- Archivos: `snake_case.dart`
- Keys de catálogos: `snake_case` en inglés (`free_note`, `nice_to_have`, `night_elf`)
- Colecciones Firestore: plural minúsculas (`characters`, `goals`)
- Pantallas: sufijo `Page` (`CharactersPage`)
- Widgets reutilizables: sin sufijo (`CharacterCard`, no `CharacterCardWidget`)
- Providers Riverpod generados: el sufijo lo agrega el generator

## Commits

- Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, `test:`
- Scope opcional: `feat(characters): ...`, `fix(goals): ...`
- Mensaje en inglés, cuerpo en español si ayuda
- Un commit = un slice. No mezclar refactor con feature.

## Meta-instrucciones para Claude Code

Cuando recibas una tarea:

1. **Lee primero.** Antes de escribir código, lee los docs relevantes. No asumas que recuerdas su contenido.
2. **Confirma el slice.** Si la tarea es ambigua o más grande que un slice, propone descomposición y espera confirmación.
3. **Muestra el plan.** Lista archivos a tocar y por qué, antes de tocarlos.
4. **Pregunta cuando dudes.** Cualquier decisión no documentada se pregunta. Mejor cinco preguntas que una asunción.
5. **Implementa el slice completo.** Código + tests cuando aplique + actualización de docs si la decisión cambió algo.
6. **No expandas.** No agregues "mientras estoy aquí" features, refactors, o limpiezas. Si ves algo que arreglar, lo señalas, no lo arreglas.
7. **Verifica contra docs.** Antes de cerrar el slice, valida que nombres de campos, catálogos, colecciones y dependencias coincidan con la documentación.

Si una instrucción del usuario contradice un doc, **detente y pregunta** cuál gana.

## Prohibiciones

- No agregar dependencias no listadas en `docs/06-convenciones.md` sin aprobación.
- No introducir nuevas entidades, colecciones o campos sin actualizar `docs/04-modelo-datos.md` primero.
- No crear nuevas pantallas sin actualizar `docs/03-pantallas.md` primero.
- No silenciar errores ni usar `catch (_) {}`.
- No usar `print` en código de producción. Usar logger del proyecto.
- No hacer borrado duro de documentos Firestore desde la UI.
- No llamar directo a Blizzard API desde el cliente Flutter. Solo vía Cloud Function.
- No exponer secretos en el repo. `client_id` y `client_secret` viven en Secret Manager.
- No reintroducir features marcadas como fuera de alcance en `docs/01-producto.md`.
- No tocar reglas de Firestore sin entender el modelo de seguridad de `docs/04-modelo-datos.md` §10.
- No expandir el alcance del MVP. Si surge una idea, va a "Open questions" del doc relevante o a backlog post-MVP.
- No reintroducir `07-prompts-ia.md` como fuente de verdad operativa (ver `docs/07-prompts-archivo.md`).
