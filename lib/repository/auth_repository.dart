import 'package:packet_tracer/data_source/auth_api.dart';
import 'package:packet_tracer/models/user.dart';

class AuthRepository {
  final _authApi = AuthApi();

  Future<User> registration({String login, String password}) async {
    return await _authApi.registration(login: login, password: password);
  }

  Future<User> auth(String token) async {
    return await _authApi.auth(token);
  }

}