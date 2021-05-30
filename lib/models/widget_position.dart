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

  @override
  List<Object> get props => [index];
}