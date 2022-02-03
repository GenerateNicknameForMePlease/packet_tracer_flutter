import 'package:packet_tracer/data_source/add_device_api.dart';
import 'package:packet_tracer/data_source/local_storage.dart';
import 'package:packet_tracer/models/experiment.dart';

class AddDeviceRepository {
  final _addDeviceApi = AddDeviceApi();

  Future<void> sendDevice(List<Experiment> experiments) async {
    final token = LocalStorageApi.instance.getToken;
    return await _addDeviceApi.sendDevice(token, experiments);
  }
}
