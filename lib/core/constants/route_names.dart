abstract final class RouteNames {
  static const login = '/login';
  static const characters = '/characters';
  static const characterNew = '/characters/new';

  static String characterEdit(String id) => '/characters/$id/edit';
  static String characterDashboard(String id) => '/characters/$id';

  static String goalNew(String characterId) =>
      '/characters/$characterId/goals/new';

  static String goalDetail(String characterId, String goalId) =>
      '/characters/$characterId/goals/$goalId';
}
