import 'package:dio/dio.dart';
import 'package:packet_tracer/models/experiment.dart';
import 'package:packet_tracer/utils/utils.dart';

class DeviceApi {
  final Dio _client = Static.dio();

  Future<void> sendDevice(String token, List<Experiment> experiments) async {
    final List files = [];
    for (var i =0; i < experiments.length; i++) {
      files.add(MultipartFile.fromBytes(experiments.first.otp.bytes));
      files.add(MultipartFile.fromBytes(experiments.first.pol.bytes));
    }
    await _client.post(
      ApiPath.feedback,
      options: Options(headers: {'authorization': token}),
      data: files,
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
