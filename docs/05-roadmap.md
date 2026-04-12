# 05-roadmap.md

**Metadata**

- Doc: orden de implementación por fases
- Estado: cerrado para MVP
- Dependencias documentales: 01-producto.md, 02-requerimientos.md, 04-modelo-datos.md, 06-convenciones.md
- Dependientes: ninguno

## Objetivo

Orden recomendado de implementación del MVP en fases pequeñas y verificables. Cada fase deja la app en estado usable.

## Fase 0. Setup base

**Entregables**

- proyecto Flutter creado, target Android
- `analysis_options.yaml` configurado (ver `06-convenciones.md` §13)
- Firebase project conectado
- Firebase Auth con Google Sign-In funcional
- Crashlytics integrado
- `go_router` configurado con rutas placeholder
- Riverpod configurado con `ProviderScope`
- tema base (Material 3, claro y oscuro)
- estructura de carpetas creada (`lib/app`, `lib/core`, `lib/features/*`, `lib/shared`)

**Criterio de salida**: la app compila, el usuario puede autenticarse con Google y ve una pantalla placeholder protegida.

## Fase 1. Personajes

**Entregables**

- pantalla `CharactersPage` con lista
- pantalla `CharacterFormPage` para crear/editar
- modelo `Character` (`freezed`) + DTO Firestore + mapper
- repositorio `CharactersRepository`
- providers Riverpod para listado y detalle
- derivación `factionKey` desde `raceKey`
- validaciones de formulario
- estados visuales: `loading`, `empty`, `error`

**Criterio de salida**: el usuario puede crear, editar y consultar múltiples personajes. No hay objetivos todavía.

## Fase 2. Objetivos manuales y dashboard

**Entregables**

- pantalla `CharacterDashboardPage`
- pantalla `GoalFormPage` (solo modo manual)
- pantalla `GoalDetailPage`
- modelo `Goal` + DTO + mapper
- repositorio `GoalsRepository`
- providers para dashboard y detalle
- contadores por `status`
- filtros por `type` y `priority`
- edición de `status` y `priority` desde detalle

**Criterio de salida**: el usuario puede usar la app completa sin tocar la integración externa.

## Fase 3. Hardening de seguridad y datos

**Entregables**

- reglas de seguridad Firestore desplegadas (ver `04-modelo-datos.md` §10)
- índices compuestos creados (ver `04-modelo-datos.md` §9)
- validaciones cliente endurecidas (catálogos, `ownerUid`, cross-check de `characterId`)
- tests de mappers y de derivación de facción
- revisión de queries y `withConverter`

**Criterio de salida**: la base es segura y consistente para uso real con datos del creador y amigos.

Hardening va antes que búsqueda externa intencionalmente: el modelo manual es estable y simple, conviene blindarlo antes de agregar la pieza con más superficie de error.

## Fase 4. Búsqueda externa (Blizzard Game Data API)

**Entregables**

- Cloud Function `searchItems` con OAuth Client Credentials a Blizzard
- caché en `itemSearchCache` con TTL
- `ItemSearchService` en cliente que llama a la Cloud Function
- modo búsqueda en `GoalFormPage`
- autollenado y guardado de `externalPayloadSnapshot`
- manejo de error y fallback a modo manual
- secretos de Blizzard (`BLIZZARD_CLIENT_ID`, `BLIZZARD_CLIENT_SECRET`) en Secret Manager

**Criterio de salida**: el usuario puede crear objetivos desde búsqueda externa cuando hay resultados, y todo lo demás sigue funcionando si la Cloud Function falla.

## Fase 5. Pulido de UX

**Entregables**

- empty states con ilustración o icono y CTA
- mensajes de error consistentes
- ordenamientos: por `priority` (`high` → `nice_to_have`) y por `updatedAt desc`
- transiciones entre pantallas
- revisión de copy

**Criterio de salida**: el flujo principal es claro, rápido y se siente terminado.

## Orden recomendado

1. autenticación (Fase 0)
2. personajes (Fase 1)
3. objetivos manuales y dashboard (Fase 2)
4. hardening de seguridad y datos (Fase 3)
5. búsqueda externa (Fase 4)
6. pulido de UX (Fase 5)

## Riesgos de ejecución

- depender prematuramente de la Cloud Function antes de tener las fases 1-3 cerradas
- crecer alcance antes de cerrar el flujo manual
- sobre-modelar relaciones gear/gem/enchant
- introducir dependencias Flutter no aprobadas

## Regla operativa

Si una fase posterior se bloquea por la integración externa, continuar con captura manual y no frenar el MVP. La búsqueda externa es un acelerador, no un prerrequisito.

## Notas para implementación asistida por IA

- Una fase no se considera terminada hasta que se cumple su criterio de salida verificable.
- Slices dentro de cada fase se proponen al usuario antes de implementar (ver `CLAUDE.md` → Meta-instrucciones).
- No saltar fases. Si Fase 2 está incompleta, no empezar Fase 3.
