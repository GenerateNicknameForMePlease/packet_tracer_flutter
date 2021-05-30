import 'package:dio/dio.dart';
import 'package:packet_tracer/models/user.dart';
import 'package:packet_tracer/utils/utils.dart';

class AuthApi {
  final Dio _client = Static.dio();

  Future<User> registration({String login, String password}) async {
    final res = await _client.post(
      ApiPath.users,
      data: {
        'email': login,
        'password': password,
      },
    );
    return User.fromJson(res.data);
  }

  Future<User> auth(String token) async {
    final res = await _client.get(
      ApiPath.users,
      options: Options(headers: {'authorization': token}),
    );
    return User.fromJson(res.data);
  }
}
