# 03-pantallas.md

**Metadata**

- Doc: pantallas, flujos, componentes, estados visuales
- Estado: cerrado para MVP
- Dependencias documentales: 01-producto.md, 02-requerimientos.md
- Dependientes: 06-convenciones.md

## Objetivo

Inventario mínimo de pantallas, flujos y componentes del MVP.

## 1. Inventario de pantallas

### P-01. Login (`LoginPage`)

**Objetivo**: autenticación con Google.

**Contenido**

- nombre de la app
- botón "Continuar con Google"
- estado loading
- mensaje de error inline si falla

### P-02. Mis personajes (`CharactersPage`)

**Objetivo**: listar personajes del usuario y permitir alta rápida.

**Contenido**

- listado vertical de `CharacterCard` (nombre, clase, spec principal, nivel)
- FAB "Nuevo personaje"
- tap en card → dashboard del personaje
- acceso a editar personaje desde el card

### P-03. Crear / editar personaje (`CharacterFormPage`)

**Objetivo**: capturar o editar datos base del personaje.

**Campos** (definición canónica en `04-modelo-datos.md` §2)

- `name`
- `classKey` (selector con catálogo)
- `raceKey` (selector con catálogo)
- `factionKey` (derivado, solo lectura)
- `mainSpec`
- `secondarySpec` (opcional, segunda especialización si está activa en el juego)
- `level`
- `profession1`, `profession2`
- `notes`

### P-04. Dashboard del personaje (`CharacterDashboardPage`)

**Objetivo**: vista principal de consulta y seguimiento.

**Contenido**

- cabecera con datos del personaje
- contadores por `status`
- barra de filtros (`type`, `priority`)
- lista de `GoalCard`
- FAB "Agregar objetivo"

### P-05. Buscar / agregar objetivo (`GoalFormPage`)

**Objetivo**: crear un objetivo manual o desde búsqueda externa.

**Contenido**

- selector de `type`
- segmented control: manual / búsqueda
- modo búsqueda: input + lista de `SearchResultCard`. Solo habilitado si `type` ∈ {`gear`, `enchant`, `gem`, `special_item`}
- modo manual: formulario directo
- formulario de objetivo (siempre visible tras seleccionar modo)
- botón guardar

### P-06. Detalle / edición de objetivo (`GoalDetailPage`)

**Objetivo**: consultar y actualizar un objetivo existente.

**Contenido**

- `type` y `name`
- `status` editable
- `priority` editable
- `slot` (si aplica)
- bloque de fuente externa (si `externalPayloadSnapshot` existe)
- `sourceText`
- `note`
- botón guardar

## 2. Flujos

### Flujo A. Onboarding mínimo

1. Login
2. Mis personajes (vacío)
3. Crear personaje
4. Dashboard vacío
5. Agregar primer objetivo

### Flujo B. Uso normal

1. Abrir personaje
2. Ver pendientes
3. Filtrar
4. Abrir detalle
5. Actualizar `status` o `priority`

### Flujo C. Alta desde fuente externa

1. Dashboard
2. Agregar objetivo → seleccionar `type` aplicable
3. Modo búsqueda
4. Escribir texto, ver resultados
5. Seleccionar resultado
6. Ajustar campos
7. Guardar

## 3. Navegación

Pantallas registradas en `go_router`:

- `/login` → `LoginPage`
- `/characters` → `CharactersPage`
- `/characters/new` → `CharacterFormPage`
- `/characters/:id/edit` → `CharacterFormPage`
- `/characters/:id` → `CharacterDashboardPage`
- `/characters/:id/goals/new` → `GoalFormPage`
- `/characters/:id/goals/:goalId` → `GoalDetailPage`

## 4. Estados visuales

### Globales

- `loading`: indicador centrado, no bloqueante en navegación
- `empty`: ilustración o icono + texto + CTA
- `error`: bloque inline con mensaje + botón reintentar (para cargas de datos), `SnackBar` (para acciones)
- `success`: `SnackBar` breve para acciones de escritura

### Mis personajes

- sin personajes → empty state con CTA "Crear primer personaje"
- con personajes → lista
- error de carga → bloque error con reintentar

### Dashboard del personaje

- sin objetivos → empty state con CTA "Agregar objetivo"
- con objetivos → lista
- filtros sin coincidencias → mensaje "no hay objetivos con estos filtros"

### Búsqueda externa

- estado inicial: sin búsqueda ejecutada
- buscando: spinner inline
- sin resultados: mensaje + sugerencia de modo manual
- resultados disponibles: lista
- error de Cloud Function: mensaje + sugerencia de modo manual

## 5. Componentes reutilizables

Viven en `lib/shared/widgets/`. Lista canónica del MVP:

- `CharacterCard`
- `GoalCard`
- `StatusChip`
- `PriorityChip`
- `EmptyState`
- `FilterBar`
- `SearchResultCard`
- `AppScaffold`
- `PrimaryButton`
- `TextFieldGroup`

No introducir componentes nuevos sin actualizar esta lista primero.

## 6. Wireframes textuales

### Login

- header con nombre de app
- subtítulo corto
- botón Google centrado

### Mis personajes

- AppBar con título
- Lista vertical de `CharacterCard`
- FAB "Nuevo personaje"

### Dashboard del personaje

- Cabecera: nombre, clase, spec, nivel, facción
- Fila de contadores por `status`
- `FilterBar` (`type`, `priority`)
- Lista vertical de `GoalCard`
- FAB "Agregar objetivo"

### Buscar / agregar objetivo

- Selector de `type`
- Segmented control: manual / búsqueda
- Modo búsqueda: input + resultados
- Formulario editable
- Botón guardar (sticky bottom)

### Detalle de objetivo

- Encabezado con `name` y `type`
- `StatusChip`, `PriorityChip` editables
- Bloque "fuente externa" (si existe)
- Bloque `sourceText`
- Bloque `note`
- Botón guardar

## Open questions (no bloqueantes)

- Variantes de empty state ilustrado (post-MVP).
- Animaciones de transición entre pantallas.

## Notas para implementación asistida por IA

- Toda pantalla con datos debe implementar los cuatro estados visuales globales. Si falta uno, está incompleta.
- Las rutas listadas en §3 son canónicas. Cambios requieren actualizar este doc primero.
- Componentes nuevos requieren entrada en §5 antes de crearse.
- El comportamiento "modo búsqueda solo si `type` aplica" en P-05 viene de `02-requerimientos.md` RF-05.
