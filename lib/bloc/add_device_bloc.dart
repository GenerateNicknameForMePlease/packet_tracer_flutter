import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/models/experiment.dart';
import 'package:packet_tracer/repository/add_device_repository.dart';
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
  AddDeviceBloc() : super(DataAddDeviceState(false));

  final _addDeviceRepository = AddDeviceRepository();

  final List<Experiment> experiments = [
    Experiment(),
    Experiment(),
    Experiment(),
    Experiment(),
    Experiment(),
  ];

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
    final canSend = experiments
            .map((e) => e.otp != null && e.pol != null)
            .where((e) => e)
            .length ==
        experiments.length;
    emit(DataAddDeviceState(canSend));
  }

  void addExperiment() {
    experiments.add(Experiment());
    emit(DataAddDeviceState(false));
  }

  Future<void> sendFiles() async {
    emit(LoadingAddDeviceState(true));
    try {
      await _addDeviceRepository.sendDevice(experiments);
      emit(SuccessAddDeviceState(true));
      ToastMsg.showToast('Обращение успешно зарегистрировано!\n'
          'Проверьте почту для получения дополнительной информации');
    } catch (e) {
      print(e);
      ToastMsg.showToast('Что-то пошло не так');
      emit(DataAddDeviceState(true));
    }
  }
}
