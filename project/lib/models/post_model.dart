class Post {
  final String id;
  final String userId;
  final String name;
  final String content;
  final String privacy;
  final String createdAt;

  Post(
      {this.id = "",
      required this.userId,
      required this.name,
      required this.content,
      required this.privacy,
      this.createdAt = ""});

  // factory Post.fromJson(Map<String, dynamic> json) {
  //   return Post(
  //     id: json['_id'],
  //     userId: json['userId'],
  //     content: json['content'],
  //     privacy: json['privacy'],
  //     createdAt: json['createdAt'],
  //   );
  // }
}
