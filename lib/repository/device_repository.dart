import 'package:packet_tracer/data_source/device_api.dart';
import 'package:packet_tracer/data_source/local_storage.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/experiment.dart';

class DeviceRepository {
  final _deviceApi = DeviceApi();

  Future<List<DeviceType>> getDeviceTypes() async {
    final token = LocalStorageApi.instance.getToken;
    final res = await _deviceApi.getDeviceTypes(token);
    return res;
  }

  Future<void> sendDevice(
    List<Experiment> experiments,
    String name,
    int id,
  ) async {
    final token = LocalStorageApi.instance.getToken;
    return await _deviceApi.sendDevice(token, experiments, name, id);
  }

  Future<List<num>> getDeviceCharacteristic(int id) async {
    final token = LocalStorageApi.instance.getToken;
    return await _deviceApi.getDeviceCharacteristic(token, id);
  }
}
