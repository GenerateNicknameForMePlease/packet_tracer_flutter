import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/data_source/local_storage.dart';
import 'package:packet_tracer/models/user.dart';
import 'package:packet_tracer/repository/auth_repository.dart';
import 'package:packet_tracer/utils/utils.dart';

abstract class UserState {}

class LoadingUserState extends UserState {}

class DataUserState extends UserState {}

class UserBloc extends Cubit<UserState> {
  UserBloc() : super(LoadingUserState());

  User _user;

  User get user => _user;

  final _authRepository = AuthRepository();

  Future<void> load() async {
    try {
      final token = LocalStorageApi.instance.getToken;
      _user = await _authRepository.auth(token);
      emit(DataUserState());
    } catch (e) {
      print(e);
      await Future.delayed(Constants.requestDuration);
      load();
    }
  }

  void logout() {
    LocalStorageApi.instance.logout();
    emit(LoadingUserState());
  }
}

