import 'package:dio/dio.dart';
import 'package:packet_tracer/models/feedback.dart';
import 'package:packet_tracer/utils/utils.dart';

class FeedbackApi {
  final Dio _client = Static.dio();

  Future<void> sendFeedback(String token, FeedbackModel feedback) async {
    await _client.post(
      ApiPath.feedback,
      options: Options(headers: {'authorization': token}),
      data: feedback.toJson(),
    );
  }
}
