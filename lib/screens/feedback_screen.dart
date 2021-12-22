import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/bloc/feedback_bloc.dart';
import 'package:packet_tracer/utils/toast.dart';
import 'package:packet_tracer/utils/utils.dart';
import 'package:packet_tracer/widgets/widgets.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController _titleController;

  TextEditingController _bodyController;

  @override
  void initState() {
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Обращение в техническую поддержку'),
        centerTitle: true,
        backgroundColor: AppColors.green25D366,
      ),
      body: BlocProvider(
        create: (_) => FeedbackBloc(),
        child: Builder(
          builder: (context) {
            final bloc = context.watch<FeedbackBloc>();
            return BlocBuilder<FeedbackBloc, FeedbackState>(
              builder: (context, state) {
                return Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Тема',
                            ),
                            controller: _titleController,
                          ),
                        ),
                        const SizedBox(height: 100),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _bodyController,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'Сообщение',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 20,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_titleController.value.text.isEmpty ||
                              _bodyController.value.text.isEmpty) {
                            ToastMsg.showToast(
                                'Все поля должны быть заполнены');
                            return;
                          }
                          bloc.sendFeedback(
                            title: _titleController.value.text,
                            body: _bodyController.value.text,
                          );
                        },
                        child: state is LoadingFeedbackState
                            ? ButtonLoader()
                            : Text('Отправить обращение'),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
