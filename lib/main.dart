import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:packet_tracer/app.dart';
import 'package:packet_tracer/bloc/main_data_bloc.dart';
import 'package:packet_tracer/bloc/user_bloc.dart';
import 'package:packet_tracer/data_source/local_storage.dart';
import 'package:packet_tracer/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageApi().init();
  Intl.defaultLocale ='ru';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserBloc()),
        BlocProvider(create: (_) => MainDataBloc()),
      ],
      child: MaterialApp(
        title: 'Delay calculator',
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ru', ''),
        ],
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: _NoAnimations(),
            TargetPlatform.iOS: _NoAnimations(),
            TargetPlatform.linux: _NoAnimations(),
            TargetPlatform.macOS: _NoAnimations(),
            TargetPlatform.windows: _NoAnimations(),
          }),
          primarySwatch: Colors.blue,
          buttonTheme: ButtonThemeData(
            focusColor: AppColors.green25D366,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.green25D366),
            ),
          ),
        ),
        home: App(),
      ),
    );
  }
}

class _NoAnimations extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
