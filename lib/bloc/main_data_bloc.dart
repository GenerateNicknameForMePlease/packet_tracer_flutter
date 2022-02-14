import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/line.dart';
import 'package:packet_tracer/models/template.dart';
import 'package:packet_tracer/models/widget_position.dart';
import 'package:packet_tracer/repository/data_repository.dart';
import 'package:packet_tracer/utils/constants.dart';

abstract class MainDataState {
  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}

class LoadingMainDataState extends MainDataState {}

class DataMainDataState extends MainDataState {}

class LoadMainDataState extends MainDataState {}

class MainDataBloc extends Cubit<MainDataState> {
  MainDataBloc() : super(LoadingMainDataState());

  final _dataRepository = DataRepository();

  List<Template> _templates = [];

  List<Template> get templates => _templates;

  Template _bufTemplate;

  Template get template => _bufTemplate;

  List<Device> _devices;

  List<Device> get devices => _devices;

  int _counter = 1;

  Future<void> load() async {
    emit(LoadingMainDataState());
    try {
      _devices = await _dataRepository.getDevices();
      _templates = await _dataRepository.getTemplates();
      _bufTemplate = Template.init();
      emit(DataMainDataState());
    } catch (e) {
      print(e);
      await Future.delayed(Constants.requestDuration);
      load();
    }
  }

  Future<void> reloadDevices() async {
    _devices = await _dataRepository.getDevices();
    emit(DataMainDataState());
  }

  WidgetPosition getPositionByIndex(int index) => _bufTemplate.nodes.firstWhere(
        (e) => e.index == index,
      );

  void setTemplate(Template template) {
    _bufTemplate = template;
    emit(DataMainDataState());
  }

  void addPosition(WidgetPosition position) {
    _bufTemplate.nodes.remove(position);
    if (position.index == null) {
      position = position.copyWith(index: _counter);
      _counter += 1;
    }
    _bufTemplate.nodes.add(position);
    emit(DataMainDataState());
  }

  void removePosition(WidgetPosition position) {
    _bufTemplate.nodes.remove(position);
    _bufTemplate.edges.removeWhere(
      (e) => e.end == position.index || e.start == position.index,
    );
    emit(DataMainDataState());
  }

  void addConnect({int start, int end}) {
    if (_bufTemplate.edges.any((e) => e.start == start && e.end == end)) {
      return;
    }
    _bufTemplate.edges.add(IndexLine(start: start, end: end));
    emit(DataMainDataState());
  }

  void setDirectiveTime(int time) {
    _bufTemplate = _bufTemplate.copyWith(
      directiveTime: time,
    );
    emit(DataMainDataState());
  }

  void setLocalOffset(Offset offset) {
    _bufTemplate = _bufTemplate.copyWith(
      localOffset: _bufTemplate.localOffset + offset,
    );
    emit(DataMainDataState());
  }

  Future<void> getAvailability() async {
    emit(LoadMainDataState());
    // try {
      final res = await _dataRepository.getAvailability(_bufTemplate);
      _bufTemplate = res;
      emit(DataMainDataState());
    // } catch (e) {
    //   print(e);
    // }
  }


  Future<void> save() async {
    try {
      _templates = await _dataRepository.save(_bufTemplate);
      _bufTemplate = Template.init();
      emit(DataMainDataState());
    } catch (e) {
      print(e);
    }
  }
}
