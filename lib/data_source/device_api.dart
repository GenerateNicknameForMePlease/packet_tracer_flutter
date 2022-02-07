import 'package:dio/dio.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/experiment.dart';
import 'package:packet_tracer/utils/utils.dart';

class DeviceApi {
  final Dio _client = Static.dio();

  Future<List<DeviceType>> getDeviceTypes(String token) async {
    final res = await _client.get(
      ApiPath.deviceTypes,
      options: Options(headers: {'authorization': token}),
    );
    return (res.data as List).map((e) => DeviceType.fromJson(e)).toList();
  }

  Future<void> sendDevice(
    String token,
    List<Experiment> experiments,
    String name,
    int id,
  ) async {
    FormData data = FormData.fromMap({
      'name': name,
      'device_type_id': id,
    });
    for (var i = 0; i < experiments.length; i++) {
      final file1 = MultipartFile.fromBytes(experiments[i].otp.bytes, filename: experiments[i].otp.name);
      final file2 = MultipartFile.fromBytes(experiments[i].pol.bytes, filename: experiments[i].pol.name);
      data.files.add(MapEntry('in_$i', file1));
      data.files.add(MapEntry('out_$i', file2));
    }
    await _client.post(
      ApiPath.addDevice,
      options: Options(headers: {'authorization': token}),
      data: data,
    );
  }

  Future<List<num>> getDeviceCharacteristic(String token, int id) async {
    final res = await _client.get(
      '${ApiPath.deviceCharacteristic}$id',
      options: Options(headers: {'authorization': token}),
    );
    final list = (res.data['IH'] as List).cast<num>();
    return list.sublist(200, list.length - 200);
  }
}
