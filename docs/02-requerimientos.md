# 02-requerimientos.md

**Metadata**

- Doc: requerimientos funcionales, no funcionales y reglas de negocio
- Estado: cerrado para MVP
- Dependencias documentales: 01-producto.md
- Dependientes: 03-pantallas.md, 04-modelo-datos.md, 05-roadmap.md

## Objetivo

Definir qué tiene que hacer el MVP, bajo qué condiciones, y qué reglas de negocio aplican.

## 1. Requerimientos funcionales

### RF-01. Autenticación

El sistema permite iniciar sesión con cuenta Google mediante Firebase Auth.

**Criterios de aceptación**

- el usuario puede autenticarse
- el usuario puede cerrar sesión
- sin sesión no hay acceso a datos privados

### RF-02. Gestión de personajes

El sistema permite crear, editar, listar y archivar lógicamente personajes del usuario.

**Datos del personaje**

Definición canónica de campos en `04-modelo-datos.md` §2 (`characters`).

**Obligatorios para guardar**: `name`, `classKey`, `raceKey`, `mainSpec`. El resto son opcionales.

**Criterios de aceptación**

- un usuario puede registrar múltiples personajes
- la facción no se captura: se deriva de `raceKey` con la tabla en `04-modelo-datos.md` §4
- el listado solo muestra personajes del usuario autenticado
- archivar oculta el personaje sin borrarlo (solo en modelo, sin UI en MVP)

### RF-03. Gestión de objetivos

El sistema permite crear, editar, listar y archivar objetivos por personaje.

**Datos del objetivo**

Definición canónica de campos en `04-modelo-datos.md` §2 (`goals`).

**Obligatorios para guardar**: `name`, `type`, `status`, `priority`, `characterId`, `ownerUid`. El resto son opcionales.

**Criterios de aceptación**

- cada objetivo pertenece a un solo personaje y a un solo usuario
- el usuario puede cambiar `status` y `priority` desde el detalle
- el usuario puede registrar un objetivo completamente manual sin pasar por búsqueda externa

### RF-04. Dashboard por personaje

El sistema muestra un resumen del personaje con sus objetivos agrupados y filtrables.

**Capacidades**

- contadores por `status` (`pending`, `in_progress`, `obtained`)
- filtrar por `type`
- filtrar por `priority`
- ordenar por más reciente o por prioridad

**Criterios de aceptación**

- el usuario identifica rápido qué le falta
- el usuario puede entrar al detalle de un objetivo desde el dashboard

### RF-05. Búsqueda externa de ítems/enchants

El sistema permite buscar ítems o enchants vía Blizzard Game Data API y crear un objetivo a partir del resultado.

**Aplicabilidad**

La búsqueda externa aplica solo cuando `type` ∈ {`gear`, `enchant`, `gem`, `special_item`}. Para `material` y `free_note` el flujo es siempre manual.

**Comportamiento**

- buscar por texto
- mostrar resultados básicos (nombre, calidad, ícono, slot si aplica)
- permitir seleccionar un resultado
- autollenar campos disponibles del objetivo
- guardar `externalPayloadSnapshot` con la copia mínima del resultado
- permitir completar manualmente cualquier campo faltante

**Criterios de aceptación**

- si la búsqueda responde, el usuario puede crear un objetivo a partir del resultado en un solo flujo
- si la búsqueda falla, devuelve vacío, o no aplica al `type` elegido, el usuario puede continuar manualmente sin fricción

### RF-06. Nota y fuente manual

El sistema permite escribir una nota libre (`note`) y una referencia manual de obtención (`sourceText`) en cualquier objetivo, exista o no fuente externa.

**Criterios de aceptación**

- el usuario puede guardar texto libre en ambos campos
- el objetivo no depende de datos externos para existir

## 2. Requerimientos no funcionales

### RNF-01. Simplicidad

Claridad y rapidez sobre complejidad funcional. Cada feature nueva pasa el test de "¿el usuario lo va a usar la primera semana?".

### RNF-02. Rendimiento

