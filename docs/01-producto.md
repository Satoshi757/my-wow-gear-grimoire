# 01-producto.md

**Metadata**

- Doc: producto y alcance
- Estado: cerrado para MVP
- Dependencias documentales: ninguna (raíz)
- Dependientes: 02, 03, 04, 05, 06

## Producto

**My WoW Gear Grimoire** es una app móvil para registrar, consultar y mantener visibles los objetivos de gear y mejoras de personajes en **World of Warcraft: The Burning Crusade Classic Anniversary Edition**.

## Versión del juego objetivo

El MVP se diseña exclusivamente para TBC Classic Anniversary. Catálogos de clases, razas, profesiones y slots reflejan TBC. No se contempla compatibilidad con Retail, Wrath Classic, Cataclysm Classic ni otras versiones. Si en el futuro se quiere soportar más versiones, se agregará un campo `gameVersion` al modelo de personaje en una fase posterior.

## Problema

El usuario tiene gear, enchants, gemas, materiales y notas repartidos entre links, páginas y apuntes sueltos. Esto provoca:

- pérdida de contexto
- dificultad para ver pendientes simultáneos
- poca claridad sobre qué falta y dónde conseguirlo

## Objetivo del producto

Centralizar por personaje los objetivos de progreso para poder consultarlos rápido, actualizarlos fácilmente y no perder información útil.

## Usuario objetivo

- Usuario principal: jugador individual.
- Usuario inicial real: el creador de la app y su grupo cercano.
- Perfil: jugador que persigue gear, enchants y mejoras específicas y quiere organización práctica, no theorycrafting.

## Propuesta de valor

Tener en un solo lugar:

- qué le falta a cada personaje
- qué prioridad tiene cada objetivo
- qué estado lleva
- dónde se consigue o qué nota le acompaña

## Caso de uso principal

El usuario define su lista ideal de gear y mejoras para un personaje, consulta rápidamente pendientes y registra notas o fuentes para no perderlas.

## Alcance del MVP

Incluye:

- login con Google
- múltiples personajes por cuenta
- alta y edición manual de personajes
- objetivos por personaje
- búsqueda externa de ítems/enchants vía Blizzard Game Data API
- captura manual completa cuando la búsqueda externa no aplique
- estados y prioridades por objetivo
- dashboard de pendientes por personaje

## Tipos de objetivo del MVP

Listado canónico (keys en `04-modelo-datos.md` §3):

- gear
- enchant
- material
- gema
- ítem especial
- nota libre

## Prioridades del MVP

- alta
- media
- baja
- nice to have

## Estados del MVP

- pendiente
- en progreso
- obtenido

## Fuera de alcance

- importación del personaje desde Blizzard Profile API
- OAuth de Battle.net por usuario final
- sincronización automática del gear equipado
- colaboración multiusuario, compartir listas
- recomendaciones automáticas BiS
- asociación validada entre gear, gemas, enchants y slots (más allá del campo `slot` opcional, no validado)
- monetización o ads
- borrado duro de personajes u objetivos desde UI
- soporte para otras versiones de WoW

## Integración externa: Blizzard Game Data API

Decisión cerrada. Detalles técnicos en `04-modelo-datos.md` §4 y `06-convenciones.md` §11.

- Proveedor: Blizzard Game Data API, namespace `static-classic`.
- Tipo de auth: OAuth Client Credentials. Solo el backend (Cloud Function) tiene credenciales. El usuario final nunca interactúa con Blizzard.
- Costo esperado: $0/mes para el volumen del MVP (free tier de Blizzard, Cloud Functions y Firestore).
- Fallback documentado: dataset estático community (npm `wow-classic-items` o dump de TrinityCore) si Blizzard API se vuelve impráctica. El contrato del servicio queda igual, solo cambia la implementación dentro de la Cloud Function.
- Tolerancia a fallos: si la Cloud Function o Blizzard API no responden, el usuario crea el objetivo manualmente sin fricción.

## Restricciones

- El valor principal se mantiene aunque la búsqueda externa falle o sea parcial.
- El foco es organización personal por personaje.
- El flujo principal funciona con captura manual end-to-end.

## Criterios de éxito

El MVP cumple si el usuario puede:

- crear varios personajes
- registrar objetivos por personaje
- marcar estado y prioridad
- consultar rápido qué falta
- guardar fuente o nota útil por objetivo

## Open questions (no bloqueantes)

- Estrategia de paginación para listas de personajes y objetivos cuando el volumen real lo justifique.
- Soporte de iOS post-MVP.
- Si abrir la app a usuarios fuera del círculo cercano requiere onboarding o no.
- Importación de personajes vía Blizzard Profile API como feature post-MVP (limitada en Classic, valor marginal).

## Notas para implementación asistida por IA

- Este doc define **qué** y **para quién**, no **cómo**. Cualquier decisión de implementación que no esté aquí debe buscarse en 02-06.
- Si una nueva idea no encaja en "Alcance del MVP", va a "Open questions" o a backlog post-MVP, no al código.
- "Tolerancia a integración parcial" no es opcional. Si una feature solo funciona cuando Blizzard responde, está mal diseñada.
