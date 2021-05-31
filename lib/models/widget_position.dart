import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:packet_tracer/models/device.dart';

class WidgetPosition extends Equatable {
  final Device device;
  final Offset position;
  final int index;

  const WidgetPosition({this.index, this.device, this.position});

  WidgetPosition copyWith({int index}) {
    return WidgetPosition(
      index:  index ?? this.index,
      device: device,
      position: position,
    );
  }

  Offset get center => Offset(position.dx + 45, position.dy + 32);

  @override
  List<Object> get props => [index];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['device_id'] = device.id;
    data['offset'] = [position.dx, position.dy];
    return data;
  }
}