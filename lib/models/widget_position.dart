import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:packet_tracer/models/device.dart';

class WidgetPosition extends Equatable {
  final Device device;
  final Offset position;
  final Offset localOffset;
  final int index;

  const WidgetPosition({
    this.index,
    this.device,
    this.position,
    this.localOffset,
  });

  WidgetPosition copyWith({int index, bool isLocalMove}) {
    return WidgetPosition(
      index: index ?? this.index,
      device: device,
      position: position,
      localOffset: localOffset,
    );
  }

  Offset get center => Offset(
        position.dx + localOffset.dx + 45,
        position.dy + localOffset.dy + 32,
      );

  @override
  List<Object> get props => [index];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['device_id'] = device.id;
    data['offset'] = [position.dx, position.dy];
    data['local_offset'] = [localOffset.dx, localOffset.dy];
    return data;
  }
}
