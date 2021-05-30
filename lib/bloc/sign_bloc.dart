import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/data_source/local_storage.dart';
import 'package:packet_tracer/repository/auth_repository.dart';
import 'package:packet_tracer/utils/toast.dart';

abstract class SignState {}

class LoadingSignState extends SignState {}

class DataSignState extends SignState {}

class SuccessSignState extends SignState {}

class SignBloc extends Cubit<SignState> {
  SignBloc() : super(DataSignState());

  final _authRepository = AuthRepository();

  Future<void> login({String login, String password}) async {
    emit(LoadingSignState());
    final token = base64Encode(utf8.encode('$login:$password'));
    try {
      await _authRepository.auth(token);
      LocalStorageApi.instance.setToken(token);
      emit(SuccessSignState());
    } catch (e) {
      print(e);
      ToastMsg.showToast('Что-то пошло не так');
      emit(DataSignState());
    }
  }

  Future<void> registration({String login, String password}) async {
    emit(LoadingSignState());
    try {
      await _authRepository.registration(
        login: login,
        password: password,
      );
      final token = base64Encode(utf8.encode('$login:$password'));
      LocalStorageApi.instance.setToken(token);
      emit(SuccessSignState());
    } catch (e) {
      print(e);
      ToastMsg.showToast('Что-то пошло не так');
      emit(DataSignState());
    }
  }
}
