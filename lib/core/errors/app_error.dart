sealed class AppError implements Exception {
  const AppError(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class AuthError extends AppError {
  const AuthError(super.message);
}

class FirestoreError extends AppError {
  const FirestoreError(super.message);
}

class SearchError extends AppError {
  const SearchError(super.message);
}

class ValidationError extends AppError {
  const ValidationError(super.message);
}
