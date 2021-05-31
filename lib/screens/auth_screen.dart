import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/bloc/sign_bloc.dart';
import 'package:packet_tracer/screens/main_screen.dart';
import 'package:packet_tracer/utils/constants.dart';
import 'package:packet_tracer/utils/toast.dart';
import 'package:packet_tracer/utils/utils.dart';

class AuthScreen extends StatefulWidget {
  final bool isRegistration;

  const AuthScreen({
    Key key,
    this.isRegistration = false,
  }) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _loginController;

  TextEditingController _passwordController;

  @override
  void initState() {
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: BlocProvider(
        create: (_) => SignBloc(),
        child: BlocConsumer<SignBloc, SignState>(
          listener: (_, state) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => MainScreen()),
              (route) => false,
            );
          },
          listenWhen: (_, c) => c is SuccessSignState,
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.isRegistration ? 'Регистрация' : 'Вход'),
                backgroundColor: AppColors.green25D366,
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        controller: _loginController,
                      ),
                    ),
                    const SizedBox(height: 100),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                        ),
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 200),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_loginController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            ToastMsg.showToast(
                                'Все поля обязательны для заполнения');
                            return;
                          }
                          if (!RegExp(Constants.emailRegex)
                              .hasMatch(_loginController.text)) {
                            ToastMsg.showToast('Введен некорректный email');
                            return;
                          }
                          if (widget.isRegistration) {
                            context.read<SignBloc>().registration(
                                  login: _loginController.text,
                                  password: _passwordController.text,
                                );
                          } else {
                            context.read<SignBloc>().login(
                                  login: _loginController.text,
                                  password: _passwordController.text,
                                );
                          }
                        },
                        child: state is LoadingSignState
                            ? CircularProgressIndicator()
                            : Text(
                                widget.isRegistration ? 'Регистрация' : 'Вход',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
