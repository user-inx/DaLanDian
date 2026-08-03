abstract class Entity {
  final String id;

  final DateTime createdAt;

  final DateTime updatedAt;

  const Entity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
}