import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/models/device.dart';
import 'package:packet_tracer/models/experiment.dart';
import 'package:packet_tracer/repository/device_repository.dart';
import 'package:packet_tracer/utils/toast.dart';

abstract class AddDeviceState {
  final bool canSend;

  AddDeviceState(this.canSend);
}

class LoadingAddDeviceState extends AddDeviceState {
  LoadingAddDeviceState(bool canSend) : super(canSend);
}

class DataAddDeviceState extends AddDeviceState {
  DataAddDeviceState(bool canSend) : super(canSend);

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class SuccessAddDeviceState extends AddDeviceState {
  SuccessAddDeviceState(bool canSend) : super(canSend);
}

class AddDeviceBloc extends Cubit<AddDeviceState> {
  AddDeviceBloc() : super(LoadingAddDeviceState(false)) {
    _loadDeviceTypes();
  }

  final _addDeviceRepository = DeviceRepository();

  final List<Experiment> experiments = [
    Experiment(),
    Experiment(),
    Experiment(),
    Experiment(),
    Experiment(),
  ];

  List<DeviceType> types = [];

  int index = 0;

  String _name = '';

  bool _disposed = false;

  void setName(String value) {
    _name = value;
    emit(DataAddDeviceState(_canSend()));
  }

  void setIndex(int value) {
    index = value;
    emit(DataAddDeviceState(_canSend()));
  }

  Future<void> _loadDeviceTypes() async {
    try {
      types = await _addDeviceRepository.getDeviceTypes();
      emit(DataAddDeviceState(_canSend()));
    } catch (e) {
      if (!_disposed) {
        _loadDeviceTypes();
      }
    }
  }

  Future<void> pickFile({int exp = 0, bool isOtp = true}) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowCompression: false,
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      final file = result.files.single;
      if (isOtp) {
        experiments[exp].otp = file;
      } else {
        experiments[exp].pol = file;
      }
    }
    emit(DataAddDeviceState(_canSend()));
  }

  bool _canSend() =>
      experiments
              .map((e) => e.otp != null && e.pol != null)
              .where((e) => e)
              .length ==
          experiments.length &&
      _name.isNotEmpty;

  void addExperiment() {
    experiments.add(Experiment());
    emit(DataAddDeviceState(false));
  }

  Future<void> sendFiles() async {
    emit(LoadingAddDeviceState(true));
    try {
      await _addDeviceRepository.sendDevice(
        experiments,
        _name,
        types[index].id,
      );
      emit(SuccessAddDeviceState(true));
      ToastMsg.showToast('Устройство успешно добавлено');
    } catch (e) {
      print(e);
      ToastMsg.showToast('Что-то пошло не так');
      emit(DataAddDeviceState(true));
    }
  }

  @override
  Future<void> close() {
    _disposed = true;
    return super.close();
  }
}
