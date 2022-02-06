import 'package:flutter/material.dart';

class Line {
  final Offset start;
  final Offset end;

  const Line({this.start, this.end});
}

class IndexLine {
  // от какого элемента ведем
  final int start;
  // к какому элементу ведем
  final int end;
  // значение ИХ от start до end
  final num toStart;
  // значение ИХ от end до start
  final num toEnd;

  const IndexLine({this.start, this.end, this.toStart, this.toEnd});

  factory IndexLine.fromJson(Map<String, dynamic> json) {
    return IndexLine(
      start: int.parse(json['start']),
      end: int.parse(json['end']),
      toStart: json['to_start'],
      toEnd: json['to_end'],
    );
  }

  Map<String, dynamic> toJson() => {
    'start': start.toString(),
    'end': end.toString(),
  };
}