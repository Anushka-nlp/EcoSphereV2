class User {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.fullName,
    this.profileImage,
  });

  final String id;
  final String username;
  final String email;
  final String role;

  final String? fullName;
  final String? profileImage;
}
