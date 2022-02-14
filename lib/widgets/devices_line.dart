import 'package:flutter/material.dart';
import 'package:packet_tracer/bloc/main_data_bloc.dart';
import 'package:packet_tracer/models/widget_position.dart';
import 'package:packet_tracer/widgets/graph_dialog.dart';
import 'package:packet_tracer/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DevicesList extends StatelessWidget {
  final Offset offset;

  const DevicesList({Key key, this.offset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MainDataBloc>();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        color: Colors.grey.withOpacity(0.2),
        child: ListView.separated(
          itemCount: bloc.devices.length,
          padding: EdgeInsets.symmetric(horizontal: 30),
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, i) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => GraphDialog(device: bloc.devices[i]),
                  );
                },
                child: LongPressDraggable(
                  onDragEnd: (detail) {
                    bloc.addPosition(
                      WidgetPosition(
                        position: detail.offset,
                        localOffset: offset,
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
              ),
            );
          },
          separatorBuilder: (_, __) => SizedBox(width: 20),
        ),
      ),
    );
  }
}