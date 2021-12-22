import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/bloc/main_data_bloc.dart';
import 'package:packet_tracer/models/template.dart';
import 'package:packet_tracer/screens/feedback_screen.dart';
import 'package:packet_tracer/utils/utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
        centerTitle: true,
        backgroundColor: AppColors.green25D366,
      ),
      body: BlocBuilder<MainDataBloc, MainDataState>(
        builder: (context, snapshot) {
          final bloc = context.watch<MainDataBloc>();
          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Мои шаблоны',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: bloc.templates.length,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, i) {
                              return Center(
                                child: _Template(
                                  template: bloc.templates[i],
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => const SizedBox(
                              width: 35,
                            ),
                          ),
                        ),
                        if (bloc.templates.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                bloc.setTemplate(Template.init());
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Column(
                                children: [
                                  Icon(Icons.add, size: 30),
                                  Text('Добавить шаблон'),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FeedbackScreen(),
                      ),
                    );
                  },
                  child: Text('Создать обращение в техподдержку'),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _Template extends StatelessWidget {
  final Template template;

  const _Template({Key key, this.template}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 5;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.read<MainDataBloc>().setTemplate(template);
          Navigator.of(context).pop();
        },
        behavior: HitTestBehavior.opaque,
        child: CachedNetworkImage(
          imageUrl: template.image,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