Pantallas principales cargan sin retrasos perceptibles bajo el volumen típico del MVP (decenas de personajes, cientos de objetivos).

### RNF-03. Tolerancia a integración parcial

La app sigue siendo útil sin Blizzard API. Cualquier flujo que se rompa cuando la Cloud Function falla está mal diseñado.

### RNF-04. Seguridad

Cada usuario solo accede a sus propios `characters` y `goals`. Reglas en `04-modelo-datos.md` §10.

### RNF-05. Mantenibilidad

Estructura por feature y slice. Detalle en `06-convenciones.md` §3.

### RNF-06. Plataforma

Android primero. iOS y web fuera de MVP.

### RNF-07. Observabilidad

Errores no manejados se reportan vía Crashlytics. Sin Analytics en MVP.

## 3. Reglas de negocio

- **RB-01.** Un personaje pertenece a un solo usuario (`ownerUid`).
- **RB-02.** Un objetivo pertenece a un solo personaje (`characterId`) y a un solo usuario (`ownerUid`).
- **RB-03.** `factionKey` se deriva de `raceKey`. Tabla canónica en `04-modelo-datos.md` §4.
- **RB-04.** Un objetivo puede provenir de fuente externa o de captura manual; ambos caminos son válidos.
- **RB-05.** `name` es obligatorio en todo objetivo, exista o no fuente externa.
- **RB-06.** `sourceText` y `note` son opcionales, pero siempre disponibles para captura.
- **RB-07.** `type`, `status`, `priority`, `factionKey` son catálogos cerrados. Strings sueltos están prohibidos.
- **RB-08.** Borrado lógico vía `isArchived = true`. No hay borrado duro desde UI en MVP.
- **RB-09.** `characterId` de un `goal` debe apuntar a un personaje del mismo `ownerUid`. Validado en cliente y en reglas Firestore.
- **RB-10.** El cliente Flutter no llama directo a Blizzard API. Toda búsqueda externa pasa por Cloud Function.

## 4. Casos de uso principales

### CU-01. Crear personaje

1. El usuario inicia sesión.
2. Entra a "Mis personajes".
3. Crea un personaje, captura datos obligatorios.
4. El sistema deriva `factionKey` y persiste.
5. El personaje aparece en el listado.

### CU-02. Crear objetivo manual

1. El usuario abre un personaje.
2. Elige "Agregar objetivo".
3. Selecciona modo manual.
4. Captura `type`, `name`, `priority` y opcionales.
5. Guarda. El objetivo aparece en el dashboard.

### CU-03. Crear objetivo desde búsqueda externa

1. El usuario abre un personaje.
2. Elige "Agregar objetivo" → modo búsqueda.
3. Escribe texto y ve resultados.
4. Selecciona uno. El sistema autollena campos y guarda `externalPayloadSnapshot`.
5. El usuario ajusta lo necesario.
6. Guarda.

### CU-04. Actualizar progreso

1. El usuario abre un objetivo.
2. Cambia `status` o `priority`.
3. Guarda. El dashboard refleja el cambio.

## 5. Criterios globales de aceptación del MVP

- el usuario puede autenticarse con Google
- puede crear múltiples personajes
- puede crear objetivos manuales
- puede crear objetivos desde búsqueda externa cuando hay resultados
- puede consultar pendientes por personaje
- puede editar `status`, `priority`, `note` y `sourceText`
- la app sigue siendo usable cuando la Cloud Function falla

## Open questions (no bloqueantes)

- Métricas concretas de rendimiento (target ms de carga del dashboard) cuando haya datos reales.
- Política de retención de `itemSearchCache` (TTL exacto, ver `04-modelo-datos.md` §2).

## Notas para implementación asistida por IA

- Si un campo de `characters` o `goals` no aparece en `04-modelo-datos.md` §2, **no existe**. Cualquier referencia es bug.
- Las reglas RB-01 a RB-10 son invariantes. Cualquier código que las pueda violar requiere validación explícita y test.
- "Tolerancia a integración parcial" se prueba apagando la Cloud Function en local y verificando que todos los flujos no-búsqueda siguen funcionando.
