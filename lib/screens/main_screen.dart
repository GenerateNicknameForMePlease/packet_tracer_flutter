import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/bloc/main_data_bloc.dart';
import 'package:packet_tracer/bloc/user_bloc.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/widget_position.dart';
import 'package:packet_tracer/utils/utils.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
              print(bloc.positions.map((e) => e.index));
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Stack(
                        children: [
                          for (var i in bloc.positions) ...[
                            Positioned(
                              left: i.position.dx,
                              top: i.position.dy,
                              child: LongPressDraggable(
                                onDragEnd: (detail) {
                                  bloc.addPosition(
                                    WidgetPosition(
                                      position: detail.offset,
                                      device: i.device,
                                      index: i.index,
                                    ),
                                  );
                                  setState(() {});
                                },
                                childWhenDragging: SizedBox(),
                                feedback: Material(
                                  child: _DragItem(
                                    color: Colors.grey,
                                    device: i.device,
                                  ),
                                ),
                                child: _DragItem(device: i.device),
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    color: Colors.grey.withOpacity(0.2),
                    child: ListView.separated(
                      itemCount: bloc.devices.length,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) {
                        return Center(
                          child: LongPressDraggable(
                            onDragEnd: (detail) {
                              print(detail.offset);
                              bloc.addPosition(WidgetPosition(
                                position: detail.offset,
                                device: bloc.devices[i],
                                index: bloc.positions.length + 1,
                              ));
                              setState(() {});
                            },
                            feedback: Material(
                              child: _DragItem(
                                color: Colors.grey,
                                device: bloc.devices[i],
                              ),
                            ),
                            child: _DragItem(
                              device: bloc.devices[i],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(width: 20),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _DragItem extends StatelessWidget {
  final Device device;
  final Color color;

  const _DragItem({
    Key key,
    this.color,
    this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 63,
            height: 63,
            color: color,
            child: CachedNetworkImage(
              imageUrl: device.imageUrl,
              width: 63,
              height: 63,
            ),
          ),
          const SizedBox(height: 10),
          Text(device.name),
        ],
      ),
    );
  }
}
