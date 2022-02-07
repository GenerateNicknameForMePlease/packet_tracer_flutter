import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/bloc/add_device_bloc.dart';
import 'package:packet_tracer/bloc/main_data_bloc.dart';
import 'package:packet_tracer/utils/utils.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  TextEditingController _controller;
  AddDeviceBloc bloc;

  @override
  void initState() {
    bloc = AddDeviceBloc();
    _controller = TextEditingController()
      ..addListener(() {
        bloc.setName(_controller.text);
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление своего устройства'),
        centerTitle: true,
        backgroundColor: AppColors.green25D366,
      ),
      body: BlocProvider.value(
        value: bloc,
        child: Builder(
          builder: (context) {
            return BlocConsumer<AddDeviceBloc, AddDeviceState>(
              listener: (_, state) {
                if (state is SuccessAddDeviceState) {
                  context.read<MainDataBloc>().reloadDevices();
                }
              },
              builder: (context, state) {
                final exp = bloc.experiments;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 20),
                          child: Text(
                            'Загрузите файлы в формате .txt с данными времени отправления/прибытия пакетов. \nЗагрузите от 5 до 10 разных измерений',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount:
                                exp.length >= 10 ? exp.length : exp.length + 3,
                            shrinkWrap: true,
                            itemBuilder: (_, i) {
                              if (i == exp.length) {
                                return Center(
                                  child: SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        hintText: 'Название устройства',
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (i == exp.length + 1) {
                                return Center(
                                  child: ListView.separated(
                                      itemCount: bloc.types.length,
                                      shrinkWrap: true,
                                      itemBuilder: (_, j) {
                                        return Center(
                                          child: SizedBox(
                                            width: 200,
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: bloc.index == j,
                                                  onChanged: (value) {
                                                    bloc.setIndex(j);
                                                  },
                                                ),
                                                const SizedBox(width: 16),
                                                Text(bloc.types[j].name),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      separatorBuilder: (_, __) {
                                        return SizedBox(height: 8);
                                      }),
                                );
                              }
                              if (i == exp.length + 2) {
                                return Center(
                                  child: IconButton(
                                    onPressed: () {
                                      bloc.addExperiment();
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _Item(
                                    fileName: exp[i].otp?.name,
                                    index: i,
                                    isOtp: true,
                                  ),
                                  const SizedBox(width: 40),
                                  _Item(
                                    fileName: exp[i].pol?.name,
                                    index: i,
                                    isOtp: false,
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (_, __) {
                              return SizedBox(height: 30);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 20),
                          child: ElevatedButton(
                            onPressed: bloc.sendFiles,
                            style: ButtonStyle(
                              backgroundColor: state.canSend
                                  ? null
                                  : MaterialStateProperty.all<Color>(
                                      Colors.black12),
                            ),
                            child: Text('Добавить устройство'),
                          ),
                        ),
                      ],
                    ),
                    if (state is LoadingAddDeviceState)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String fileName;
  final index;
  final bool isOtp;

  const _Item({
    this.fileName,
    this.index,
    this.isOtp,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AddDeviceBloc>().pickFile(
              exp: index,
              isOtp: isOtp,
            );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(isOtp ? 'Отправитель' : 'Получатель'),
          const SizedBox(height: 10),
          Container(
            height: 50,
            width: 140,
            color: fileName == null ? Colors.grey : AppColors.green25D366,
            child: Center(
              child: Text(
                fileName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
