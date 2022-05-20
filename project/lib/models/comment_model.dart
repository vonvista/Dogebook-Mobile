class Comment {
  final String id;
  final String userId;
  final String name;
  final String comment;
  final String createdAt;

  Comment({
    this.id = "",
    required this.userId,
    required this.name,
    required this.comment,
    this.createdAt = "",
  });
}
