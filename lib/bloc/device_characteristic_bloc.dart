import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/repository/device_repository.dart';

abstract class DeviceCharacteristicState {
  final List<num> impulses;

  DeviceCharacteristicState(this.impulses);
}

class LoadingDeviceCharacteristicState extends DeviceCharacteristicState {
  LoadingDeviceCharacteristicState() : super([]);
}

class DataDeviceCharacteristicState extends DeviceCharacteristicState {
  DataDeviceCharacteristicState(List<num> impulses) : super(impulses);
}

class DeviceCharacteristicBloc extends Cubit<DeviceCharacteristicState> {
  DeviceCharacteristicBloc({@required int id})
      : super(LoadingDeviceCharacteristicState()) {
    _getDeviceCharacteristic(id: id);
  }

  final _deviceRepository = DeviceRepository();

  Future<void> _getDeviceCharacteristic({int id}) async {
    emit(LoadingDeviceCharacteristicState());
    final res = await _deviceRepository.getDeviceCharacteristic(id);
    emit(DataDeviceCharacteristicState(res));
  }
}
