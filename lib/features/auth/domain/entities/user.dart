class User {
  final String id;
  final String email;
  final String userName;
  final List<String> roles;
  final String token;

  User({
    required this.id, 
    required this.email, 
    required this.userName, 
    required this.roles, 
    required this.token
  });

  bool get isAdmim {
    return roles.contains('admin');
  }

}