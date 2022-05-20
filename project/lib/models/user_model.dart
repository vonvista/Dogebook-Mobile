class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final List<String> friends;
  final List<String> friendRequests;

  User({
    this.id = "",
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.friends,
    required this.friendRequests,
  });
}
