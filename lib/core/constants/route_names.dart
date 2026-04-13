abstract final class RouteNames {
  static const login = '/login';
  static const characters = '/characters';
  static const characterNew = '/characters/new';

  static String characterEdit(String id) => '/characters/$id/edit';
}
