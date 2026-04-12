# 04-modelo-datos.md

**Metadata**

- Doc: modelo de datos Firestore, catálogos, reglas de seguridad
- Estado: cerrado para MVP
- Dependencias documentales: 01-producto.md, 02-requerimientos.md
- Dependientes: 03-pantallas.md, 06-convenciones.md

## Objetivo

Definir la estructura de datos del MVP en Cloud Firestore: colecciones, campos, catálogos, relaciones, índices y seguridad.

## 1. Criterios de diseño

- modelo plano y simple
- consultas eficientes por usuario y por personaje
- independiente de la integración externa
- seguro por `ownerUid`
- crecimiento incremental sin rehacer el MVP

## 2. Colecciones

### `users`

Documento por usuario autenticado.

**Ruta**: `users/{uid}`

**Campos**

- `uid: string`
- `email: string`
- `displayName: string`
- `photoUrl: string?`
- `createdAt: timestamp`
- `updatedAt: timestamp`

### `characters`

Documento por personaje.

**Ruta**: `characters/{characterId}`

**Campos**

- `ownerUid: string` (obligatorio)
- `name: string` (obligatorio)
- `classKey: string` (obligatorio, ver §3)
- `raceKey: string` (obligatorio, ver §3)
- `factionKey: string` (derivado de `raceKey`, ver §4)
- `mainSpec: string` (obligatorio)
- `secondarySpec: string?` (opcional, segunda especialización activa)
- `level: number?`
- `profession1: string?`
- `profession2: string?`
- `notes: string?`
- `isArchived: boolean` (default `false`)
- `createdAt: timestamp`
- `updatedAt: timestamp`

### `goals`

Documento por objetivo.

**Ruta**: `goals/{goalId}`

**Campos**

- `ownerUid: string` (obligatorio)
- `characterId: string` (obligatorio, debe apuntar a un personaje del mismo `ownerUid`)
- `type: string` (obligatorio, ver §3)
- `name: string` (obligatorio)
- `status: string` (obligatorio, ver §3, default `pending`)
- `priority: string` (obligatorio, ver §3)
- `slot: string?` (ver §3, aplica solo a `gear`/`enchant`, no validado por sistema)
- `externalSource: string?` (identificador del proveedor, ej. `blizzard_game_data`)
- `externalSourceId: string?` (id del recurso externo)
- `externalPayloadSnapshot: map?` (ver §4)
- `sourceText: string?`
- `note: string?`
- `isArchived: boolean` (default `false`)
- `createdAt: timestamp`
- `updatedAt: timestamp`

### `itemSearchCache`

Caché de resultados de Blizzard Game Data API. Escrito y leído **solo por la Cloud Function**, no por el cliente.

**Ruta**: `itemSearchCache/{queryHash}`

**Campos**

- `query: string`
- `results: array<map>`
- `fetchedAt: timestamp`
- `expiresAt: timestamp`

TTL recomendado por defecto: 30 días (TBC es contenido cerrado, los datos no cambian). TTL exacto queda como Open question.

## 3. Catálogos controlados

### `type`

- `gear`
- `enchant`
- `material`
- `gem`
- `special_item`
- `free_note`

### `status`

- `pending`
- `in_progress`
- `obtained`

### `priority`

- `high`
- `medium`
- `low`
- `nice_to_have`

### `factionKey`

- `alliance`
- `horde`

### `slot` (sugerido, no enum estricto)

`head`, `neck`, `shoulder`, `back`, `chest`, `wrist`, `hands`, `waist`, `legs`, `feet`, `finger`, `trinket`, `main_hand`, `off_hand`, `ranged`

El campo `slot` se almacena como string opcional. No se valida coherencia con `type` en el MVP.

### `classKey` y `raceKey`

**No se enumeran como enum estricto en código.** Se aceptan como string. Se mantiene una constante interna con los valores TBC para selectores de UI:

- Clases TBC: `warrior`, `paladin`, `hunter`, `rogue`, `priest`, `shaman`, `mage`, `warlock`, `druid`
- Razas TBC: `human`, `dwarf`, `night_elf`, `gnome`, `draenei`, `orc`, `undead`, `tauren`, `troll`, `blood_elf`

**No se valida coherencia raza/clase/facción en el MVP.** El usuario es responsable de su propia consistencia.

### Profesiones (sugerido)

`alchemy`, `blacksmithing`, `enchanting`, `engineering`, `herbalism`, `leatherworking`, `mining`, `skinning`, `tailoring`, `jewelcrafting`, `cooking`, `first_aid`, `fishing`.

## 4. Campos derivados y especiales

### `factionKey` derivada de `raceKey`

Tabla canónica:

| `raceKey`     | `factionKey` |
|---------------|--------------|
| `human`       | `alliance`   |
| `dwarf`       | `alliance`   |
| `night_elf`   | `alliance`   |
| `gnome`       | `alliance`   |
| `draenei`     | `alliance`   |
| `orc`         | `horde`      |
| `undead`      | `horde`      |
| `tauren`      | `horde`      |
| `troll`       | `horde`      |
| `blood_elf`   | `horde`      |

Implementación: función pura `factionKeyFor(raceKey)` en `core/catalogs/`. Nunca capturada en UI.

### `externalPayloadSnapshot`

