import 'package:packet_tracer/data_source/feedback_api.dart';
import 'package:packet_tracer/data_source/local_storage.dart';
import 'package:packet_tracer/models/feedback.dart';

class FeedbackRepository {
  final _feedbackApi = FeedbackApi();

  Future<void> sendFeedback(FeedbackModel feedback) async {
    final token = LocalStorageApi.instance.getToken;
    return await _feedbackApi.sendFeedback(token, feedback);
  }
}
