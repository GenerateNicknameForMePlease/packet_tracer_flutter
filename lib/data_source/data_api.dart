import 'package:dio/dio.dart';
import 'package:packet_tracer/models/availability.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/line.dart';
import 'package:packet_tracer/models/template.dart';
import 'package:packet_tracer/utils/utils.dart';

class DataApi {
  final Dio _client = Static.dio();

  Future<List<Device>> getDevices(String token) async {
    final res = await _client.get(
      ApiPath.devicesList,
      options: Options(headers: {'authorization': token}),
    );
    final data = res.data['results'] as List;
    return data.map((e) => Device.fromJson(e)).toList();
  }

  Future<Template> getAvailability(String token, Template template) async {
    final res = await _client.post(
      ApiPath.getAvailability,
      options: Options(headers: {'authorization': token}),
      data: template.toJson(),
    );
    return Template.fromJson(res.data);
  }

  Future<List<Template>> save(String token, Template template) async {
    final res = await _client.post(
      ApiPath.userTemplates,
      options: Options(headers: {'authorization': token}),
      data: template.toJson(),
    );
    return (res.data as List)
        .map((e) => Template.fromJson(e))
        .toList();
  }

  Future<List<Template>> getTemplates(String token) async {
    final res = await _client.get(
      ApiPath.userTemplates,
      options: Options(headers: {'authorization': token}),
    );
    return (res.data as List)
        .map((e) => Template.fromJson(e))
        .toList();
  }
}
