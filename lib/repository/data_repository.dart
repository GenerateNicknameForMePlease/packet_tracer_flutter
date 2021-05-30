import 'package:packet_tracer/data_source/data_api.dart';
import 'package:packet_tracer/data_source/local_storage.dart';
import 'package:packet_tracer/models/device.dart';

class DataRepository {
  final _dataApi = DataApi();

  Future<List<Device>> getDevices() async {
    final token = LocalStorageApi.instance.getToken;
    return await _dataApi.getDevices(token);
  }
}