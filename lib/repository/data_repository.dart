import 'package:packet_tracer/data_source/data_api.dart';
import 'package:packet_tracer/data_source/local_storage.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/line.dart';
import 'package:packet_tracer/models/template.dart';

class DataRepository {
  final _dataApi = DataApi();

  Future<List<Device>> getDevices() async {
    final token = LocalStorageApi.instance.getToken;
    return await _dataApi.getDevices(token);
  }

  Future<List<Template>> getTemplates() async {
    final token = LocalStorageApi.instance.getToken;
    return await _dataApi.getTemplates(token);
  }

  Future<List<IndexLine>> getResult(Template template) async {
    final token = LocalStorageApi.instance.getToken;
    return await _dataApi.getResult(token, template);
  }

  Future<List<Template>> save(Template template) async {
    final token = LocalStorageApi.instance.getToken;
    return await _dataApi.save(token, template);
  }
}