Copia local mínima del resultado externo, almacenada en el momento de seleccionar el ítem. Objetivo: independencia de la integración externa después de la creación.

**Campos del snapshot** (todos opcionales, max ~2KB):

- `name: string`
- `icon: string` (URL del ícono)
- `quality: string` (ej. `epic`, `rare`)
- `itemLevel: number`
- `slot: string`
- `source: string` (texto descriptivo de obtención si Blizzard lo provee)
- `wowheadUrl: string`

Si crece más allá de 2KB, recortar `source` y `wowheadUrl` primero.

## 5. Relaciones

- un `user` tiene muchos `characters`
- un `character` tiene muchos `goals`
- un `goal` pertenece a un solo `character`
- un `goal` pertenece a un solo `ownerUid`

Modelo plano (no subcolecciones) para simplificar queries cross-character cuando sea necesario y mantener reglas de seguridad legibles.

## 6. Restricciones

- `ownerUid` obligatorio en `characters` y `goals`
- `name` obligatorio en `characters` y `goals`
- `type`, `status`, `priority` deben ser valores del catálogo en §3
- `characterId` de un `goal` debe apuntar a un `character` del mismo `ownerUid`
- `isArchived` permite ocultado lógico (sin UI en MVP, ver `02-requerimientos.md` RB-08)

## 7. Ejemplos

### `characters/{characterId}`

```json
{
  "ownerUid": "uid_123",
  "name": "Aldariel",
  "classKey": "priest",
  "raceKey": "draenei",
  "factionKey": "alliance",
  "mainSpec": "discipline",
  "secondarySpec": "holy",
  "level": 70,
  "profession1": "tailoring",
  "profession2": "enchanting",
  "notes": "Main healer arena",
  "isArchived": false
}
```

### `goals/{goalId}`

```json
{
  "ownerUid": "uid_123",
  "characterId": "char_001",
  "type": "enchant",
  "name": "Enchant Cloak - Spell Penetration",
  "status": "pending",
  "priority": "high",
  "slot": "back",
  "externalSource": "blizzard_game_data",
  "externalSourceId": "25086",
  "externalPayloadSnapshot": {
    "name": "Enchant Cloak - Spell Penetration",
    "icon": "https://...",
    "quality": "common",
    "slot": "back"
  },
  "sourceText": "Vendor in Shattrath",
  "note": "Importante para arena set",
  "isArchived": false
}
```

## 8. Consultas esperadas

### Q-01. Listar personajes del usuario

```
characters
  where ownerUid == currentUser.uid
  where isArchived == false
  orderBy updatedAt desc
```

### Q-02. Dashboard de objetivos por personaje

```
goals
  where ownerUid == currentUser.uid
  where characterId == selectedCharacterId
  where isArchived == false
  orderBy updatedAt desc
```

### Q-03. Filtrar por estado

Agregar: `where status == selectedStatus`

### Q-04. Filtrar por tipo

Agregar: `where type == selectedType`

## 9. Índices compuestos

- `characters(ownerUid, isArchived, updatedAt desc)`
- `goals(ownerUid, characterId, isArchived, updatedAt desc)`
- `goals(ownerUid, characterId, status, isArchived, updatedAt desc)`
- `goals(ownerUid, characterId, type, isArchived, updatedAt desc)`

## 10. Reglas de seguridad

### Principio general

El usuario solo lee y escribe documentos cuyo `ownerUid == request.auth.uid`.

### `users`

- Read/write: solo el propio documento.

### `characters`

- Read: `ownerUid == auth.uid`
- Create: `ownerUid == auth.uid` y validar presencia de `name`, `classKey`, `raceKey`, `mainSpec`
- Update: `ownerUid == auth.uid` y `resource.data.ownerUid == request.resource.data.ownerUid` (no se puede cambiar `ownerUid`)
- Delete: deshabilitado en MVP (usar `isArchived`)

### `goals`

- Read: `ownerUid == auth.uid`
- Create: `ownerUid == auth.uid`, `name`, `type`, `status`, `priority` válidos según catálogo, y `characterId` debe existir y pertenecer al mismo `ownerUid`
- Update: igual que create, no cambia `ownerUid` ni `characterId`
- Delete: deshabilitado en MVP

### `itemSearchCache`

- Read/write: deshabilitado para clientes. Solo accesible vía Cloud Function con Admin SDK.

## 11. Borrado

Todo borrado en MVP es lógico (`isArchived = true`). El campo existe en el modelo y las queries lo respetan, pero no se expone botón "eliminar" ni "archivar" en UI. Post-MVP se decide cómo exponerlo.

## Open questions (no bloqueantes)

- TTL exacto de `itemSearchCache`.
- Catálogo formal de profesiones (hoy es "sugerido").
- Si conviene una colección futura de catálogos versionados.

## Notas para implementación asistida por IA

- Cualquier campo no listado en §2 **no existe**. No agregar campos ad-hoc.
- Catálogos en §3 son la única fuente. Strings sueltos como `"Pending"` o `"obtenido"` son bug.
- La derivación `factionKey` se hace en código del cliente. Las reglas de seguridad **no** la validan.
- `externalPayloadSnapshot` es un map opcional; si está ausente no se renderiza el bloque correspondiente en UI.
- Reglas de seguridad escritas a mano respetando esta especificación. Si hay duda, preguntar antes de afinar.
