import 'package:packet_tracer/data_source/device_api.dart';
import 'package:packet_tracer/data_source/local_storage.dart';
import 'package:packet_tracer/models/experiment.dart';

class DeviceRepository {
  final _deviceApi = DeviceApi();

  Future<void> sendDevice(List<Experiment> experiments) async {
    final token = LocalStorageApi.instance.getToken;
    return await _deviceApi.sendDevice(token, experiments);
  }

  Future<List<num>> getDeviceCharacteristic(int id) async {
    final token = LocalStorageApi.instance.getToken;
    return await _deviceApi.getDeviceCharacteristic(token, id);
  }
}
