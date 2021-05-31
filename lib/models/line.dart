import 'package:flutter/material.dart';

class Line {
  final Offset start;
  final Offset end;

  const Line({this.start, this.end});
}

class IndexLine {
  final int start;
  final int end;
  final num value;

  const IndexLine({this.start, this.end, this.value});

  factory IndexLine.fromJson(Map<String, dynamic> json) {
    return IndexLine(
      start: json['start'],
      end: json['end'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
    'start': start,
    'end': end,
    'value': value,
  };
}