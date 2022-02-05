import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/bloc/add_device_bloc.dart';
import 'package:packet_tracer/utils/utils.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление своего устройства'),
        centerTitle: true,
        backgroundColor: AppColors.green25D366,
      ),
      body: BlocProvider(
        create: (_) => AddDeviceBloc(),
        child: Builder(
          builder: (context) {
            return BlocBuilder<AddDeviceBloc, AddDeviceState>(
              builder: (context, state) {
                final bloc = context.watch<AddDeviceBloc>();
                final exp = bloc.experiments;
                print('sdfsdfsdf ${exp.length}');
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 20),
                          child: Text(
                            'Загрузите файлы в формате .txt с данными времени отправления/прибытия пакетов. \nЗагрузите 5 разных измерений',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: exp.length == 10 ? exp.length : exp.length + 1,
                            itemBuilder: (_, i) {
                              if (i == exp.length) {
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
                            onPressed: () {},
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
