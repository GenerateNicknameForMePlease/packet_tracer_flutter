import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/bloc/main_data_bloc.dart';
import 'package:packet_tracer/bloc/user_bloc.dart';
import 'package:packet_tracer/models/line.dart';
import 'package:packet_tracer/models/template.dart';
import 'package:packet_tracer/models/widget_position.dart';
import 'package:packet_tracer/screens/profile_screen.dart';
import 'package:packet_tracer/utils/utils.dart';
import 'package:packet_tracer/widgets/graph_dialog.dart';
import 'package:packet_tracer/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController _controller;

  bool _isConnectingMode = false;

  int _activeConnectingIndex;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _getPosition(WidgetPosition position, Template template) {
    return Offset(
      position.position.dx +
          (position.localOffset.dx - template.localOffset.dx) * -1,
      position.position.dy +
          (position.localOffset.dy - template.localOffset.dy) * -1,
    );
  }

  Offset _getCenterOffset(WidgetPosition position, Template template) {
    final offset = _getPosition(position, template);
    return Offset(
      offset.dx + 45,
      offset.dy + 32,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is LoadingUserState) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          }
          return BlocConsumer<MainDataBloc, MainDataState>(
            listener: (_, __) {
              final bloc = context.read<MainDataBloc>();
              if (bloc.template.directiveTime !=
                  int.tryParse(_controller.text)) {
                _controller.clear();
              }
            },
            builder: (context, state) {
              if (state is LoadingMainDataState) {
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                );
              }
              final bloc = context.watch<MainDataBloc>();
              return Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onPanUpdate: (e) {
                        bloc.setLocalOffset(e.delta);
                      },
                      child: Container(
                        color: Colors.white,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 500000,
                              height: 500000,
                            ),
                            for (var i in bloc.template.edges)
                              CustomPaint(
                                painter: LinePainter(
                                  line: Line(
                                    start: _getCenterOffset(
                                      bloc.getPositionByIndex(i.start),
                                      bloc.template,
                                    ),
                                    end: _getCenterOffset(
                                      bloc.getPositionByIndex(i.end),
                                      bloc.template,
                                    ),
                                  ),
                                  indexLine: i,
                                ),
                              ),
                            for (var i in bloc.template.nodes) ...[
                              Positioned(
                                left: _getPosition(i, bloc.template).dx,
                                top: _getPosition(i, bloc.template).dy,
                                child: GestureDetector(
                                  onTap: () {
                                    if (_isConnectingMode) {
                                      if (_activeConnectingIndex == null) {
                                        setState(() {
                                          _activeConnectingIndex = i.index;
                                        });
                                      } else {
                                        if (_activeConnectingIndex != i.index) {
                                          final start = _activeConnectingIndex;
                                          _activeConnectingIndex = null;
                                          bloc.addConnect(
                                            start: start,
                                            end: i.index,
                                          );
                                        }
                                      }
                                    } else {
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: LongPressDraggable(
                                    onDragEnd: (detail) {
                                      bloc.addPosition(
                                        WidgetPosition(
                                          position: detail.offset,
                                          device: i.device,
                                          index: i.index,
                                          localOffset:
                                              bloc.template.localOffset,
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    childWhenDragging: DragItem(
                                      opacity: 0.5,
                                      color: Colors.grey,
                                      device: i.device,
                                      index: i.index,
                                    ),
                                    feedback: Material(
                                      child: DragItem(
                                        color: Colors.grey,
                                        device: i.device,
                                        index: i.index,
                                      ),
                                    ),
                                    child: DragItem(
                                      device: i.device,
                                      index: i.index,
                                      color: _activeConnectingIndex == i.index
                                          ? AppColors.green25D366
                                          : null,
                                      showDelete: true,
                                      onDelete: () => bloc.removePosition(i),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            Positioned(
                              left: 20,
                              bottom: 5,
                              child: SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: bloc.save,
                                  child: Text('Сохранить шаблон'),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              bottom: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (bloc.template.result != null) ...[
                                    Text(
                                        'Минимальная доступность: ${bloc.template.result.minAvailability}%\nМаксимальная доступность: ${bloc.template.result.maxAvailability}%'),
                                    const SizedBox(height: 16),
                                  ],
                                  SizedBox(
                                    width: 200,
                                    child: ElevatedButton(
                                      onPressed: bloc.getAvailability,
                                      child: Text('Рассчитать'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _isConnectingMode,
                                          onChanged: (v) {
                                            setState(() {
                                              _isConnectingMode = v;
                                              if (_isConnectingMode == false) {
                                                _activeConnectingIndex = null;
                                              }
                                            });
                                          },
                                        ),
                                        Text('Режим соединения'),
                                        const Spacer(),
                                        IconButton(
                                          icon: Icon(Icons.account_circle),
                                          iconSize: 30,
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => ProfileScreen(),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                        'Смещение: ${bloc.template.localOffset.dx.toInt()}, ${bloc.template.localOffset.dy.toInt()}'),
                                    Text(
                                        'Директивное время: ${bloc.template.directiveTime ?? ''}'),
                                    SizedBox(
                                      width: 200,
                                      child: TextField(
                                        controller: _controller,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          hintText: 'Директивное время, мс',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        bloc.setDirectiveTime(
                                          int.parse(_controller.text),
                                        );
                                        _controller.clear();
                                      },
                                      child: Text('Изменить'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  DevicesList(
                    offset: bloc.template.localOffset,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Line line;
  final IndexLine indexLine;

  LinePainter({this.line, this.indexLine});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;
    canvas.drawLine(line.start, line.end, paint);
    if (indexLine.toStart != null) {
      final textStyle = TextStyle(
        color: Colors.black,
        fontSize: 15,
      );
      final textSpan = TextSpan(
        text:
            'От ${indexLine.start} до ${indexLine.end}: ${indexLine.toEnd} мс\nОт ${indexLine.end} до ${indexLine.start}: ${indexLine.toStart} мс',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
      );
      final middleX = (line.start.dx + line.end.dx).abs() / 2;
      final middleY = (line.start.dy + line.end.dy).abs() / 2;
      final xCenter = (middleX - (textPainter.width / 2));
      final yCenter = (middleY - (textPainter.height / 2));
      final offset = Offset(xCenter, yCenter);
      final paint2 = Paint()..color = AppColors.green25D366;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(middleX, middleY),
          width: textPainter.width + 10,
          height: textPainter.height + 10,
        ),
        paint2,
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
