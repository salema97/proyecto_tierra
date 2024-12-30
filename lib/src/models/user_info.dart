class UserInfo {
  final String userName;
  final String email;
  final List<String?> roles;

  UserInfo({
    required this.userName,
    required this.email,
    this.roles = const [],
  });
}
