import 'dart:developer' as dev;

/// Logger del proyecto. Usar en lugar de print en todo el código.
void log(
  String message, {
  Object? error,
  StackTrace? stackTrace,
  String name = 'App',
}) {
  dev.log(message, name: name, error: error, stackTrace: stackTrace);
}
