import 'package:flutter/material.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/line.dart';
import 'package:packet_tracer/models/widget_position.dart';

import 'availability.dart';

class Template {
  final List<WidgetPosition> nodes;
  final List<IndexLine> edges;
  final int id;
  final String image;
  final int directiveTime;
  final Availability result;
  final Offset localOffset;

  const Template({
    this.nodes,
    this.edges,
    this.id,
    this.image,
    this.directiveTime,
    this.result,
    this.localOffset,
  });

  factory Template.init() {
    return Template(
      edges: [],
      nodes: [],
      directiveTime: 0,
      localOffset: Offset.zero,
    );
  }

  factory Template.fromJson(Map<String, dynamic> json) {
    final nodes = <WidgetPosition>[];
    final data = (json['nodes'] as Map<String, dynamic>);
    for (var i in data.entries) {
      nodes.add(
        WidgetPosition(
          index: int.parse(i.key),
          device: Device.fromJson(i.value['device']),
          position: Offset(i.value['offset'][0], i.value['offset'][1]),
          localOffset: i.value['local_offset'] == null
              ? null
              : Offset(i.value['local_offset'][0], i.value['local_offset'][1]),
        ),
      );
    }
    return Template(
      edges: (json['edges'] as List).map((e) => IndexLine.fromJson(e)).toList(),
      nodes: nodes,
      id: json['id'],
      image: json['image'],
      directiveTime: json['directive_time'] ?? 0,
      result: json['availability'] == null
          ? null
          : Availability.fromJson(json['availability']),
      localOffset: json['local_offset'] == null
          ? Offset.zero
          : Offset(json['local_offset'][0], json['local_offset'][1]),
    );
  }

  Template copyWith({
    List<IndexLine> edges,
    Availability result,
    int directiveTime,
    Offset localOffset,
  }) {
    return Template(
      image: image,
      id: id,
      edges: edges ?? this.edges,
      nodes: nodes,
      result: result ?? this.result,
      directiveTime: directiveTime ?? this.directiveTime,
      localOffset: localOffset ?? this.localOffset,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['nodes'] = <String, dynamic>{};
    for (var i in nodes) {
      data['nodes'][i.index.toString()] = i.toJson();
    }
    data['edges'] = [];
    for (var i in edges) {
      data['edges'].add(i.toJson());
    }
    data['directive_time'] = directiveTime;
    data['local_offset'] = [localOffset.dx, localOffset.dy];
    print(data);
    return data;
  }
}
