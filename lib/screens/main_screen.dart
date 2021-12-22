import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/bloc/main_data_bloc.dart';
import 'package:packet_tracer/bloc/user_bloc.dart';
import 'package:packet_tracer/models/line.dart';
import 'package:packet_tracer/models/widget_position.dart';
import 'package:packet_tracer/screens/profile_screen.dart';
import 'package:packet_tracer/utils/utils.dart';
import 'package:packet_tracer/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isConnectingMode = false;

  int _activeConnectingIndex;

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
          return BlocBuilder<MainDataBloc, MainDataState>(
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
                    child: Container(
                      color: Colors.white,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 120.0,
                          ),
                          for (var i in bloc.template.edges)
                            CustomPaint(
                              painter: LinePainter(
                                  line: Line(
                                    start:
                                        bloc.getPositionByIndex(i.start).center,
                                    end: bloc.getPositionByIndex(i.end).center,
                                  ),
                                  value: i.value),
                            ),
                          for (var i in bloc.template.nodes) ...[
                            Positioned(
                              left: i.position.dx,
                              top: i.position.dy,
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
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child: LongPressDraggable(
                                  onDragEnd: (detail) {
                                    bloc.addPosition(
                                      WidgetPosition(
                                        position: Offset(
                                          detail.offset.dx,
                                          detail.offset.dy,
                                        ),
                                        device: i.device,
                                        index: i.index,
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
                                  Text('Средняя задержка сети по кратчайшим маршрутам: ${bloc.template.result.toStringAsFixed(3)} мс'),
                                  const SizedBox(height: 16),
                                ],
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: bloc.getResultNew,
                                    child: Text('Рассчитать'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                const SizedBox(width: 20),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  DevicesList(),
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
  final num value;

  LinePainter({this.line, this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;
    canvas.drawLine(line.start, line.end, paint);
    if (value != null) {
      final textStyle = TextStyle(
        color: Colors.black,
        fontSize: 15,
      );
      final textSpan = TextSpan(
        text: '$value мс',
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
