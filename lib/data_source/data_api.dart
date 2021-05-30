import 'package:dio/dio.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/utils/utils.dart';

class DataApi {
  final Dio _client = Static.dio();

  Future<List<Device>> getDevices(String token) async {
    final res = await _client.get(
      ApiPath.devicesList,
    );
    final data = res.data['results'] as List;
    return data.map((e) => Device.fromJson(e)).toList();
  }
}
