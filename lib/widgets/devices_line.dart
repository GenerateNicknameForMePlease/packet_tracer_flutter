import 'package:flutter/material.dart';
import 'package:packet_tracer/bloc/main_data_bloc.dart';
import 'package:packet_tracer/models/widget_position.dart';
import 'package:packet_tracer/utils/utils.dart';
import 'package:packet_tracer/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DevicesList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MainDataBloc>();
    return Container(
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
                bloc.addPosition(
                  WidgetPosition(
                    position: Offset(
                      detail.offset.dx - Constants.leftSize,
                      detail.offset.dy,
                    ),
                    device: bloc.devices[i],
                  ),
                );
              },
              feedback: Material(
                child: DragItem(
                  color: Colors.grey,
                  device: bloc.devices[i],
                ),
              ),
              child: DragItem(
                device: bloc.devices[i],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 20),
      ),
    );
  }
}