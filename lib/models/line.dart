import 'package:flutter/material.dart';

class Line {
  final Offset start;
  final Offset end;

  const Line({this.start, this.end});
}

class IndexLine {
  final int start;
  final int end;
  final num toStart;
  final num toEnd;

  const IndexLine({this.start, this.end, this.toStart, this.toEnd});

  factory IndexLine.fromJson(Map<String, dynamic> json) {
    // print("json['start'] ${json['to_start'].runtimeType}");
    // final type = json['start'].runtimeType;
    // try {
    //   print(json);
    //   print((json['start'] == null ? null : type is String ? int.parse(json['start']) : json['start']).runtimeType);
    //   print(json['start']);
    //   print(json['start'] == null);
    //   print(type is String);
    //   final x = IndexLine(
    //     start: int.parse(json['start']),
    //     end: int.parse(json['end']),
    //   );
    // } catch (e) {
    //   print('11231231131313131313');
    // }
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