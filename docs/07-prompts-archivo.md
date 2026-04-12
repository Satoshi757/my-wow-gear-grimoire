# 07-prompts-archivo.md

**Metadata**

- Doc: nota de archivado del prompts pack original
- Estado: archivado
- Dependencias documentales: ninguna
- Dependientes: ninguno

## Por qué este doc existe

La versión original del documento `07-prompts-ia.md` contenía un set de prompts reutilizables para pedir código a IAs genéricas en flujos sin contexto persistente. Eran útiles cuando la documentación se compartía manualmente y la IA no tenía forma de cargar el proyecto entero por defecto.

## Por qué se retira

El flujo de trabajo ahora es Claude Code con `CLAUDE.md` como contexto operativo automático. Las instrucciones que antes eran prompts ad-hoc ahora viven directamente en `CLAUDE.md` y en los docs `01-06`. Mantener prompts paralelos en un séptimo archivo crea dos fuentes de verdad y abre la puerta a divergencia.

## Qué se conserva del 07 original

El comportamiento que pedían los prompts originales sigue vigente, pero como **reglas operativas**, no como plantillas de texto:

- "No expandir alcance" → `CLAUDE.md` → Prohibiciones.
- "Respetar nombres de colecciones y campos" → `CLAUDE.md` → Reglas de negocio críticas y `04-modelo-datos.md`.
- "Trabajar en slices pequeños" → `CLAUDE.md` → Meta-instrucciones y `05-roadmap.md`.
- "Detectar contradicciones y detenerse" → `CLAUDE.md` → Anti-abstracción ("pregunta antes de asumir").
- "Refactor sin cambiar comportamiento" → práctica estándar, no necesita prompt dedicado.
- "Validar alineación contra docs" → `CLAUDE.md` → Meta-instrucciones paso 7.

## Cómo invocar comportamientos del 07 viejo

Cuando antes se hubiera dicho "usa el prompt 4 para Firestore", ahora simplemente se le pide a Claude Code:

> Implementa el repositorio de `characters` siguiendo `04-modelo-datos.md` y `06-convenciones.md`.

`CLAUDE.md` ya carga el resto del contexto y aplica las reglas.

## Notas para implementación asistida por IA

- No reintroducir `07-prompts-ia.md` como fuente de verdad operativa.
- Si surge la necesidad de un prompt parametrizable reutilizable, va a un README de la herramienta que lo consume, no a este paquete documental.
