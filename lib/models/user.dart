class User {
  final int id;

  const User({this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
    );
  }
}