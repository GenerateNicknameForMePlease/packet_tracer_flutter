import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/models/feedback.dart';
import 'package:packet_tracer/repository/feedback_repository.dart';
import 'package:packet_tracer/utils/toast.dart';

abstract class FeedbackState {}

class LoadingFeedbackState extends FeedbackState {}

class DataFeedbackState extends FeedbackState {}

class SuccessFeedbackState extends FeedbackState {}

class FeedbackBloc extends Cubit<FeedbackState> {
  FeedbackBloc() : super(DataFeedbackState());

  final _feedbackRepository = FeedbackRepository();

  Future<void> sendFeedback({String title, String body}) async {
    emit(LoadingFeedbackState());
    final feedback = FeedbackModel(title: title, body: body);
    try {
      await _feedbackRepository.sendFeedback(feedback);
      emit(SuccessFeedbackState());
      ToastMsg.showToast('Обращение успешно зарегистрировано!\n'
          'Проверьте почту для получения дополнительной информации');
    } catch (e) {
      print(e);
      ToastMsg.showToast('Что-то пошло не так');
      emit(DataFeedbackState());
    }
  }

}
