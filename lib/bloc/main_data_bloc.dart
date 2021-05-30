import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/widget_position.dart';
import 'package:packet_tracer/repository/data_repository.dart';
import 'package:packet_tracer/utils/constants.dart';

abstract class MainDataState {}

class LoadingMainDataState extends MainDataState {}

class DataMainDataState extends MainDataState {}

class MainDataBloc extends Cubit<MainDataState> {
  MainDataBloc() : super(LoadingMainDataState()) {
    _load();
  }

  final _dataRepository = DataRepository();

  List<Device> _devices;

  List<Device> get devices => _devices;

  List<WidgetPosition> _positions = [];

  List<WidgetPosition> get positions => _positions;

  Future<void> _load() async {
    try {
      _devices = await _dataRepository.getDevices();
      emit(DataMainDataState());
    } catch (e) {
      print(e);
      await Future.delayed(Constants.requestDuration);
      _load();
    }
  }

  void addPosition(WidgetPosition position) {
    _positions.remove(position);
    _positions.add(position);
  }
}