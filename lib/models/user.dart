class User {
  final String chatToken;
  final int id;

  const User({this.id, this.chatToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      chatToken: json['chat_token'],
    );
  }
}