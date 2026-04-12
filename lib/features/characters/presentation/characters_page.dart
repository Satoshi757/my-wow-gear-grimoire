import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Placeholder para Fase 1. Solo verifica que el usuario autenticado llega aquí.
class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis personajes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 48),
            const SizedBox(height: 16),
            Text(
              'Fase 1 — Próximamente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (user != null) ...[
              const SizedBox(height: 8),
              Text(
                'Sesión activa: ${user.displayName ?? user.email}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
