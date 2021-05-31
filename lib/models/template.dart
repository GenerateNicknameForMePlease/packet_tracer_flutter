import 'package:flutter/material.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/line.dart';
import 'package:packet_tracer/models/widget_position.dart';

class Template {
  final List<WidgetPosition> nodes;
  final List<IndexLine> edges;
  final int id;
  final String image;

  const Template({this.nodes, this.edges, this.id, this.image});

  factory Template.init() {
    return Template(
      edges: [],
      nodes: [],
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
        ),
      );
    }
    return Template(
      edges: (json['edges'] as List).map((e) => IndexLine.fromJson(e)).toList(),
      nodes: nodes,
      id: json['id'],
      image: json['image'],
    );
  }

  Template copyWith({List<IndexLine> edges}) {
    return Template(
      image: image,
      id: id,
      edges: edges ?? this.edges,
      nodes: nodes,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['nodes'] = <String, dynamic>{};
    for (var i in nodes) {
      data['nodes']['${i.index}'] = i.toJson();
    }
    data['edges'] = [];
    for (var i in edges) {
      data['edges'].add(i.toJson());
    }
    return data;
  }
}