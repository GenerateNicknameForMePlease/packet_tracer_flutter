class User {
  final String chatToken;

  const User({this.chatToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User();
  }
}